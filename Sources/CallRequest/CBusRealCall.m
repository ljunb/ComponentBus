//
//  CBusRealCall.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusRealCall.h"
#import "CBus.h"
#import "CBusDispatcher.h"
#import "CBusAsyncCall.h"
#import "CBusInterceptor.h"
#import "CBusInterceptorChain.h"
#import "CBusComponentInterceptor.h"
#import "CBusResponseInterceptor.h"
#import "CbusTimeoutInterceptor.h"
#import "CBusException.h"

@implementation CBusRealCall

@synthesize cbus = _cbus;
@synthesize client = _client;
@synthesize isExecuted = _isExecuted;

+ (instancetype)realCallWithClient:(CBusClient *)client cbus:(CBus *)cbus {
    return [[self alloc] initWithClient:client cbus:cbus];
}

- (instancetype)initWithClient:(CBusClient *)client cbus:(CBus *)cbus {
    if (self = [super init]) {
        _cbus = cbus;
        _client = client;
        _isExecuted = NO;
    }
    return self;
}

- (CBusResponse *)execute {
    if (_isExecuted) {
        return [CBusResponse errorCode:CBusCodeAleadyExecuted];
    }
    
    @try {
        _isExecuted = YES;
        return [self responseOnInterceptorChain];
    } @catch (NSException *exception) {
        return [CBusResponse error:exception.userInfo];
    }
}

- (void)enqueue:(CBusAsyncCallCompletion)callback {
    if (_isExecuted) {
        CBusResponse *res = [CBusResponse errorCode:CBusCodeAleadyExecuted];
        [_cbus finished:res];
        [_client.dispatcher onResult:_cbus completion:callback];
        return;
    }
    
    CBusAsyncCall *asyncCall = [CBusAsyncCall asyncCallWithCBus:_cbus realCall:self completion:callback];
    [_client.dispatcher enqueue:asyncCall];
}

- (CBusRequest *)request {
    return _cbus.request;
}

- (BOOL)isCancelled {
    return _cbus.isCanceled;
}

- (BOOL)isExecuted {
    return _isExecuted;
}

- (void)cancel {
    [_cbus cancel];
}

- (CBusResponse *)responseOnInterceptorChain {
    NSMutableArray<id<CBusInterceptor>> *interceptors = [NSMutableArray array];
    // custom request interceptors
    [interceptors addObjectsFromArray:_cbus.request.interceptors];
    // custom client interceptors
    [interceptors addObjectsFromArray:_client.interceptors];
    // cbus interceptors
    [interceptors addObject:[CBusTimeoutInterceptor sharedInterceptor]];
    [interceptors addObject:[CBusComponentInterceptor sharedInterceptor]];
    [interceptors addObject:[CBusResponseInterceptor sharedInterceptor]];
    
    id<CBusChain> chain = [CBusInterceptorChain chainWithInterceptors:interceptors index:0 cbus:_cbus call:self];
    return [chain proceed];
}

@end
