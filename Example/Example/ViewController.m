//
//  ViewController.m
//  Example
//
//  Created by ljunb on 2021/9/3.
//

#import "ViewController.h"
#import <CBus/CBus.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testSyncAction];
}

- (void)testSyncAction {
    CBus *cbus = [CBus callRequestWithComponent:@"user" action:@"userInfo" params:@{@"name": @"cbus"}];
    if (cbus.response.success) {
        NSLog(@"CBus response: %@", cbus.response);
    }
}

- (void)testAsyncAction {
    [CBus asyncCallRequestWithComponent:@"home" action:@"asyncAction" params:nil complete:^(CBus * _Nonnull cbus) {
            
    }];
}


@end
