//
//  CBusRealCall.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBusClient;
@class CBus;

NS_ASSUME_NONNULL_BEGIN

@interface CBusRealCall : NSObject

@property (nonatomic, strong, readonly) CBus *cbus;
@property (nonatomic, strong, readonly) CBusClient *client;

+ (instancetype)realCallWithClient:(CBusClient *)client cbus:(CBus *)cbus;

- (void)execute;
- (void)enqueue:(CBusAsyncCallResponse)callback;

@end

NS_ASSUME_NONNULL_END
