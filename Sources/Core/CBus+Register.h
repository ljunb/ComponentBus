//
//  CBus+Register.h
//  CBus
//
//  Created by ljunb on 2021/9/11.
//

#import <CBus/CBus.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBus (Register)

/**
 * 注册一个动态组件
 *
 */
+ (void)registerDynamicComponentForClass:(Class)componentClass;

/**
 * 通过类型取消注册一个动态组件
 * @param componentClass 组件类型
 */
+ (void)unregisterDynamicComponentForClass:(Class)componentClass;

/**
 * 通过名称注册一个动态组件
 * @param componentName 组件名称
 */
+ (void)unregisterDynamicComponentForName:(NSString *)componentName;


@end

NS_ASSUME_NONNULL_END
