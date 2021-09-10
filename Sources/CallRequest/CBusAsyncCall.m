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
        [self performRealCall];
        [self handleAsyncCallCompletion];
    }
}

- (void)performRealCall {
    // we are ensure call request no-nil in dispather
    id<CBusComponent> component = CBusGetComponentInstanceForName(self.request.component);
    NSString *targetActionStr = [NSString stringWithFormat:@"__cbus_action__%@:", self.request.action];
    SEL actionSel = NSSelectorFromString(targetActionStr);
    
    if ([component respondsToSelector:actionSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [component performSelector:actionSel withObject:_cbus];
#pragma clang diagnostic pop
    }
}

- (void)handleAsyncCallCompletion {
    @try {
        CBusResponse *response = [_realCall responseOnInterceptorChain];
        // check if canceled
        if (_cbus.isCanceled || self.isCancelled) {
            response = [CBusResponse failedCode:CBusCodeCanceled];
        }
        // call completion
        [_cbus finished:response];
        [_realCall.client.dispatcher onResult:_cbus completion:_completion];
    } @catch (NSException *exception) {
        NSLog(@"NSException %@", [exception userInfo]);
    } @finally {
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
