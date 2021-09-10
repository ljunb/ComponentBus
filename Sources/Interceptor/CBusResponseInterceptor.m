//
//  CBusResponseInterceptor.m
//  CBus
//
//  Created by linjunbing on 2021/9/9.
//

#import "CBusResponseInterceptor.h"
#import "CBus.h"

@implementation CBusResponseInterceptor

+ (instancetype)sharedInterceptor {
    static CBusResponseInterceptor *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CBusResponseInterceptor alloc] init];
    });
    return _instance;
}

- (CBusResponse *)intercept:(id<CBusChain>)chain {
    CBus *cbus = [chain cbus];
    // is already finished
    if (cbus.isFinished) {
        return cbus.response;
    }
    
    NSLog(@"CBusResponseInterceptor wait response begin");
    [cbus waitResponse];
    NSLog(@"CBusResponseInterceptor wait response end with response: %@", cbus.response);
    
    return cbus.response;
}

@end
