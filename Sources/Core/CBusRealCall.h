//
//  CBusRealCall.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusClient;

NS_ASSUME_NONNULL_BEGIN

@interface CBusRealCall : NSObject

@property (nonatomic, strong, readonly) CBus *cbus;
@property (nonatomic, strong, readonly) CBusClient *client;

+ (instancetype)realCallWithClient:(CBusClient *)client cbus:(CBus *)cbus;

/// 同步执行一个方法
- (void)execute;

/**
 * 执行异步方法
 *
 * @param callback 异步回调
 */
- (void)enqueue:(CBusAsyncCallCompletion)callback;

@end

NS_ASSUME_NONNULL_END
