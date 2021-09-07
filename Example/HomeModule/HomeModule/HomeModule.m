//
//  HomeModule.m
//  HomeModule
//
//  Created by ljunb on 2021/9/4.
//

#import "HomeModule.h"
#import "HomeViewController.h"

@implementation HomeModule

CBUS_REGISTER_COMPONENT(home)

- (BOOL)openPage:(NSString *)pageName params:(NSDictionary *)params context:(UIViewController *)context completion:(nullable CBusAsyncCallResponse)completion{
    
    if ([pageName isEqualToString:@"index"]) {
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
        [context presentViewController:homeNav animated:YES completion:nil];
        
        return YES;
    }
    
    return NO;
}

@end
