//
//  CBusInterceptor.h
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import <Foundation/Foundation.h>

@class CBus;
@class CBusResponse;
@protocol CBusCall;

NS_ASSUME_NONNULL_BEGIN

/// 职责链协议
@protocol CBusChain <NSObject>

/// 请求发起后，职责链上的CBus实例
- (CBus *)cbus;

/// 职责链继续响应方法，如不调用，职责链将会断裂
- (CBusResponse *)proceed;

/// 请求发起后，职责链上的CBusCall实例
- (id<CBusCall>)call;

@end


/// 拦截器协议
@protocol CBusInterceptor <NSObject>

@optional
/// 单例方法，如拦截器对象有常驻需要，则可实现该单例方法
+ (instancetype)sharedInterceptor;

/**
 * 拦截方法，可按需在此对请求进行拦截处理
 * @param chain 响应者链
 * @return 响应结果
 */
- (CBusResponse *)intercept:(id<CBusChain>)chain;

@end

NS_ASSUME_NONNULL_END
