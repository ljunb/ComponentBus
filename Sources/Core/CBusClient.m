//
//  CBusClient.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusClient.h"
#import "CBusRealCall.h"
#import "CBusDispatcher.h"

@implementation CBusClient {
    NSMutableArray *_innerInterceptors;
}

- (instancetype)init {
    if (self = [super init]) {
        _dispatcher = [[CBusDispatcher alloc] init];
        _innerInterceptors = [NSMutableArray array];
    }
    return self;
}

- (CBusRealCall *)newCall:(CBus *)cbus {
    return [CBusRealCall realCallWithClient:self cbus:cbus];
}

- (NSArray<id<CBusInterceptor>> *)interceptors {
    return [_innerInterceptors copy];
}

- (void)addInterceptor:(id<CBusInterceptor>)interceptor {
    if (!interceptor) {
        return;
    }
    [_innerInterceptors addObject:interceptor];
}

@end
