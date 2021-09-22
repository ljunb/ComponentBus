//
//  CBusRequest.h
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import <Foundation/Foundation.h>

@protocol CBusInterceptor;


/// 同步调用默认2.5s超时
#define CBusRequestSyncTimeout 2.5
/// 异步调用默认60s超时
#define CBusRequestAsyncTimeout 60

NS_ASSUME_NONNULL_BEGIN

@interface CBusRequest : NSObject

/// 组件名称
@property (nonatomic, copy, readonly) NSString *component;
/// 事件名称
@property (nonatomic, copy, readonly) NSString *action;
/// 请求参数
@property (nonatomic, strong, readonly) NSDictionary *params;
/// 超时设置
@property (nonatomic, assign, readonly) NSTimeInterval timeout;
/// 是否在主线程结束回调
@property (nonatomic, assign, readonly) BOOL isDeliverOnMainThread;
/// 当前请求的拦截器
@property (nonatomic, copy, readonly) NSArray<id<CBusInterceptor>> *interceptors;

/**
 * 返回一个请求实例
 * @param component 组件名称
 * @param action 组件通信方法
 * @param params 通信参数
 * @return 请求实例
 */
+ (instancetype)requestWithComponent:(NSString *)component
                              action:(NSString *)action
                              params:(nullable NSDictionary *)params;

/**
 * 返回一个请求实例
 * @param component 组件名称
 * @param action 组件通信方法
 * @param params 通信参数
 * @param timeout 超时时间，单位秒
 * @return 请求实例
 */
+ (instancetype)requestWithComponent:(NSString *)component
                              action:(NSString *)action
                              params:(nullable NSDictionary *)params
                             timeout:(NSTimeInterval)timeout;

/// 结束回调切换回主线程
- (void)deliverOnMainThread;

/**
 * 添加一个请求拦截器
 * @param interceptor 拦截器实例
 */
- (void)addInterceptor:(id<CBusInterceptor>)interceptor;

/**
 * 批量添加请求拦截器
 * @param interceptors 拦截器列表
 */
- (void)addInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors;

/**
 * 设置超时时间
 * @param timeout 超时时间
 */
- (void)setTimeout:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END
