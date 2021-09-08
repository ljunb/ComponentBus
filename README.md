## CBus

## 快速开始
### 快速封装业务组件
封装一个业务组件：
```objc
#import "HomeModule.h"
#import <CBus/CBusComponent.h>
#import <CBus/CBus.h>
#import <CBus/CBusResponse.h>

// 1、实现CBusComponent协议
@interface HomeModule ()<CBusComponent>
@end

@implementation HomeModule

// 2、注册组件，设置组件名称为：home
CBUS_REGISTER_COMPONENT(home)

// 3、标记一个方法
CBUS_ACTION(testAction) {
    CBusResponse *res = [CBusResponse success:@{@"status": @"success", @"message": @"this is a message from test action"}];
    // 4、必须触发的方法，代表方法调用结束
    [cbus finished:res];
}
```

`CBUS_ACTION(testAction)` 宏最终转换为以下方法定义：
```objc
- (void)__cbus_action__testAction:(CBus *)cbus {
    ...
}
```
所以在标记的方法体内，可以访问到一个CBus实例 `cbus`，该 `cbus` 就是其他组件发起交互请求时生成的实例。必须要注意的一点时，在每次返回结果时，
都需要手动进行设置 CBusResponse 对象：`[cbus finished:res]`，代表响应成功。

### 调用
同步调用组件方法：
```objc
#import <CBus/CBus.h>

- (void)syncAction {
    CBus *cbus = [CBus callRequestWithComponent:@"home" action:@"testAction" params:@{@"name": @"cbus"}];
    if (cbus.response.success) {
        NSLog(@"CBus response: %@", cbus.response);
    }
}
```
以上代码将访问 `home` 组件下的 `testAction` 方法，该方法的返回结果保存在了 `cbus.response` 中。

## to be continue

