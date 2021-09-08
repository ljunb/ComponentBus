//
//  CBus.m
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import "CBus.h"

#import "CBusClient.h"
#import "CBusRealCall.h"
#import "CBusComponent.h"
#import "CBusResponse.h"
#import "CBusRequest.h"


static CBusClient *cbusClient;
CBusClient *CBusGetClient(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cbusClient = [[CBusClient alloc] init];
    });
    return cbusClient;
}


@implementation CBus {
    BOOL _isFinished;
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

+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action params:(NSDictionary *)params {
    CBusRequest *request = [CBusRequest requestWithComponent:component action:action params:params];
    return [self execute:request];
}

+ (CBus *)execute:(CBusRequest *)request {
    CBus *cbus = [CBus cbusWithRequest:request];
    [[cbus.client newCall:cbus] execute];
    return cbus;
}

+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallResponse)complete {
    CBus *cbus = [CBus cbusWithRequest:request];
    [[cbus.client newCall:cbus] enqueue:complete];
}

- (void)finished:(CBusResponse *)response {
    // todo: notify async callback
    CBus_LOCK(_lock);
    if (!_isFinished) {
        _isFinished = YES;
        _response = response;
    }
    CBus_UNLOCK(_lock);
}

@end
