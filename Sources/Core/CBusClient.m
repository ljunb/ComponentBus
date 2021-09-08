//
//  CBusClient.m
//  CBus
//
//  Created by linjunbing on 2021/9/8.
//

#import "CBusClient.h"
#import "CBusRealCall.h"
#import "CBusDispatcher.h"

@implementation CBusClient

- (instancetype)init {
    if (self = [super init]) {
        _dispatcher = [[CBusDispatcher alloc] init];
    }
    return self;
}

- (CBusRealCall *)newCall:(CBus *)cbus {
    return [CBusRealCall realCallWithClient:self cbus:cbus];
}

@end
