//
//  CBusRequest.m
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import "CBusRequest.h"

@implementation CBusRequest

@synthesize component = _component;
@synthesize action = _action;
@synthesize params = _params;
@synthesize timeout = _timeout;

+ (instancetype)requestWithComponent:(NSString *)component action:(NSString *)action params:(NSDictionary *)params {
    return [self requestWithComponent:component action:action params:params timeout:2];
}

+ (instancetype)requestWithComponent:(NSString *)component action:(NSString *)action params:(NSDictionary *)params timeout:(NSTimeInterval)timeout {
    return [[self alloc] initWithComponent:component action:action params:params timeout:timeout];
}

- (instancetype)initWithComponent:(NSString *)component
                           action:(NSString *)action
                           params:(NSDictionary *)params
                          timeout:(NSTimeInterval)timeout {
    NSAssert(component && component.length > 0, @"component is nil!");
    NSAssert(action && action.length > 0, @"action is nil!");
    
    if (self = [super init]) {
        _component = component;
        _action = action;
        _params = params;
        _timeout = timeout;
    }
    return self;
}

@end
