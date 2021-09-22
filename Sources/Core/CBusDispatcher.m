//
//  CBusDispatcher.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusDispatcher.h"
#import "CBus.h"
#import "CBusAsyncCall.h"
#import "CBusException.h"

@implementation CBusDispatcher {
    NSOperationQueue *_dispatchQueue;
}

- (instancetype)init {
    if (self = [super init]) {
        _dispatchQueue = [[NSOperationQueue alloc] init];
        _dispatchQueue.maxConcurrentOperationCount = 64;
        _dispatchQueue.name = @"com.xiaopeng.cbus_dispatcher_async_queue";
    }
    return self;
}

- (void)enqueue:(CBusAsyncCall *)asyncCall {
    // 加入队列
    [_dispatchQueue addOperation:asyncCall];
}

- (void)onResult:(CBus *)cbus completion:(CBusAsyncCallCompletion)completion {
    if (!completion) {
        return;
    }
    // invoke on main thread
    if (cbus.request.isDeliverOnMainThread) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(cbus);
        });
    } else {
        completion(cbus);
    }
}

- (void)cancelAllCalls {
    [_dispatchQueue cancelAllOperations];
}

@end
