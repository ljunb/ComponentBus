//
//  ViewController.m
//  Example
//
//  Created by ljunb on 2021/9/3.
//

#import "ViewController.h"
#import <CBus/CBusManager.h>
#import <CBus/CBus.h>
#import <CBus/CBusModule.h>

@interface ViewController ()<CBusModule>

@end

@implementation ViewController

CBUS_REGISTER_MODULE(view);

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CBus openModule:@"home" page:@"index" params:nil context:self];
}

- (BOOL)openPage:(NSString *)pageName params:(NSDictionary *)params context:(__kindof UIViewController *)context completion:(CBusCompletion)completion {
    NSLog(@"%@ %@", pageName, params);
    return NO;
}

@end
