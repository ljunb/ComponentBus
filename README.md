## CBus

## 快速开始
### 注册模块
新建一个业务模块 `HomeModule`，并实现 `CBusModule` 协议：
```objc
// HomeModule.h

#import <CBus/CBusModule.h>

@interface HomeModule : NSObject<CBusModule>
@end


// HomeModule.m
@implementation HomeModule

CBUS_REGISTER_MODULE(home);

@end
```
### 
通过 `CBUS_REGISTER_MODULE(#moduleName)` 宏进行模块的注册，如果 `moduleName` 为空，那么默认为业务模块的类名称。

### 实现协议
通过实现 `- openPage:params:context:completion:` 方法来进行页面的路由转发：
```objc
// HomeModule.m
@implementation HomeModule

- (BOOL)openPage:(NSString *)pageName params:(NSDictionary *)params context:(UIViewController *)context completion:(CBusCompletion)completion {
    
    if ([pageName isEqualToString:@"index"]) {
        UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
        [context presentViewController:homeNav animated:YES completion:nil];
        return YES;
    }
    // 没有匹配，返回NO
    return NO;
}

@end
```

### 路由调用
在必要的地方进行路由转发：
```objc
#import <CBus/CBus.h>

- (void)routerAction {
    [CBus openModule:@"home" page:@"index" params:nil context:self];
}
```

## to be continue

