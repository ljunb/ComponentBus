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

+ (instancetype)success:(NSDictionary *)result {
    return [[self alloc] initWithResult:result success:YES code:CBusCodeSuccess];
}

+ (instancetype)error:(NSDictionary *)result {
    return [self error:result code:CBusCodeUnknown];
}

+ (instancetype)errorCode:(CBusCode)code {
    return [self error:nil code:code];
}

+ (instancetype)error:(NSDictionary *)result code:(CBusCode)code {
    NSMutableDictionary *extInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"CBusCodeDesc": CBusDescriptionForCode(code)}];
    [extInfo addEntriesFromDictionary:result ?: @{}];
    return [[self alloc] initWithResult:extInfo success:NO code:code];
}

- (instancetype)initWithResult:(NSDictionary *)result success:(BOOL)success code:(CBusCode)code {
    if (self = [super init]) {
        _result = [result copy];
        _success = success;
        _code = code;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CBusResponse: success=%d, code=%lu, result: %@", _success, (unsigned long)_code, _result];
}

@end
