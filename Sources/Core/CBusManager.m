//
//  CBusManager.m
//  
//
//  Created by ljunb on 2021/9/3.
//

#import "CBusManager.h"
#import "CBusComponent.h"


static NSMutableDictionary<NSString *, id<CBusComponent>> *CBusComponentMap;
static dispatch_queue_t CBusComponentClassesSyncQueue;

NSDictionary<NSString *, id<CBusComponent>>* CBusGetComponentMap(void) {
    __block NSDictionary<NSString *, id<CBusComponent>> *result;
    dispatch_sync(CBusComponentClassesSyncQueue, ^{
        result = [CBusComponentMap copy];
    });
    return result;
}

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

void CBusResigterComponent(Class);
void CBusResigterComponent(Class cmpClass) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CBusComponentMap = [NSMutableDictionary dictionary];
        CBusComponentClassesSyncQueue = dispatch_queue_create("cbus.CBusComponentClassesSyncQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    if (![cmpClass conformsToProtocol:@protocol(CBusComponent)]) {
        NSLog(@"%@ does not conform to the CBusComponent protocol", NSStringFromClass(cmpClass));
        return;
    }
    
    dispatch_barrier_async(CBusComponentClassesSyncQueue, ^{
        NSString *cmpName = CBusNameForComponentClass(cmpClass);
        // 已经注册过了
        if ([CBusComponentMap.allKeys containsObject:cmpName]) {
            return;
        }
        [CBusComponentMap setObject:(id<CBusComponent>)[cmpClass new] forKey:cmpName];
    });
}


@implementation CBusManager

+ (instancetype)sharedManager {
    static CBusManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CBusManager alloc] init];
    });
    return manager;
}

- (void)setup {
    // todo...
}

@end
