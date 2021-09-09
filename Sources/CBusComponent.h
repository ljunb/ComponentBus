//
//  CBusModule.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/3.
//

#import <Foundation/Foundation.h>
#import "CBusDefines.h"

@class CBus;
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol CBusComponent <NSObject>

/**
 * 根据组件名称获取对应的实例
 * @param cmpName 组件名称
 * @return 组件实例，静态组件or动态组件
 */
CBUS_EXTERN id<CBusComponent> CBusGetComponentInstanceForName(NSString *cmpName);


/**
 * 注册一个静态组件，会初始化空实例。
 * 如果提供了 `name`，那么将作为该组件的名称；否则将其Class字符串作为名称。
 */
#define CBUS_COMPONENT(name) \
CBUS_EXTERN void CBusResigterComponent(Class); \
+ (NSString *)componentName { return @#name; } \
+ (void)load { CBusResigterComponent(self); }


/**
 * 注册一个动态组件，将不会进行初始化
 */
#define CBUS_DYNAMIC_COMPONENT(name) \
CBUS_COMPONENT(#name) \
+ (BOOL)isDynamic { return YES; } \


/**
 * 标记一个可用于其他组件访问的方法
 */
#define CBUS_ACTION(sel_name) \
- (void)__cbus_action__##sel_name:(CBus *)cbus CBUS_OBJC_DYNAMIC


@optional
/// 是否动态组件
+ (BOOL)isDynamic;

/// 组件名称
+ (NSString *)componentName;

@end

NS_ASSUME_NONNULL_END
