## CBus

## 快速开始
### 调用
当需要与其他组件进行交互时，需要发起一个 `CBusRequest`。如同步调用一个方法：
```objc
#import <CBus/CBus.h>

- (void)routerAction {
    CBus *cbus = [CBus callRequestWithComponent:@"home" action:@"testAction" params:@{@"name": @"cbus"}];
    if (cbus.response.success) {
        NSLog(@"CBus response: %@", cbus.response);
    }
}
```
以上代码将访问 `home` 组件下的 `testAction` 方法，该方法的返回结果保存在了 `cbus.response` 中。

### 注册组件
为了响应上面的交互请求，需要把组件暴露出来。 新建一个业务组件 `HomeModule`，并实现 `CBusComponent` 协议：
```objc
// HomeModule.h

#import <CBus/CBusComponent.h>

@interface HomeModule : NSObject<CBusComponent>
@end

// HomeModule.m
@implementation HomeModule

CBUS_REGISTER_COMPONENT(home);

@end
```
### 
通过 `CBUS_REGISTER_COMPONENT(#name)` 宏进行组件的注册，如果 `name` 为空，那么默认为业务组件的类名称，这里直接设置为 `home`。

### 标记方法
组件注册后，按需暴露给其他组件访问的方法，可通过 `CBUS_ACTION` 宏来标记一个同步方法：
```objc
// HomeModule.m
@implementation HomeModule

CBUS_ACTION(testAction) {
    CBusResponse *res = [CBusResponse success:@{@"status": @"success", @"message": @"this is a message from test action"}];
    [cbus finished:res];
}

@end
```

`CBUS_ACTION(testAction)` 宏最终转换为以下方法定义：
```objc
- (void)__cbus_action__testAction:(CBus *)cbus {
    ...
}
```
所以在标记的方法体内，可以访问到一个CBus实例 `cbus`，该 `cbus` 就是其他组件发起交互请求时生成的实例。必须要注意的一点时，在每次返回结果时，
都需要手动进行设置 CBusResponse 对象：`[cbus finished:res]`，代表响应成功。


## to be continue

