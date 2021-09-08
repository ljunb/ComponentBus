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

/// 获取当前所有的组件字典
CBUS_EXTERN NSDictionary<NSString *, id<CBusComponent>>* CBusGetComponentMap(void);

#define CBUS_REGISTER_COMPONENT(name) \
CBUS_EXTERN void CBusResigterComponent(Class); \
+ (NSString *)componentName { return @#name; } \
+ (void)load { CBusResigterComponent(self); }

+ (NSString *)componentName;

#define CBUS_ACTION(sel_name) \
- (void)__cbus_action__##sel_name:(CBus *)cbus CBUS_DYNAMIC

@end

NS_ASSUME_NONNULL_END
