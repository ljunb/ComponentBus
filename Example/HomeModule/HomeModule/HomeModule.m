//
//  HomeModule.m
//  HomeModule
//
//  Created by ljunb on 2021/9/4.
//

#import "HomeModule.h"

@implementation HomeModule

CBUS_REGISTER_MODULE("home");

- (BOOL)openPage:(NSString *)pageName params:(NSDictionary *)params context:(id)context completion:(CBusCompletion)completion {
    return NO;
}

@end
