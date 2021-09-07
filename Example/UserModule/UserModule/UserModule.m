//
//  UserModule.m
//  UserModule
//
//  Created by ljunb on 2021/9/5.
//

#import "UserModule.h"

@implementation UserModule

CBUS_REGISTER_COMPONENT(user)

- (BOOL)openPage:(NSString *)pageName
          params:(NSDictionary *)params
         context:(nullable __kindof UIViewController *)context
      completion:(nullable CBusAsyncCallResponse)completion{
    return NO;
}

@end
