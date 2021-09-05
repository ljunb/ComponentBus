//
//  UserModule.m
//  UserModule
//
//  Created by ljunb on 2021/9/5.
//

#import "UserModule.h"

@implementation UserModule

CBUS_REGISTER_MODULE(user);

- (BOOL)openPage:(NSString *)pageName params:(NSDictionary *)params context:(__kindof UIViewController *)context completion:(CBusCompletion)completion {
    return NO;
}

@end
