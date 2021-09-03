//
//  ViewController.m
//  Example
//
//  Created by ljunb on 2021/9/3.
//

#import "ViewController.h"
#import <ComponentBus/CBus.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CBus openModule:@"home" page:@"index" params:nil context:self];
}


@end
