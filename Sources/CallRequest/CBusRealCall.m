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
        [_client.dispatcher beginCall:self];
        // 拿到结果后，需要更新到cbus
        CBusResponse *response = [self responseOnInterceptorChain];
        [_cbus finished:response];
        return response;
    } @catch (NSException *exception) {
        // todo timeout
        NSLog(@"exception: %@", [exception userInfo]);
        return [CBusResponse error:exception.userInfo];
    } @finally {
        [_client.dispatcher finishedCall:self];
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
    [_client.dispatcher beginCall:asyncCall];
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
    // custom interceptors
    [interceptors addObjectsFromArray:_client.interceptors];
    // cbus interceptors
    [interceptors addObject:[CBusComponentInterceptor sharedInterceptor]];
    [interceptors addObject:[CBusResponseInterceptor sharedInterceptor]];
    
    id<CBusChain> chain = [CBusInterceptorChain chainWithInterceptors:interceptors index:0 cbus:_cbus call:self];
    return [chain proceed];
}

@end
