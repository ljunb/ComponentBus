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

@property (nonatomic, assign, readonly) BOOL success;

+ (instancetype)success:(NSDictionary *)response;

+ (instancetype)failedCode:(CBusCode)code;
+ (instancetype)failed:(NSDictionary *)response;
+ (instancetype)failed:(NSDictionary *)response code:(CBusCode)code;

@end

NS_ASSUME_NONNULL_END
