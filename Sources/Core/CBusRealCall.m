//
//  CBusRealCall.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusRealCall.h"
#import "CBusClient.h"
#import "CBusDispatcher.h"

@implementation CBusRealCall {
    BOOL _isExecuted;
    CBusAsyncCallResponse _asyncCallback;
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
    @try {
        [_client.dispatcher executed:self];
    } @catch (NSException *exception) {
        // todo timeout
    } @finally {
        [_client.dispatcher finished:self];
    }
}

- (void)enqueue:(CBusAsyncCallResponse)callback {
    @try {
        _asyncCallback = [callback copy];
        [_client.dispatcher enqueue:self complete:callback];
    } @catch (NSException *exception) {
        // todo timeout
    } @finally {
        [_client.dispatcher finished:self];
    }
}

@end
