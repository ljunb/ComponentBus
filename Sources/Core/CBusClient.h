//
//  CBusClient.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>

@class CBus;
@class CBusRealCall;
@class CBusDispatcher;
@protocol CBusInterceptor;

NS_ASSUME_NONNULL_BEGIN

@interface CBusClient : NSObject

/// 方法线程调度管理者
@property (nonatomic, strong, readonly) CBusDispatcher *dispatcher;
/// 自定义拦截器列表，全局生效
@property (nonatomic, copy, readonly) NSArray<id<CBusInterceptor>> *interceptors;

/**
 * 初始化一个调用请求
 * @param cbus 请求关联的CBus对象
 * @return 调用对象
 */
- (CBusRealCall *)newCall:(CBus *)cbus;

/**
 * 添加一个拦截器
 * @param interceptor 拦截器实例
 */
- (void)addInterceptor:(id<CBusInterceptor>)interceptor;

@end

NS_ASSUME_NONNULL_END
