//
//  CBusInterceptorChain.h
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "CBusInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBusInterceptorChain : NSObject<CBusChain>

+ (instancetype)chainWithInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors
                                index:(NSInteger)index
                                 cbus:(CBus *)cbus
                                 call:(id<CBusCall>)call;

@end

NS_ASSUME_NONNULL_END
