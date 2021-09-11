//
//  CBusDispatcher.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@protocol CBusCall;

NS_ASSUME_NONNULL_BEGIN

@interface CBusDispatcher : NSObject

/**
 * 开始执行一个调用
 * @param call 同步或异步调用实体
 */
- (void)beginCall:(id<CBusCall>)call;

/**
 * 结束一个调用，从内存中进行超时管理的字典中移除
 * @param call 同步或异步调用的实例
 */
- (void)finishedCall:(id<CBusCall>)call;

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
