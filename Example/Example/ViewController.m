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
    [self testAsyncCompleteOnMainThread];
}

- (void)testSyncAction {
    CBus *cbus = [CBus callRequestWithComponent:@"use1r" action:@"userInfo" params:@{@"name": @"cbus"}];
    if (cbus.response.success) {
        NSLog(@"CBus response: %@", cbus.response);
    }
}

- (void)testAsyncAction {
    NSLog(@"test start: %f", NSTimeIntervalSince1970);
    [CBus asyncCallRequestWithComponent:@"home" action:@"asyncAction" params:nil complete:^(CBus * _Nonnull cbus) {
        NSLog(@"test end %f", NSTimeIntervalSince1970);
        NSLog(@"testAsyncAction: current thread %@, response: %@", NSThread.currentThread, cbus.response);
    }];
}

- (void)testAsyncCompleteOnMainThread {
    [CBus asyncCallRequestWithComponent:@"home1" action:@"asyncAction" params:nil completeOnMainThread:^(CBus * _Nonnull cbus) {
        NSLog(@"testAsyncCompleteOnMainThread: current thread %@, response: %@", NSThread.currentThread, cbus.response);
    }];
}

@end
