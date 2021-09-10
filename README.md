## CBus
CBus 是一种组件化通信的方案，其具备以下特性：
* 消除组件之间的依赖关系，以组件总线方式进行通信
* 支持同步和异步两种调用方式
* 支持自定义拦截器，实现AOP编程
* 更多其他特性

## 快速开始
### 封装CBus组件
快速封装一个业务组件：
```objc
#import "HomeModule.h"
#import <CBus/CBusComponent.h>
#import <CBus/CBus.h>

// 1、实现CBusComponent协议
@interface HomeModule ()<CBusComponent>
@end

@implementation HomeModule

// 2、注册组件，设置组件名称为：home
CBUS_COMPONENT(home)

// 3、标记一个方法
CBUS_ACTION(testAction) {
    CBusResponse *res = [CBusResponse success:@{@"status": @"success", @"message": @"this is a message from test action"}];
    // 4、必须触发的方法，代表方法调用结束
    [cbus finished:res];
}
```
### 组件调用
同步调用：
```objc
#import <CBus/CBus.h>

- (void)syncAction {
    CBus *cbus = [CBus callRequestWithComponent:@"home" action:@"testAction" params:@{@"name": @"cbus"}];
    if (cbus.response.success) {
        NSLog(@"CBus response: %@", cbus.response);
    }
}
```

异步调用：
```objc
#import <CBus/CBus.h>

- (void)asyncAction {
    [CBus asyncCallRequestWithComponent:@"home" action:@"asyncAction" params:nil complete:^(CBus * _Nonnull cbus) {
        if (cbus.response.success) {
            NSLog(@"CBus response: %@", cbus.response);
        }
    }];
}
```

## 核心功能
### 组件注册表
CBus 维护着一个注册表，该注册表以 `componentName: componentInstance` 的格式存放着所有组件的对应关系。组件分为静态组件和动态组件，静态组件
将会在 App 启动的时候进行注册和初始化；而动态组件在启动时只注册类型，业务方按需进行组件初始化。

在 CBus 中，可通过 `CBUS_COMPONENT(componentName)` 的方式来快速注册静态组件。如果 `componentName` 不为空，那么将会使用该值作为注册表中的 `key`，否则直接用
组件类型的字符串代替。注意该 `key` 是组件的名称，也是组件之间通信的唯一标识。区别于静态组件，可用 `CBUS_DYNAMIC_COMPONENT(componentName)` 来注册一个
动态组件，除了不会在启动时进行初始化，其他并无二异。

### 组件方法转发
借助于维护的注册表，CBus 可通过名称来匹配到对应的组件实例，为了能正确响应组件目标方法，框架提供了 `CBUS_ACTION(actionName)` 宏定义，来标记
可用于组件通信的方法。该宏最终转换为以下方法定义：
```objc
- (void)__cbus_action__testAction:(CBus *)cbus {
    ...
}
```
所以在标记的方法体内，可以访问到一个CBus实例 `cbus`，该 `cbus` 就是其他组件发起交互请求时生成的实例。必须要注意的一点时，在每次返回结果时，
都需要手动进行设置 CBusResponse 对象：`[cbus finished:res]`，代表响应成功。

### 组件方法调度
CBus 支持以同步或是异步方式，去调用某个组件的方法：
* 组件A同步调用B方法，不管该方法是同步亦或是异步，最终返回的 CBus 对象都位于组件A发起调用的线程内
* 组件A异步调用B方法，则可以选择是否把响应回调切回主线程

### 拦截器
CBus 内部实现了拦截器，业务方也可以自定义拦截器，利用其AOP特性做一些处理。如要自定义拦截器，需要实现 CBusInterceptor 协议方法 `-intercept:`。注意在进行自定义处理后，
必须要在该方法内调用 `[chain proceed]`：
```objc

@interface MyInterceptor()<CBusInterceptor>
@end

@implementation MyInterceptor

- (CBusResponse *)intercept:(id<CBusChain>)chain {
    CBus *cbus = [chain cbus];
    NSString *componentName = cbus.request.component;
    
    // do something...
    
    // 必须返回响应结果，交由下个拦截器去处理
    return [chain proceed];
}

@end
```

## TODO
- [ ] 生命周期管理
- [ ] 超时处理
- [ ] 跨App通信

