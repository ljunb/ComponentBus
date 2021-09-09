//
//  CBusDispatcher.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusDispatcher.h"
#import "CBusDefines.h"
#import "CBus.h"
#import "CbusComponent.h"
#import "CBusRequest.h"
#import "CBusRealCall.h"


@implementation CBusDispatcher {
    NSMutableArray *_runningSyncCalls;
    NSMutableArray *_runningAsyncCalls;
    NSMutableArray *_readyAsyncCalls;
    
    dispatch_semaphore_t _lock;
    NSOperationQueue *_dispatchQueue;
}

- (instancetype)init {
    if (self = [super init]) {
        _runningSyncCalls = [NSMutableArray array];
        _runningAsyncCalls = [NSMutableArray array];
        _readyAsyncCalls = [NSMutableArray array];
        _lock = dispatch_semaphore_create(1);
        _dispatchQueue = [[NSOperationQueue alloc] init];
        _dispatchQueue.maxConcurrentOperationCount = 64;
        _dispatchQueue.name = @"com.xiaopeng.cbus_dispatcher_async_queue";
    }
    return self;
}

- (void)executed:(CBusRealCall *)call {
    CBusRequest *request = call.cbus.request;
    
    id<CBusComponent> component = [CBusGetComponentMap() objectForKey:request.component];
    NSString *targetActionStr = [NSString stringWithFormat:@"__cbus_action__%@:", request.action];
    SEL actionSel = NSSelectorFromString(targetActionStr);
    
    if ([component conformsToProtocol:@protocol(CBusComponent)] && [component respondsToSelector:actionSel]) {
        // 已经达到最大值
        if (_dispatchQueue.operationCount >= _dispatchQueue.maxConcurrentOperationCount) {
            CBus_LOCK(_lock);
            [_readyAsyncCalls addObject:call];
            CBus_UNLOCK(_lock);
            return;
        }
        
        CBus_LOCK(_lock);
        [_runningSyncCalls addObject:call];
        CBus_UNLOCK(_lock);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [component performSelector:actionSel withObject:call.cbus];
#pragma clang diagnostic pop
    }
}

- (void)enqueue:(CBusRealCall *)call complete:(nonnull CBusAsyncCallCompletion)complete {
    CBusRequest *request = call.cbus.request;
    id<CBusComponent> component = [CBusGetComponentMap() objectForKey:request.component];
    NSString *targetActionStr = [NSString stringWithFormat:@"__cbus_action__%@:", request.action];
    SEL actionSel = NSSelectorFromString(targetActionStr);
    
    if ([component conformsToProtocol:@protocol(CBusComponent)] && [component respondsToSelector:actionSel]) {
        NSBlockOperation *asyncBlock = [[NSBlockOperation alloc] init];
        __weak typeof(asyncBlock) weakBlock = asyncBlock;
        [asyncBlock addExecutionBlock:^{
            if (weakBlock.isCancelled) {
                return;
            }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [component performSelector:actionSel withObject:call.cbus];
#pragma clang diagnostic pop
        }];
        [_dispatchQueue addOperation:asyncBlock];
        
        CBus_LOCK(_lock);
        [_runningAsyncCalls addObject:call];
        CBus_UNLOCK(_lock);
    }
}

- (void)finished:(CBusRealCall *)call {
    // todo: 结束调用后，移除不再计算超时
    CBus_LOCK(_lock);
    [_runningSyncCalls removeObject:call];
    CBus_UNLOCK(_lock);
}

- (void)cancelAllCalls {
    [_dispatchQueue cancelAllOperations];
}

@end
