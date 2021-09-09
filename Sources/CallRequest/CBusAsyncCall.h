//
//  CBusAsyncCall.h
//  CBus
//
//  Created by ljunb on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBus;
@class CBusRealCall;
@class CBusRequest;

NS_ASSUME_NONNULL_BEGIN

@interface CBusAsyncCall : NSOperation

@property (nonatomic, strong, readonly) CBus *cbus;
@property (nonatomic, strong, readonly) CBusRealCall *realCall;
@property (nonatomic, copy, readonly) CBusAsyncCallCompletion completion;
@property (nonatomic, strong, readonly) CBusRequest *originRequest;

+ (instancetype)asyncCallWithCBus:(CBus *)cbus realCall:(CBusRealCall *)realCall completion:(CBusAsyncCallCompletion)completion;

@end

NS_ASSUME_NONNULL_END
