//
//  CBusResponse.h
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBusResponse : NSObject

/// 响应结果
@property (nonatomic, strong, readonly) NSDictionary *result;
/// 响应码
@property (nonatomic, assign, readonly) CBusCode code;
/// 是否响应成功
@property (nonatomic, assign, readonly, getter=isSuccess) BOOL success;

/**
 * 快速返回一个成功CBusResponse实例
 * @param result 响应结果
 * @return CBusResponse实例
 */
+ (instancetype)success:(NSDictionary *)result;

/**
 * 快速返回一个失败CBusResponse实例
 * @param code 失败code
 * @return CBusResponse实例
 */
+ (instancetype)errorCode:(CBusCode)code;

/**
 * 快速返回一个失败CBusResponse实例
 * @param result 响应结果，其code将设置为CBusCodeUnknown
 * @return CBusResponse实例
 */
+ (instancetype)error:(NSDictionary *)result;

/**
 * 快速返回一个失败CBusResponse实例
 * @param result 响应结果
 * @param code 响应code
 * @return CBusResponse实例
 */
+ (instancetype)error:(NSDictionary *)result code:(CBusCode)code;


@end

NS_ASSUME_NONNULL_END
