//
//  CBusCall.h
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusResponse;
@class CBusRequest;

NS_ASSUME_NONNULL_BEGIN

@protocol CBusCall <NSObject>

/// 当前调用的request实例
@property (nonatomic, strong, readonly) CBusRequest *request;
/// 当前调用是否取消
@property (nonatomic, assign, readonly) BOOL isCancelled;

@optional
/// 当前调用是否执行过
@property (nonatomic, assign, readonly) BOOL isExecuted;

@optional
/// 同步执行一个方法
- (CBusResponse *)execute;

/**
 * 执行异步方法
 *
 * @param callback 异步回调
 */
- (void)enqueue:(CBusAsyncCallCompletion)callback;

/// 取消执行
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
