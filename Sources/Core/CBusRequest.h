//
//  CBusRequest.h
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import <Foundation/Foundation.h>

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


+ (instancetype)requestWithComponent:(NSString *)component
                              action:(NSString *)action
                              params:(nullable NSDictionary *)params;

+ (instancetype)requestWithComponent:(NSString *)component
                              action:(NSString *)action
                              params:(nullable NSDictionary *)params
                             timeout:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END
