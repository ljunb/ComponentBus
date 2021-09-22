//
//  UserModule.m
//  UserModule
//
//  Created by ljunb on 2021/9/5.
//

#import "UserModule.h"
#import <CBus/CBus.h>

@implementation UserModule

CBUS_COMPONENT(user)

CBUS_ACTION(userInfo) {
    [NSThread sleepForTimeInterval:3];
    CBusResponse *response = [CBusResponse success:@{@"userInfo": @{@"name": @"cbus", @"address": @"guangzhou"}}];
    [cbus finished:response];
}

@end
