//
//  CBus.m
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import "CBus.h"

#import "CBusClient.h"
#import "CBusRealCall.h"
#import "CBusComponentRegister.h"
#import "CBusComponent.h"

/**
 * CBus将内置一个默认的CBusClient，管理着默认的CBusDispatcher
 */
static CBusClient *cbusClient;
CBusClient *CBusGetClient(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cbusClient = [[CBusClient alloc] init];
    });
    return cbusClient;
}

// 环境相关
static BOOL _isDebug = NO;
static BOOL _isEnableLog = NO;


@implementation CBus {
    BOOL _isWaiting;
    NSCondition *_waitingLock;
}

@synthesize client = _client;
@synthesize request = _request;
@synthesize response = _response;
@synthesize isFinished = _isFinished;
@synthesize isCanceled = _isCanceled;


#pragma mark - CBus config
+ (void)configCBusInDebug:(BOOL)isDebug enableLog:(BOOL)enableLog {
    [self setIsDebug:isDebug];
    [self setIsEnableLog:enableLog];
}

+ (BOOL)isDebug {
    return _isDebug;
}

+ (void)setIsDebug:(BOOL)isDebug {
    _isDebug = isDebug;
}

+ (BOOL)isEnableLog {
    return _isEnableLog;
}

+ (void)setIsEnableLog:(BOOL)isEnableLog {
    _isEnableLog = isEnableLog;
}


#pragma mark - CBus instance handler
+ (instancetype)cbusWithRequest:(CBusRequest *)request {
    return [[self alloc] initWithRequest:request];
}

- (instancetype)initWithRequest:(CBusRequest *)request {
    if (self = [super init]) {
        _waitingLock = [[NSCondition alloc] init];
        _request = request;
        _client = CBusGetClient();
    }
    return self;
}

+ (void)setCBusClient:(CBusClient *)client {
    cbusClient = client;
}


#pragma mark - CBusRequest caller
+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action {
    return [self callRequestWithComponent:component action:action params:nil];
}

+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action params:(NSDictionary *)params {
    CBusRequest *request = [CBusRequest requestWithComponent:component action:action params:params];
    return [self execute:request];
}

+ (void)asyncCallRequestWithComponent:(NSString *)component action:(NSString *)action {
    [self asyncCallRequestWithComponent:component action:action params:nil complete:nil];
}

+ (void)asyncCallRequestWithComponent:(NSString *)component action:(NSString *)action params:(NSDictionary *)params {
    [self asyncCallRequestWithComponent:component action:action params:params complete:nil];
}

+ (void)asyncCallRequestWithComponent:(NSString *)component
                               action:(NSString *)action
                               params:(NSDictionary *)params
                             complete:(CBusAsyncCallCompletion)complete {
    CBusRequest *request = [CBusRequest requestWithComponent:component action:action params:params];
    [self enqueue:request complete:complete];
}

+ (void)asyncCallRequestWithComponent:(NSString *)component
                               action:(NSString *)action
                               params:(NSDictionary *)params
                 completeOnMainThread:(CBusAsyncCallCompletion)complete {
    CBusRequest *request = [CBusRequest requestWithComponent:component action:action params:params];
    [request deliverOnMainThread];
    [self enqueue:request complete:complete];
}

+ (CBus *)execute:(CBusRequest *)request {
    CBus *cbus = [CBus cbusWithRequest:request];
    [[cbus.client newCall:cbus] execute];
    return cbus;
}

+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallCompletion)complete {
    CBus *cbus = [CBus cbusWithRequest:request];
    [[cbus.client newCall:cbus] enqueue:complete];
}

- (void)finished:(CBusResponse *)response {
    // CBusResponse的设置可能位于不同线程，这里需要加锁
    [_waitingLock lock];
    
    if (!_isFinished) {
        _isFinished = YES;
        _response = response;
        
        // 异步调用时，将会进入waiting状态，那么需要唤醒线程继续执行
        if (_isWaiting) {
            _isWaiting = false;
            NSLog(@"wait response broadccast");
            [_waitingLock broadcast];
        }
    }
    [_waitingLock unlock];
}

- (void)cancel {
    [_waitingLock lock];
    _isCanceled = YES;
    [_waitingLock unlock];
}

- (void)waitResponse {
    // 异步调用，线程进入休眠
    [_waitingLock lock];
    if (!_isFinished) {
        @try {
            NSLog(@"wait response begin!");
            _isWaiting = YES;
            [_waitingLock wait];
        } @catch (NSException *exception) {
            
        }
    }
    [_waitingLock unlock];
}

@end
