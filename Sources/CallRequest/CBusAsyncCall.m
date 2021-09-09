//
//  CBusAsyncCall.m
//  CBus
//
//  Created by ljunb on 2021/9/8.
//

#import "CBusAsyncCall.h"
#import "CBusRealCall.h"
#import "CBusComponent.h"
#import "CBusRequest.h"
#import "CBusException.h"

@implementation CBusAsyncCall

@synthesize executing = _executing;
@synthesize finished = _finished;
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
        if (self.cancelled) {
            [self done];
            return;
        }
        
        [self performRealCall];
    }
}

- (void)performRealCall {
    // we are ensure call request no-nil in dispather
    id<CBusComponent> component = CBusGetComponentInstanceForName(self.originRequest.component);
    NSString *targetActionStr = [NSString stringWithFormat:@"__cbus_action__%@:", self.originRequest.action];
    SEL actionSel = NSSelectorFromString(targetActionStr);
    
    if ([component respondsToSelector:actionSel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [component performSelector:actionSel withObject:_cbus];
#pragma clang diagnostic pop
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

- (CBusRequest *)originRequest {
    return _realCall.originRequest;
}

@end
