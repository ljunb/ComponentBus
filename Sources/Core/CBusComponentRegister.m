//
//  CBusComponentRegister.m
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import "CBusComponentRegister.h"
#import "CBusComponent.h"
#import "CBusException.h"


/// 所有组件的类型注册表，格式：{ componentName: componentClass }
static NSMutableDictionary<NSString *, Class> *CBusComponentClassMap;
/// 所有静/动态态组件的注册表，格式：{ componentName: id<CBusComponent>instance }
static NSMutableDictionary<NSString *, id<CBusComponent>> *CBusComponentMap;
static NSMutableDictionary<NSString *, id<CBusComponent>> *CBusDynamicComponentMap;
/// 组件注册队列
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
        NSDictionary *extInfo = @{@"componentClass": NSStringFromClass(cmpClass)};
        [CBusException boom:CBusCodeNotConformsToProtocol extraInfo:extInfo];
    }
    
    NSString *cmpName = [cmpClass componentName];
    if (!cmpName || cmpName.length == 0) {
        cmpName = NSStringFromClass(cmpClass);
    }
    return cmpName;
}

/**
 * 根据组件名称，获取对应的组件实例
 * @param cmpName 组件类型
 * @return 组件实例，静态组件or动态组件。如果组件为nil，则直接抛出异常
 */
id<CBusComponent> CBusGetComponentInstanceForName(NSString *cmpName) {
    __block id<CBusComponent> instance;
    dispatch_sync(CBusComponentSyncQueue, ^{
        Class cmpClass = CBusComponentClassMap[cmpName];
        BOOL isDynamic = [cmpClass respondsToSelector:@selector(isDynamic)] && [cmpClass isDynamic];
        instance = isDynamic ? CBusDynamicComponentMap[cmpName] : CBusComponentMap[cmpName];
    });
    return instance;
}

/**
 * 注册组件类型，如果是非动态组件，将直接新建空实例
 */
void CBusResigterComponent(Class);
void CBusResigterComponent(Class cmpClass) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CBusComponentClassMap = [NSMutableDictionary dictionary];
        CBusComponentMap = [NSMutableDictionary dictionary];
        CBusDynamicComponentMap = [NSMutableDictionary dictionary];
        CBusComponentSyncQueue = dispatch_queue_create("com.xiaopeng.cbus_component_class_sync_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    if (![cmpClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSDictionary *extInfo = @{@"componentClass": NSStringFromClass(cmpClass)};
        [CBusException boom:CBusCodeNotConformsToProtocol extraInfo:extInfo];
    }
    
    dispatch_barrier_async(CBusComponentSyncQueue, ^{
        NSString *cmpName = CBusNameForComponentClass(cmpClass);
        CBusComponentClassMap[cmpName] = cmpClass;
        
        // 非动态组件
        BOOL isDynamic = [cmpClass respondsToSelector:@selector(isDynamic)] && [cmpClass isDynamic];
        if (!isDynamic) {
            [CBusComponentMap setObject:(id<CBusComponent>)[cmpClass new] forKey:cmpName];
        }
    });
}


@implementation CBusComponentRegister

+ (void)registerDynamicComponentForClass:(Class)componentClass {
    if (![componentClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSDictionary *extInfo = @{@"componentClass": NSStringFromClass(componentClass)};
        [CBusException boom:CBusCodeNotConformsToProtocol extraInfo:extInfo];
    }
    
    if (![componentClass respondsToSelector:@selector(isDynamic)] || ![componentClass isDynamic]) {
        NSLog(@"component %@ is not a dynamic component!", NSStringFromClass(componentClass));
        return;
    }
    
    NSString *componentName = CBusNameForComponentClass(componentClass);
    id<CBusComponent> oldCmp = (id<CBusComponent>)CBusGetDynamicComponentMap()[componentName];
    id<CBusComponent> newCmp = (id<CBusComponent>)[componentClass new];
    
    if (oldCmp) {
        NSLog(@"dynamic component %@ will be replaced with %@", [oldCmp componentName], componentName);
    } else {
        NSLog(@"create dynamic component %@", componentName);
    }
    
    dispatch_barrier_async(CBusComponentSyncQueue, ^{
        CBusComponentClassMap[componentName] = componentClass;
        CBusDynamicComponentMap[componentName] = newCmp;
    });
}

+ (void)unregisterDynamicComponentForClass:(Class)componentClass {
    if (![componentClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSDictionary *extInfo = @{@"componentClass": NSStringFromClass(componentClass)};
        [CBusException boom:CBusCodeNotConformsToProtocol extraInfo:extInfo];
    }
    NSString *name = CBusNameForComponentClass(componentClass);
    [self unregisterDynamicComponentForName:name];
}

+ (void)unregisterDynamicComponentForName:(NSString *)componentName {
    if (!componentName || componentName.length == 0) {
        [CBusException boom:CBusCodeComponentNameEmpty];
    }
    
    dispatch_barrier_async(CBusComponentSyncQueue, ^{
        [CBusComponentClassMap removeObjectForKey:componentName];
        [CBusDynamicComponentMap removeObjectForKey:componentName];
    });
}

@end
