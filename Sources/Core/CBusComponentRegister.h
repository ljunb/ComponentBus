//
//  CBusComponentRegister.h
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import <Foundation/Foundation.h>
#import "CBusComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBusComponentRegister : NSObject

/// 所有组件类型注册表，格式：{ componentName: componentClass }
@property (nonatomic, strong, readonly, class) NSDictionary<NSString *, Class> *allComponentClassMap;
/// 所有组件注册表，格式：{ componentName: id<CBusComponent> }
@property (nonatomic, copy, readonly, class) NSArray<id<CBusComponent>> *allComponents;
/// 静态组件注册表，格式：{ componentName: id<CBusComponent> }
@property (nonatomic, strong, readonly, class) NSDictionary<NSString *, id<CBusComponent>> *componentMap;
/// 动态组件注册表，格式：{ componentName: id<CBusComponent> }
@property (nonatomic, strong, readonly, class) NSDictionary<NSString *, id<CBusComponent>> *dynamicComponentMap;

/**
 * 根据组件名称返回对应实例
 * @param cmpName 组件名称
 * @return 组件实例，静态组件or动态组件
 */
+ (id<CBusComponent>)componentInstanceForName:(NSString *)componentName;

/**
 * 通过类型动态注册一个组件
 * @param componentClass 组件类型
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
