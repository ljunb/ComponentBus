//
//  CBusDispatcher.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusAsyncCall;

NS_ASSUME_NONNULL_BEGIN

@interface CBusDispatcher : NSObject

/**
 * 开始执行一个异步调用
 * @param asyncCall 异步调用实体
 */
- (void)enqueue:(CBusAsyncCall *)asyncCall;

/**
 * 触发异步方法回调
 * @param cbus 回调参数，响应结果的cbus实例
 * @param completion 结束回调
 */
- (void)onResult:(CBus *)cbus completion:(CBusAsyncCallCompletion)completion;

/// 取消所有的异步方法调用
- (void)cancelAllCalls;

@end

NS_ASSUME_NONNULL_END
