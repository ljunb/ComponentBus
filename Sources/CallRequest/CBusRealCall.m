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

@implementation CBusRealCall {
    BOOL _isExecuted;
}

@synthesize cbus = _cbus;
@synthesize client = _client;

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

- (void)execute {
    if (_isExecuted) {
        CBusResponse *res = [CBusResponse failedCode:CBusCodeAleadyExecuted];
        [_cbus finished:res];
        [_client.dispatcher finishedCall:self];
        return;
    }
    
    @try {
        _isExecuted = YES;
        [_client.dispatcher executed:self];
    } @catch (NSException *exception) {
        // todo timeout
        NSLog(@"exception: %@", [exception userInfo]);
    } @finally {
        [_client.dispatcher finishedCall:self];
    }
}

- (void)enqueue:(CBusAsyncCallCompletion)callback {
    if (_isExecuted) {
        CBusResponse *res = [CBusResponse failedCode:CBusCodeAleadyExecuted];
        [_cbus finished:res];
        [_client.dispatcher onResult:_cbus completion:callback];
        return;
    }
    
    CBusAsyncCall *asyncCall = [CBusAsyncCall asyncCallWithCBus:_cbus realCall:self completion:callback];
    [_client.dispatcher enqueue:asyncCall];
}

- (CBusRequest *)originRequest {
    return _cbus.request;
}

@end
