//
//  CBusInterceptor.h
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import <Foundation/Foundation.h>

@class CBus;
@class CBusResponse;
@protocol CBusCall;

NS_ASSUME_NONNULL_BEGIN


@protocol CBusChain <NSObject>

- (CBus *)cbus;
- (CBusResponse *)proceed;
- (id<CBusCall>)call;

@end


@protocol CBusInterceptor <NSObject>

@optional
+ (instancetype)sharedInterceptor;

- (CBusResponse *)intercept:(id<CBusChain>)chain;

@end

NS_ASSUME_NONNULL_END
