//
//  CBus.m
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#import "CBus.h"

#import "CBusComponent.h"
#import "CBusResponse.h"
#import "CBusRequest.h"

@implementation CBus

+ (BOOL)open:(CBusRequest *)request context:(nullable UIViewController *)context complete:(nullable CBusAsyncCallResponse)complete {
    NSDictionary<NSString *, id<CBusComponent>> *componentMap = CBusGetComponentMap();
    id<CBusComponent> component = componentMap[request.component];
    if (component && [component respondsToSelector:@selector(openPage:params:context:completion:)]) {
        return [component openPage:request.action params:request.params context:context completion:complete];
    }
    return NO;
}

+ (CBus *)execute:(CBusRequest *)request {
    return [CBus new];
}

+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallResponse)complete {
    
}

@end
