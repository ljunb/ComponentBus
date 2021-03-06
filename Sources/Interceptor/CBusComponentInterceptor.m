//
//  CBusComponentInterceptor.m
//  CBus
//
//  Created by linjunbing on 2021/9/10.
//

#import "CBusComponentInterceptor.h"
#import "CBus.h"
#import "CBusComponent.h"
#import "CBusComponentRegister.h"

@implementation CBusComponentInterceptor

+ (instancetype)sharedInterceptor {
    static CBusComponentInterceptor *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CBusComponentInterceptor alloc] init];
    });
    return _instance;
}

- (CBusResponse *)intercept:(id<CBusChain>)chain {
    CBus *cbus = [chain cbus];
    NSString *componentName = cbus.request.component;
    if (!componentName || componentName.length == 0) {
        return [CBusResponse errorCode:CBusCodeComponentNameEmpty];
    }
    if (!cbus.request) {
        return [CBusResponse errorCode:CBusCodeRequestNull];
    }
    
    id<CBusComponent> component = [CBusComponentRegister componentInstanceForName:componentName];
    if (!component) {
        return [CBusResponse error:@{@"componentName": componentName} code:CBusCodeComponentNotFound];
    }
    
    NSString *targetActionStr = [NSString stringWithFormat:@"__cbus_action__%@:", cbus.request.action];
    SEL actionSel = NSSelectorFromString(targetActionStr);
    if (![component respondsToSelector:actionSel]) {
        return [CBusResponse error:@{@"action": targetActionStr} code:CBusCodeNotRecognizeSelector];
    }
 
    @try {
        // invoke action
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [component performSelector:actionSel withObject:cbus];
#pragma clang diagnostic pop
    } @catch (NSException *exception) {
        return [CBusResponse error:@{@"exception": exception.userInfo}];
    }
    
    return [chain proceed];
}

@end
