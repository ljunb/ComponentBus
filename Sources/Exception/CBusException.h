//
//  CBusException.h
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBusException : NSObject

+ (void)boom:(CBusCode)code;
+ (void)boom:(CBusCode)code exception:(NSException *)exception;
+ (void)boom:(CBusCode)code extraInfo:(NSDictionary *)extraInfo;
+ (void)boom:(CBusCode)code exception:(nullable NSException *)exception extraInfo:(nullable NSDictionary *)extraInfo;

@end

NS_ASSUME_NONNULL_END
