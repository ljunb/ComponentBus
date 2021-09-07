//
//  CBusModule.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol CBusComponent <NSObject>

#define CBUS_REGISTER_COMPONENT(name) \
CBUS_EXTERN void CBusResigterComponent(Class); \
+ (NSString *)componentName { return @#name; } \
+ (void)load { CBusResigterComponent(self); }

+ (NSString *)componentName;

CBUS_EXTERN NSDictionary<NSString *, id<CBusComponent>>* CBusGetComponentMap(void);


@required
/**
 用于页面路由的方法，不同业务方可通过实现该方法，然后在内部通过 pageName 进行页面区分。
 
 @param pageName 页面名称，如 community
 @param params 传递的参数
 @param context 当前跳转前的页面上下文
 @param completion 结束回调
 @return 当成功拦截事件后，返回 YES，否则返回 NO
 */
- (BOOL)openPage:(NSString *)pageName
          params:(nullable NSDictionary *)params
         context:(nullable __kindof UIViewController *)context
      completion:(nullable CBusAsyncCallResponse)completion;

@end

NS_ASSUME_NONNULL_END
