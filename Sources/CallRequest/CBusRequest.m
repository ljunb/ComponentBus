//
//  CBusRequest.m
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import "CBusRequest.h"

@implementation CBusRequest {
    NSMutableArray *_innerInterceptors;
}

@synthesize component = _component;
@synthesize action = _action;
@synthesize params = _params;
@synthesize timeout = _timeout;
@synthesize isDeliverOnMainThread = _isDeliverOnMainThread;

+ (instancetype)requestWithComponent:(NSString *)component action:(NSString *)action params:(NSDictionary *)params {
    return [self requestWithComponent:component action:action params:params timeout:0];
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
        _innerInterceptors = [NSMutableArray array];
        _component = component;
        _action = action;
        _params = params;
        _timeout = timeout;
    }
    return self;
}

- (void)deliverOnMainThread {
    _isDeliverOnMainThread = YES;
}

- (void)addInterceptor:(id<CBusInterceptor>)interceptor {
    if (!interceptor) {
        return;
    }
    [_innerInterceptors addObject:interceptor];
}

- (void)addInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors {
    if (!interceptors) {
        return;
    }
    [_innerInterceptors addObjectsFromArray:interceptors];
}

- (NSArray<id<CBusInterceptor>> *)interceptors {
    return [_innerInterceptors copy];
}

- (void)setTimeout:(NSTimeInterval)timeout {
    _timeout = timeout;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"CBusRequest: component=%@, action=%@, params: %@", _component, _action, _params];
}

@end
