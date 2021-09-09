//
//  HomeModule.m
//  HomeModule
//
//  Created by ljunb on 2021/9/4.
//

#import "HomeModule.h"
#import "HomeViewController.h"
#import <CBus/CBus.h>
#import <CBus/CBusResponse.h>

@implementation HomeModule

CBUS_COMPONENT(home)

CBUS_ACTION(testAction) {
    CBus *newCbus = [CBus callRequestWithComponent:@"user" action:@"userInfo" params:nil];
    
    CBusResponse *res;
    if (newCbus.response.success) {
        NSDictionary *baseInfo = @{@"status": @"success", @"message": @"userInfo is return nil!"};
        NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:newCbus.response.result ?: baseInfo];
        res = [CBusResponse success:ext];
        [cbus finished:res];
    } else {
        res = [CBusResponse failed:@{@"status": @"failed"}];
        [cbus finished:res];
    }
}

CBUS_ACTION(asyncAction) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        
        CBusResponse *res = [CBusResponse success:@{@"status": @"success"}];
        [cbus finished:res];
    });
}

@end
