//
//  CBusManager.m
//  
//
//  Created by ljunb on 2021/9/3.
//

#import "CBusManager.h"
#import "CBusModule.h"


static NSMutableDictionary<NSString *, Class> *CBusModuleMap;
static dispatch_queue_t CBusModuleClassesSyncQueue;

NSDictionary<NSString *, Class>* CBusGetModuleMap(void) {
    __block NSDictionary<NSString *, Class> *result;
    dispatch_sync(CBusModuleClassesSyncQueue, ^{
        result = [CBusModuleMap copy];
    });
    return result;
}

void CBusResigterModule(Class);
void CBusResigterModule(Class moduleClass) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CBusModuleMap = [NSMutableDictionary dictionary];
        CBusModuleClassesSyncQueue = dispatch_queue_create("cbus.CBusModuleClassesSyncQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    if (![moduleClass conformsToProtocol:@protocol(CBusModule)]) {
        NSLog(@"%@ does not conform to the CBusModule protocol", NSStringFromClass(moduleClass));
        return;
    }
    
    dispatch_barrier_async(CBusModuleClassesSyncQueue, ^{
        NSString *moduleName = [moduleClass moduleName];
        if (!moduleName || moduleName.length == 0) {
            moduleName = NSStringFromClass(moduleClass);
        }
        [CBusModuleMap setObject:moduleClass forKey:moduleName];
    });
}

Class CBusClassForModuleName(NSString *moduleName) {
    __block Class result;
    dispatch_sync(CBusModuleClassesSyncQueue, ^{
        result = [CBusModuleMap objectForKey:moduleName];
    });
    return result;
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
    
}

@end
