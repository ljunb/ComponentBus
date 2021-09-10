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
@protocol CBusInterceptor;

NS_ASSUME_NONNULL_BEGIN

@interface CBusClient : NSObject

@property (nonatomic, strong, readonly) CBusDispatcher *dispatcher;
@property (nonatomic, copy, readonly) NSArray<id<CBusInterceptor>> *interceptors;

- (CBusRealCall *)newCall:(CBus *)cbus;

- (void)addInterceptor:(id<CBusInterceptor>)interceptor;

@end

NS_ASSUME_NONNULL_END
