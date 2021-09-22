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

#pragma mark - for class
/// YES：开启debug模式；否则不开启
@property (nonatomic, assign, class) BOOL isDebug;
/// 是否开启log
@property (nonatomic, assign, class) BOOL isEnableLog;

/**
 * 设置初始化环境
 * @param isDebug 是否开启debug模式
 * @param enableLog 开启日志
 */
+ (void)configCBusInDebug:(BOOL)isDebug enableLog:(BOOL)enableLog;

/**
 * 自定义CBusClient对象
 * @param client 自定义client实例
 */
+ (void)setCBusClient:(CBusClient *)client;


#pragma mark - for instance
/// 每个cbus中绑定的client对象，其持有方法调用队列的管理者CBusDispatcher
@property (nonatomic, strong, readonly) CBusClient *client;
/// cbus的请求实体
@property (nonatomic, strong, readonly) CBusRequest *request;
/// cbus结果响应实体
@property (nonatomic, strong, readonly) CBusResponse *response;
/// 是否响应结束
@property (nonatomic, assign, readonly) BOOL isFinished;
/// 是否取消
@property (nonatomic, assign, readonly) BOOL isCanceled;
/// 是否超时
@property (nonatomic, assign, readonly) BOOL isTimeout;

#pragma mark init request
/**
 * 快速发起一个同步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @param timeout 超时设置
 * @return CBus实例，可通过实例取得对应的request、response
 */
+ (CBus *)callRequestWithComponent:(NSString *)component
                            action:(NSString *)action
                            params:(nullable NSDictionary *)params
                           timeout:(NSTimeInterval)timeout;
/**
 * 快速发起一个同步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @return CBus实例，可通过实例取得对应的request、response
 */
+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action params:(nullable NSDictionary *)params;
/**
 * 快速发起一个同步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @return CBus实例，可通过实例取得对应的request、response
 */
+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action;

/**
 * 快速发起一个异步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @param timeout 超时设置
 * @param complete 结束回调
 */
+ (void)asyncCallRequestWithComponent:(NSString *)component
                               action:(NSString *)action
                               params:(nullable NSDictionary *)params
                              timeout:(NSTimeInterval)timeout
                             complete:(nullable CBusAsyncCallCompletion)complete;
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
/**
 * 快速发起一个异步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 */
+ (void)asyncCallRequestWithComponent:(NSString *)component action:(NSString *)action params:(nullable NSDictionary *)params;
/**
 * 快速发起一个异步CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 */
+ (void)asyncCallRequestWithComponent:(NSString *)component action:(NSString *)action;

/**
 * 快速发起一个异步CBusRequest，并将结束回调抛到主线程
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @param timeout 超时设置
 * @param complete 结束回调，将切回主线程
 */
+ (void)asyncCallRequestWithComponent:(NSString *)component
                               action:(NSString *)action
                               params:(nullable NSDictionary *)params
                              timeout:(NSTimeInterval)timeout
                 completeOnMainThread:(nullable CBusAsyncCallCompletion)complete;
/**
 * 快速发起一个异步CBusRequest，并将结束回调抛到主线程
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @param complete 结束回调，将切回主线程
 */
+ (void)asyncCallRequestWithComponent:(NSString *)component
                               action:(NSString *)action
                               params:(nullable NSDictionary *)params
                 completeOnMainThread:(nullable CBusAsyncCallCompletion)complete;

#pragma mark handle request
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

/// 取消当前调用
- (void)cancel;

/// 设置当前调用超时
- (void)timedout;

/// 等待一个异步响应
- (void)waitResponse;

@end

NS_ASSUME_NONNULL_END
