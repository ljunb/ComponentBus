//
//  CBus.m
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import "CBus.h"
#import "CBusModule.h"

@implementation CBus

+ (BOOL)openModule:(NSString *)moduleName
              page:(NSString *)pageName
            params:(NSDictionary *)params
           context:(__kindof UIViewController *)context {
    return [self openModule:moduleName page:pageName params:params context:context completion:nil];
}

+ (BOOL)openModule:(NSString *)moduleName
              page:(NSString *)pageName
            params:(NSDictionary *)params
           context:(__kindof UIViewController *)context
        completion:(CBusCompletion)completion {
    
    BOOL result = NO;
    @try {
        if (!moduleName || moduleName.length == 0) {
            NSLog(@"module name is nil!");
            return NO;
        }
        
        Class moduleClass = CBusClassForModuleName(moduleName);
        id<CBusModule> module = [moduleClass new];
        if ([module respondsToSelector:@selector(openPage:params:context:completion:)]) {
            result = [module openPage:pageName params:params context:context completion:completion];
        }
    } @catch (NSException *exception) {
        NSLog(@"openPage:params:context:completion: error: %@", exception.userInfo);
    }
    
    return result;
}

@end
