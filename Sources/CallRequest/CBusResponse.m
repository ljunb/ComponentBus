//
//  CBusResponse.m
//  CBus
//
//  Created by ljunb on 2021/9/7.
//

#import "CBusResponse.h"

@implementation CBusResponse

@synthesize code = _code;
@synthesize result = _result;
@synthesize success = _success;

+ (instancetype)success:(NSDictionary *)response {
    return [[self alloc] initWithResult:response success:YES code:1];
}

+ (instancetype)failedCode:(CBusCode)code {
    NSDictionary *extInfo = @{@"CBusCodeDesc": CBusDescriptionForCode(code)};
    return [self failed:extInfo code:code];
}

+ (instancetype)failed:(NSDictionary *)response {
    return [self failed:response code:CBusCodeUnknown];
}

+ (instancetype)failed:(NSDictionary *)response code:(CBusCode)code {
    return [[self alloc] initWithResult:response success:NO code:code];
}

- (instancetype)initWithResult:(NSDictionary *)result success:(BOOL)success code:(CBusCode)code {
    if (self = [super init]) {
        _result = [result copy];
        _success = success;
        _code = code;
    }
    return self;
}

@end
