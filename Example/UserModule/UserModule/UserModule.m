//
//  UserModule.m
//  UserModule
//
//  Created by ljunb on 2021/9/5.
//

#import "UserModule.h"
#import <CBus/CBus.h>

@implementation UserModule

CBUS_DYNAMIC_COMPONENT(user)

CBUS_ACTION(userInfo) {
    CBusResponse *response = [CBusResponse success:@{@"userInfo": @{@"name": @"cbus", @"address": @"guangzhou"}}];
    [cbus finished:response];
}

@end
