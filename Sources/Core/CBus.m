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
    BOOL _isFinished;
    BOOL _isWaiting;
    dispatch_semaphore_t _lock;
}

@synthesize client = _client;
@synthesize request = _request;
@synthesize response = _response;

+ (instancetype)cbusWithRequest:(CBusRequest *)request {
    return [[self alloc] initWithRequest:request];
}

- (instancetype)initWithRequest:(CBusRequest *)request {
    if (self = [super init]) {
        _lock = dispatch_semaphore_create(1);
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
    CBus_LOCK(_lock);
    if (!_isFinished) {
        _isFinished = YES;
        _response = response;
        
        // todo: notify async call completion
    }
    CBus_UNLOCK(_lock);
}


#pragma mark - Dynamic Component register
+ (void)registerDynamicComponentForClass:(Class)componentClass {
    [CBusComponentRegister registerDynamicComponentForClass:componentClass];
}

+ (void)unregisterDynamicComponentForClass:(Class)componentClass {
    [CBusComponentRegister unregisterDynamicComponentForClass:componentClass];
}

+ (void)unregisterDynamicComponentForName:(NSString *)componentName {
    [CBusComponentRegister unregisterDynamicComponentForName:componentName];
}


#pragma mark - getter
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

@end
