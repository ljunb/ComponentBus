//
//  CBus.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"
#import "CBusRequest.h"
#import "CBusResponse.h"
#import "CBusClient.h"


NS_ASSUME_NONNULL_BEGIN

@interface CBus : NSObject
/// 每个cbus中绑定的client对象，其持有方法调用队列的管理者CBusDispatcher
@property (nonatomic, strong, readonly) CBusClient *client;
/// cbus的请求实体
@property (nonatomic, strong, readonly) CBusRequest *request;
/// cbus结果响应实体
@property (nonatomic, strong, readonly) CBusResponse *response;


/**
 * 快速发起一个同步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @return CBus实例，可通过实例取得对应的request、response
 */
+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action params:(nullable NSDictionary *)params;
+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action;

/**
 * 快速发起一个异步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @param complete 结束回调
 */
+ (void)asyncCallRequestWithComponent:(NSString *)component
                               action:(NSString *)action
                               params:(nullable NSDictionary *)params
                             complete:(nullable CBusAsyncCallCompletion)complete;
+ (void)asyncCallRequestWithComponent:(NSString *)component action:(NSString *)action params:(nullable NSDictionary *)params;
+ (void)asyncCallRequestWithComponent:(NSString *)component action:(NSString *)action;


/**
 * 触发一个同步请求
 *
 * @param request 请求实体
 */
+ (CBus *)execute:(CBusRequest *)request;

/**
 * 触发一个异步请求
 *
 * @param request 请求实体
 * @param complete 结束回调
 */
+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallCompletion)complete;


/**
 * 设置一个响应结果，代表方法调用结束
 * @param response 响应结果实体
 */
- (void)finished:(CBusResponse *)response;


/**
 * 自定义CBusClient对象
 * @param client 自定义client实例
 */
+ (void)setCBusClient:(CBusClient *)client;


#pragma mark - Dynamic Component register
/**
 * 注册一个动态组件
 *
 */
+ (void)registerDynamicComponentForClass:(Class)componentClass;
/**
 * 通过类型取消注册一个动态组件
 * @param componentClass 组件类型
 */
+ (void)unregisterDynamicComponentForClass:(Class)componentClass;

/**
 * 通过名称注册一个动态组件
 * @param componentName 组件名称
 */
+ (void)unregisterDynamicComponentForName:(NSString *)componentName;

@end

NS_ASSUME_NONNULL_END
