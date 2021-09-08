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

CBUS_REGISTER_COMPONENT(home)

CBUS_ACTION(testAction) {
    CBusResponse *res = [CBusResponse success:@{@"status": @"success", @"message": @"this is a message from test action"}];
    [cbus finished:res];
}

CBUS_ACTION(asyncAction) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        
        CBusResponse *res = [CBusResponse success:@{@"status": @"success"}];
        [cbus finished:res];
    });
}

@end
