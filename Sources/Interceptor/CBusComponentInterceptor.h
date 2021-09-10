//
//  CBusComponentInterceptor.h
//  CBus
//
//  Created by linjunbing on 2021/9/10.
//

#import <Foundation/Foundation.h>
#import "CBusInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

/// 组件拦截器，方法亦是在此触发
@interface CBusComponentInterceptor : NSObject<CBusInterceptor>

@end

NS_ASSUME_NONNULL_END
