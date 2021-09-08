//
//  CBusResponse.h
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBusResponse : NSObject

/// 响应结果
@property (nonatomic, strong, readonly) NSDictionary *result;
/// 响应码
@property (nonatomic, assign, readonly) NSInteger code;

@property (nonatomic, assign, readonly) BOOL success;

+ (instancetype)success:(NSDictionary *)response;
+ (instancetype)failed:(NSDictionary *)response;
+ (instancetype)failed:(NSDictionary *)response code:(NSInteger)code;

@end

NS_ASSUME_NONNULL_END
