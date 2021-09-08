//
//  CBusClient.h
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import <Foundation/Foundation.h>

@class CBus;
@class CBusRealCall;
@class CBusDispatcher;

NS_ASSUME_NONNULL_BEGIN

@interface CBusClient : NSObject

@property (nonatomic, strong, readonly) CBusDispatcher *dispatcher;

- (CBusRealCall *)newCall:(CBus *)cbus;

@end

NS_ASSUME_NONNULL_END
