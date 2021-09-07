//
//  CBus.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBus : NSObject

@property (nonatomic, strong) CBusResponse *response;

+ (BOOL)open:(CBusRequest *)request context:(nullable UIViewController *)context complete:(nullable CBusAsyncCallResponse)complete;

+ (CBus *)execute:(CBusRequest *)request;
+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallResponse)complete;

@end

NS_ASSUME_NONNULL_END
