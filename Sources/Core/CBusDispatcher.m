//
//  CBusDispatcher.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusDispatcher.h"
#import "CBus.h"
#import "CBusComponentRegister.h"
#import "CBusRealCall.h"
#import "CBusAsyncCall.h"
#import "CBusException.h"

@implementation CBusDispatcher {
    NSMutableArray<CBusRealCall *> *_runningSyncCalls;
    NSMutableArray<CBusAsyncCall *> *_runningAsyncCalls;
    NSMutableArray<CBusAsyncCall *> *_readyAsyncCalls;
    
    dispatch_semaphore_t _lock;
    NSOperationQueue *_dispatchQueue;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = dispatch_semaphore_create(1);
        
        _runningSyncCalls = [NSMutableArray array];
        _runningAsyncCalls = [NSMutableArray array];
        _readyAsyncCalls = [NSMutableArray array];
        
        _dispatchQueue = [[NSOperationQueue alloc] init];
        _dispatchQueue.maxConcurrentOperationCount = 64;
        _dispatchQueue.name = @"com.xiaopeng.cbus_dispatcher_async_queue";
    }
    return self;
}

- (void)executed:(CBusRealCall *)call {
    CBus_LOCK(_lock);
    [_runningSyncCalls addObject:call];
    CBus_UNLOCK(_lock);
}

- (void)enqueue:(CBusAsyncCall *)asyncCall {
    CBusRequest *request = asyncCall.request;
    
    id<CBusComponent> component = [CBusComponentRegister componentInstanceForName:request.component];
    NSString *targetActionStr = [NSString stringWithFormat:@"__cbus_action__%@:", request.action];
    SEL actionSel = NSSelectorFromString(targetActionStr);
    
    if ([component conformsToProtocol:@protocol(CBusComponent)] && [component respondsToSelector:actionSel]) {
        // 加入队列
        [_dispatchQueue addOperation:asyncCall];
        
        CBus_LOCK(_lock);
        [_runningAsyncCalls addObject:asyncCall];
        CBus_UNLOCK(_lock);
    }
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


- (void)finishedCall:(CBusRealCall *)call {
    // todo: 结束调用后，移除不再计算超时
    CBus_LOCK(_lock);
    [_runningSyncCalls removeObject:call];
    CBus_UNLOCK(_lock);
}

- (void)finishedAsyncCall:(CBusAsyncCall *)asyncCall {
    // todo: 结束调用后，移除不再计算超时
    CBus_LOCK(_lock);
    [_runningAsyncCalls removeObject:asyncCall];
    CBus_UNLOCK(_lock);
}

- (void)cancelAllCalls {
    [_dispatchQueue cancelAllOperations];
}

@end
