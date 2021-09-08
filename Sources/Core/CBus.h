//
//  CBus.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusRequest;
@class CBusResponse;
@class CBusClient;

NS_ASSUME_NONNULL_BEGIN

@interface CBus : NSObject
/// 每个cbus中绑定的client对象，其持有方法调用队列的管理者CBusDispatcher
@property (nonatomic, strong, readonly) CBusClient *client;
/// cbus的请求实体
@property (nonatomic, strong, readonly) CBusRequest *request;
/// cbus结果响应实体
@property (nonatomic, strong, readonly) CBusResponse *response;


/**
 * 快速发起一个CBusRequest
 *
 * @param component 组件名称
 * @param action 目标事件名称
 * @param params 请求参数
 * @return CBus实例，可通过实例取得对应的request、response
 */
+ (CBus *)callRequestWithComponent:(NSString *)component action:(NSString *)action params:(nullable NSDictionary *)params;


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
+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallResponse)complete;


/**
 * 设置一个响应结果，代表方法调用结束
 * @param response 响应结果实体
 */
- (void)finished:(CBusResponse *)response;

@end

NS_ASSUME_NONNULL_END
