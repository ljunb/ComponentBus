//
//  CBusComponentRegister.m
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import "CBusComponentRegister.h"
#import "CBusComponent.h"


static NSMutableArray<Class> *CBusComponentClasses;
static NSMutableDictionary<NSString *, id<CBusComponent>> *CBusComponentMap;
static NSMutableDictionary<NSString *, id<CBusComponent>> *CBusDynamicComponentMap;
static dispatch_queue_t CBusComponentSyncQueue;

/// 获取静态组件注册表
NSDictionary<NSString *, id<CBusComponent>>* CBusGetComponentMap(void) {
    __block NSDictionary<NSString *, id<CBusComponent>> *result;
    dispatch_sync(CBusComponentSyncQueue, ^{
        result = [CBusComponentMap copy];
    });
    return result;
}

/// 获取动态组件注册表
NSDictionary<NSString *, id<CBusComponent>>* CBusGetDynamicComponentMap(void) {
    __block NSDictionary<NSString *, id<CBusComponent>> *result;
    dispatch_sync(CBusComponentSyncQueue, ^{
        result = [CBusDynamicComponentMap copy];
    });
    return result;
}

/**
 * 根据类型获取当前组件名称
 * @param cmpClass 组件类型
 * @return 组件名称
 */
NSString *CBusNameForComponentClass(Class cmpClass) {
    if (![cmpClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSLog(@"%@ does not conform to the CBusComponent protocol", NSStringFromClass(cmpClass));
        @throw nil;
    }
    
    NSString *cmpName = [cmpClass componentName];
    if (!cmpName || cmpName.length == 0) {
        cmpName = NSStringFromClass(cmpClass);
    }
    return cmpName;
}

/**
 * 注册组件类型，如果是非动态组件，将直接新建空实例
 */
void CBusResigterComponent(Class);
void CBusResigterComponent(Class cmpClass) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CBusComponentClasses = [NSMutableArray array];
        CBusComponentMap = [NSMutableDictionary dictionary];
        CBusDynamicComponentMap = [NSMutableDictionary dictionary];
        CBusComponentSyncQueue = dispatch_queue_create("com.xiaopeng.cbus_component_class_sync_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    if (![cmpClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSLog(@"%@ does not conform to the CBusComponent protocol", NSStringFromClass(cmpClass));
        return;
    }
    
    dispatch_barrier_async(CBusComponentSyncQueue, ^{
        if (![CBusComponentClasses containsObject:cmpClass]) {
            [CBusComponentClasses addObject:cmpClass];
        }
        
        // 非动态组件
        BOOL isDynamic = [cmpClass respondsToSelector:@selector(isDynamic)] && [cmpClass isDynamic];
        if (!isDynamic) {
            NSString *cmpName = CBusNameForComponentClass(cmpClass);
            [CBusComponentMap setObject:(id<CBusComponent>)[cmpClass new] forKey:cmpName];
        }
    });
}


@implementation CBusComponentRegister

+ (void)registerDynamicComponentForClass:(Class)componentClass {
    if (![componentClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSLog(@"dynamic component %@ not conforms to protocol(CBusComponent)!", NSStringFromClass(componentClass));
        return;
    }
    if (![componentClass respondsToSelector:@selector(isDynamic)] || ![componentClass isDynamic]) {
        NSLog(@"component %@ is not a dynamic component!", NSStringFromClass(componentClass));
        return;
    }
    
    NSString *componentName = CBusNameForComponentClass(componentClass);
    id<CBusComponent> oldCmp = (id<CBusComponent>)[CBusGetDynamicComponentMap() objectForKey:componentName];
    id<CBusComponent> newCmp = (id<CBusComponent>)[componentClass new];
    
    if (oldCmp) {
        NSLog(@"dynamic component %@ will be replaced with %@", [oldCmp componentName], componentName);
    } else {
        NSLog(@"create dynamic component %@", componentName);
    }
    
    dispatch_barrier_async(CBusComponentSyncQueue, ^{
        if (![CBusComponentClasses containsObject:componentClass]) {
            [CBusComponentClasses addObject:componentClass];
        }
        [CBusDynamicComponentMap setObject:newCmp forKey:componentName];
    });
}

+ (void)unregisterDynamicComponentForClass:(Class)componentClass {
    if (![componentClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSLog(@"dynamic component %@ does not conform to the CBusComponent protocol!", NSStringFromClass(componentClass));
    }
    NSString *name = CBusNameForComponentClass(componentClass);
    [self unregisterDynamicComponentForName:name];
}

+ (void)unregisterDynamicComponentForName:(NSString *)componentName {
    if (!componentName || componentName.length == 0) {
        NSLog(@"couldn't unregister dynamic component which is nil!");
        return;
    }
    
    Class targetClass = [CBusGetDynamicComponentMap() objectForKey:componentName];
    dispatch_barrier_async(CBusComponentSyncQueue, ^{
        [CBusComponentClasses removeObject:targetClass];
        [CBusDynamicComponentMap removeObjectForKey:componentName];
    });
}

@end
