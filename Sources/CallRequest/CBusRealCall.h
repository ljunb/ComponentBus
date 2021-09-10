//
//  CBusRealCall.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusCall.h"
#import "CBusDefines.h"

@class CBusClient;
@class CBusRequest;
@class CBusResponse;

NS_ASSUME_NONNULL_BEGIN

@interface CBusRealCall : NSObject<CBusCall>

/// 当前调用关联的cbus对象
@property (nonatomic, strong, readonly) CBus *cbus;
/// 当前调用关联的client对象
@property (nonatomic, strong, readonly) CBusClient *client;

/**
 * 基于client和cbus返回一个CBusRealCall实例
 * @param client 管理CBusDispatcher的实例
 * @param cbus 当前调用关联的cbus对象
 * @return 同步调用实例
 */
+ (instancetype)realCallWithClient:(CBusClient *)client cbus:(CBus *)cbus;

/// 从拦截链中获取响应结果
- (CBusResponse *)responseOnInterceptorChain;

@end

NS_ASSUME_NONNULL_END
