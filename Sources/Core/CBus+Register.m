//
//  CBus+Register.m
//  CBus
//
//  Created by ljunb on 2021/9/11.
//

#import "CBus+Register.h"
#import "CBusComponentRegister.h"

@implementation CBus (Register)

+ (void)registerDynamicComponentForClass:(Class)componentClass {
    [CBusComponentRegister registerDynamicComponentForClass:componentClass];
}

+ (void)unregisterDynamicComponentForClass:(Class)componentClass {
    [CBusComponentRegister unregisterDynamicComponentForClass:componentClass];
}

+ (void)unregisterDynamicComponentForName:(NSString *)componentName {
    [CBusComponentRegister unregisterDynamicComponentForName:componentName];
}

@end
