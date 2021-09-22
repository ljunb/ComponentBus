//
//  CBusTimeoutInterceptor.m
//  CBus
//
//  Created by linjunbing on 2021/9/18.
//

#import "CBusTimeoutInterceptor.h"
#import "CBus.h"
#import "CBusException.h"

@implementation CBusTimeoutInterceptor

+ (instancetype)sharedInterceptor {
    static CBusTimeoutInterceptor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CBusTimeoutInterceptor alloc] init];
    });
    return instance;
}

- (CBusResponse *)intercept:(id<CBusChain>)chain {
    CBus *currentCBus = [chain cbus];
    dispatch_time_t timeout_t = dispatch_time(DISPATCH_TIME_NOW, currentCBus.request.timeout * NSEC_PER_SEC);
    dispatch_after(timeout_t, self.timeoutQueue, ^{
        if (!currentCBus.isFinished) {
            [currentCBus timedout];
        }
    });
    return [chain proceed];
}

- (dispatch_queue_t)timeoutQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.xiaopeng.cbus_timeout_async_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

@end
