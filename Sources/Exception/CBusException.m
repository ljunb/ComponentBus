//
//  CBusException.m
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import "CBusException.h"


/// CBusCode描述
NSString *CBusDescriptionForCode(CBusCode code) {
    if (code == CBusCodeSuccess) { return @"请求成功"; }
    if (code == CBusCodeUnknown) { return @"未知错误"; }
    if (code == CBusCodeTimeout) { return @"请求超时"; }
    if (code == CBusCodeRequestNull) { return @"请求实体不能为空"; }
    if (code == CBusCodeAleadyExecuted) { return @"不能重复触发当前请求"; }
    if (code == CBusCodeComponentNotFound) { return @"未能找到对应组件"; }
    if (code == CBusCodeComponentNameEmpty) { return @"组件名称不能为空"; }
    if (code == CBusCodeNotConformsToProtocol) { return @"当前组件没有实现CBusComponent协议"; }
    if (code == CBusCodeNotRecognizeSelector) { return @"当前组件没有实现对应方法"; }
    return @"未知错误";
}

@implementation CBusException

+ (void)boom:(CBusCode)code {
    [self boom:code exception:nil extraInfo:nil];
}

+ (void)boom:(CBusCode)code exception:(NSException *)exception {
    [self boom:code exception:exception extraInfo:nil];
}

+ (void)boom:(CBusCode)code extraInfo:(NSDictionary *)extraInfo {
    [self boom:code exception:nil extraInfo:extraInfo];
}

+ (void)boom:(CBusCode)code exception:(nullable NSException *)exception extraInfo:(nullable NSDictionary *)extraInfo {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:extraInfo ?: @{}];
    [userInfo setObject:@(code) forKey:@"CBusCode"];
    [userInfo setObject:CBusDescriptionForCode(code) forKey:@"CBusCodeDesc"];
    
    NSString *reason = [exception reason] ?: [NSString stringWithFormat:@"CBusException(%lu): %@", (unsigned long)code, CBusDescriptionForCode(code)];
    [userInfo addEntriesFromDictionary:[exception userInfo] ?: @{}];
    
    NSException *result = [NSException exceptionWithName:@"CBusException" reason:reason userInfo:userInfo];
    @throw result;
}

@end
