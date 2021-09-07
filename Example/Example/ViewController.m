//
//  ViewController.m
//  Example
//
//  Created by ljunb on 2021/9/3.
//

#import "ViewController.h"
#import <CBus/CBusManager.h>
#import <CBus/CBus.h>
#import <CBus/CBusRequest.h>
#import <CBus/CBusResponse.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CBusRequest *requst = [CBusRequest requestWithComponent:@"home" action:@"index" params:nil];
    [CBus open:requst context:self complete:nil];
}


@end
