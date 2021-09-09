//
//  CBusDispatcher.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusRealCall;

NS_ASSUME_NONNULL_BEGIN

@interface CBusDispatcher : NSObject

/**
 * 执行一个同步调用
 * @param call 同步调用实体
 */
- (void)executed:(CBusRealCall *)call;

/**
 * 执行一个异步调用
 */
- (void)enqueue:(CBusRealCall *)call complete:(CBusAsyncCallCompletion)complete;

/**
 * 结束一个同步调用
 * @param call 同步调用实体
 */
- (void)finished:(CBusRealCall *)call;

/// 取消所有的异步方法调用
- (void)cancelAllCalls;

@end

NS_ASSUME_NONNULL_END
