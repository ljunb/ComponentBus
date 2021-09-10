//
//  CBusDispatcher.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusRealCall;
@class CBusAsyncCall;

NS_ASSUME_NONNULL_BEGIN

@interface CBusDispatcher : NSObject

/**
 * 执行一个同步调用
 * @param call 同步调用实体
 */
- (void)executed:(CBusRealCall *)call;

/**
 * 执行一个异步调用
 * @param asyncCall 异步调用实体
 */
- (void)enqueue:(CBusAsyncCall *)asyncCall;

/**
 * 触发异步方法回调
 * @param cbus 回调参数，响应结果的cbus实例
 * @param completion 结束回调
 */
- (void)onResult:(CBus *)cbus completion:(CBusAsyncCallCompletion)completion;

/**
 * 结束一个同步调用，从内存中进行超时管理的字典中移除
 * @param call 同步调用实体
 */
- (void)finishedCall:(CBusRealCall *)call;

/**
 * 结束一个异步调用，从内存中进行超时管理的字典中移除
 * @param asyncCall 异步调用实体
 */
- (void)finishedAsyncCall:(CBusAsyncCall *)asyncCall;

/// 取消所有的异步方法调用
- (void)cancelAllCalls;

@end

NS_ASSUME_NONNULL_END
