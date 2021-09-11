//
//  CBusAsyncCall.m
//  CBus
//
//  Created by ljunb on 2021/9/8.
//

#import "CBusAsyncCall.h"
#import "CBus.h"
#import "CBusRealCall.h"
#import "CBusComponent.h"
#import "CBusException.h"
#import "CBusDispatcher.h"

@implementation CBusAsyncCall

@synthesize executing = _executing;
@synthesize finished = _finished;
// from CBusCall properties
@synthesize cbus = _cbus;
@synthesize realCall = _realCall;
@synthesize completion = _completion;

+ (instancetype)asyncCallWithCBus:(CBus *)cbus
                         realCall:(CBusRealCall *)realCall
                       completion:(CBusAsyncCallCompletion)completion {
    return [[self alloc] initWithCBus:cbus realCall:realCall completion:completion];
}

- (instancetype)initWithCBus:(CBus *)cbus
                    realCall:(CBusRealCall *)realCall
                  completion:(CBusAsyncCallCompletion)completion {
    if (self = [super init]) {
        _cbus = cbus;
        _realCall = realCall;
        _completion = completion;
    }
    return self;
}


- (void)start {
    @autoreleasepool {
        self.executing = YES;
        if (self.isCancelled) {
            [self done];
            return;
        }
        // start task
        [self handleAsyncCallCompletion];
    }
}

- (void)handleAsyncCallCompletion {
    @try {
        CBusResponse *response = [_realCall responseOnInterceptorChain];
        // check if canceled
        if (_cbus.isCanceled || self.isCancelled) {
            response = [CBusResponse errorCode:CBusCodeCanceled];
        }
        // call completion
        [_cbus finished:response];
        [_realCall.client.dispatcher onResult:_cbus completion:_completion];
    } @catch (NSException *exception) {
        // todo: handle timeout
        NSLog(@"NSException %@", [exception userInfo]);
    } @finally {
        // invoke if current thread wake up
        [self done];
        [_realCall.client.dispatcher finishedAsyncCall:self];
    }
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
}

-(void)setExecuting:(BOOL)executing {
   [self willChangeValueForKey:@"isExecuting"];
   _executing = executing;
   [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (CBusRequest *)request {
    return _realCall.request;
}

@end
