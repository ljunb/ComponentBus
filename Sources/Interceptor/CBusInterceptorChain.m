//
//  CBusInterceptorChain.m
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import "CBusInterceptorChain.h"
#import "CBusException.h"

@implementation CBusInterceptorChain {
    NSArray<id<CBusInterceptor>> *_interceptors;
    NSInteger _index;
    CBus *_innerCbus;
    CBusResponse *_innerResponse;
    id<CBusCall> _innerCall;
    NSInteger _calls;
}

+ (instancetype)chainWithInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors
                                index:(NSInteger)index
                                 cbus:(CBus *)cbus
                                 call:(id<CBusCall>)call {
    return [[self alloc] initWithInterceptors:interceptors index:index cbus:cbus call:call];
}

- (instancetype)initWithInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors
                               index:(NSInteger)index
                                cbus:(CBus *)cbus
                                call:(id<CBusCall>)call {
    if (self = [super init]) {
        _interceptors = interceptors;
        _index = index;
        _innerCbus = cbus;
        _innerCall = call;
    }
    return self;
}

- (CBus *)cbus {
    return _innerCbus;
}

- (id<CBusCall>)call {
    return _innerCall;
}

- (CBusResponse *)proceed {
    if (_index >= _interceptors.count) {
        [CBusException boom:CBusCodeUnknown];
    }
    
    _calls++;
    if (_calls > 1) {
        [CBusException boom:CBusCodeUnknown];
    }
    
    CBusInterceptorChain *next = [CBusInterceptorChain chainWithInterceptors:_interceptors
                                                                       index:_index+1
                                                                        cbus:_innerCbus
                                                                        call:_innerCall];
    id<CBusInterceptor> interceptor = [_interceptors objectAtIndex:_index];
    CBusResponse *response = [interceptor intercept:next];
    return response;
}


@end
