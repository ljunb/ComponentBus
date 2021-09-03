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

/**
 打开一个业务模块的某个页面
 
 @param moduleName 模块名称
 @param pageName 页面名称
 @param params 传递参数
 @param context 页面上下文
 */
+ (BOOL)openModule:(NSString *)moduleName
              page:(NSString *)pageName
            params:(nullable NSDictionary *)params
           context:(nullable __kindof UIViewController *)context;

/**
 打开一个业务模块的某个页面，并支持回调结果
 
 @param moduleName 模块名称
 @param pageName 页面名称
 @param params 传递参数
 @param context 页面上下文
 @param completion 结束回调
 */
+ (BOOL)openModule:(NSString *)moduleName
              page:(NSString *)pageName
            params:(nullable NSDictionary *)params
           context:(nullable __kindof UIViewController *)context
        completion:(nullable CBusCompletion)completion;

@end

NS_ASSUME_NONNULL_END
