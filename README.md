# 目录
- [简介](#CBus简介)
    - [核心功能](#核心功能)
    - [优势](#优势)
- [快速开始](#快速开始)
    - [封装CBus组件](#封装CBus组件)
    - [调用CBus组件](#调用CBus组件)
- [CBusAPIs](#CBusAPIs)   
    - [CBus](#CBus)
    - [CBusComponent](#CBusComponent)
- [TODO](#TODO)    

## CBus简介
- 一种组件化框架
- 将某个模块对外方法使用CBus包装，那么就形成了一个CBus组件
- CBus对外暴露组件名称以及各种组件方法
- CBus封装了组件之间的底层数据通信逻辑，组件与组件之前没有接口依赖
- 更多其他特性

### 核心功能

- 组件注册表
    - main函数执行之前，所有组件自动注册到一个Map，形成组件注册表
    - 后续组件调用，统一来注册表查找组件
- 组件方法转发    
    - 注册表中通过组件名称找到组件对象
    - 在组件对象中查找对应的组件方法并调用之
    - 框架层相当于模块与模块之间的胶水层，解除了模块接口依赖
- 组件方法调度
    - 允许调用方同步/异步方式调用其他组件方法
    - 框架内部维护了一个NSOperationQueue，用于执行异步调用逻辑
    - 不用关心其他组件方法是同步或者异步实现
- 生命周期管理
    - 在AppDelegate中进行生命周期方法绑定
- 拦截器
    - 允许开发者自定义拦截器，实现AOP编程
    
### 优势
CBus消除了每个组件之间的依赖关系，可彻底解耦业务依赖。

## 快速开始
### 封装CBus组件
快速封装一个业务组件：
```objc
#import "HomeComponent.h"
#import <CBus/CBusComponent.h>
#import <CBus/CBus.h>

// 实现CBusComponent协议
@interface HomeComponent ()<CBusComponent>
@end

@implementation HomeComponent

// 注册组件，设置组件名称为：home
CBUS_COMPONENT(home)

// 标记一个方法
CBUS_ACTION(testAction) {
    CBusResponse *res = [CBusResponse success:@{@"status": @"success", @"message": @"this is a message from test action"}];
    // 返回调用结果
    [cbus finished:res];
}
```
以上示例通过 `CBUS_COMPONENT` 注册了一个 `home` 组件，同时用 `CBUS_ACTION` 标记了一个可供外部调用的组件方法。

### 调用CBus组件
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

## CBusAPIs
### CBus
#### client
`@property (nonatomic, strong, readonly) CBusClient *client;`

CBus内部维护一个默认的 CBusClient 对象，如无设置，则返回该对象。

#### + setCBusClient:
`+ (void)setCBusClient:(CBusClient *)client;`

设置 CBusClient 对象。一般情况下，不需要设置，因为内部有默认的 CBusClient 对象。对于一些非常重要的业务或者组件，可以单独设置 CBusClient 对象，
保证这些组件或者业务在发起组件调用的时候，能够使用单独的操作队列。

#### request;
`@property (nonatomic, strong, readonly) CBusRequest *request;`

每次发起一个调用请求，都会新建 CBusRequest 对象，同时返回一个新的 CBus 对象。`request` 即是当前调用的请求实例。

#### 发起CBusRequest
CBus 提供了一系列创建 CBusRequest 的快捷方法：
- 同步调用
    - `+ (CBus *)callRequestWithComponent:action:params:`
    - `+ (CBus *)callRequestWithComponent:action:`
- 异步调用
    - `+ (void)asyncCallRequestWithComponent:action:params:complete:`
    - `+ (void)asyncCallRequestWithComponent:action:params:`
    - `+ (void)asyncCallRequestWithComponent:action:`
    - `+ (void)asyncCallRequestWithComponent:action:params:completeOnMainThread:`

这些方法，实际内部都会生成一个 CBusRequest 对象，其实质是调用了 CBus 的另外两个方法：
- `+ (CBus *)execute:(CBusRequest *)request;`
- `+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallCompletion)complete;`

#### response
`@property (nonatomic, strong, readonly) CBusResponse *response;`

当前调用的响应结果。

#### - finished:;
`- (void)finished:(CBusResponse *)response;`

设置调用结果。前面看到，每个 `CBUS_ACTION` 标识的组件方法，需要给当前组件调用返回调用结果，那么通过该方法进行设置。
假设组件方法为同步实现，那么在组件方法里面返回结果：
```objc
CBUS_ACTION(syncAction) {
    CBusResponse *res = [CBusResponse success:@{@"status": @"success", @"message": @"this is a message from test action"}];
    // 返回调用结果
    [cbus finished:res];
}
```
假设组件方法为异步实现，那么在异步回调里面返回结果：
```objc
CBUS_ACTION(asyncAction) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:3];
        
        CBusResponse *res = [CBusResponse success:@{@"status": @"success"}];
        // 返回调用结果
        [cbus finished:res];
    });
}
```
> 不论组件实现是同步或者异步，都需要通过 `finised:` 来返回调用结果。

#### @property (readonly) BOOL isFinished;
当前调用是否已经结束。

#### @property (readonly) BOOL isCanceled;
当前调用是否已经取消。

#### - cancel
`- (void)cancel;`
取消当前组件调用。

### CBusComponent
CBusComponent 是组件化协议，每个需要进行组件化的模块都需要实现该协议。
#### CBUS_COMPONENT
`CBUS_COMPONENT(name)`

使用该宏进行静态组件的注册，其定义为：
```objc
#define CBUS_COMPONENT(name) \
CBUS_EXTERN void CBusResigterComponent(Class); \
+ (NSString *)componentName { return @#name; } \
+ (void)load { CBusResigterComponent(self); }
```
因此 App 会在执行 `main` 函数之前，进行组件的注册。对于静态组件，注册的时候会新建一个空实例，并添加至注册表。如果业务方提供了 `name`，那么将作为组件
的名称添加到注册表中，用于后续的组件调用。如果没有提供 `name`，组件类型将作为其注册表的 `key`。

#### CBUS_DYNAMIC_COMPONENT
`CBUS_DYNAMIC_COMPONENT(name)`
使用该宏进行动态态组件的注册。相对于静态组件，动态组件的注册只会注册其类型，不会实例化空对象，后续业务方可在必要时机进行动态组件的注册。该宏定义：
```objc
#define CBUS_DYNAMIC_COMPONENT(name) \
CBUS_COMPONENT(#name) \
+ (BOOL)isDynamic { return YES; } \
```

#### CBUS_ACTION
`CBUS_ACTION(action)`

CBus 为了能够正确识别匹配组件的目标方法，定义了该宏：
```objc
#define CBUS_ACTION(sel_name) \
- (void)__cbus_action__##sel_name:(CBus *)cbus CBUS_OBJC_DYNAMIC
```
可以看到，该宏为每个标记的组件方法，添加了 `__cbus_action__` 的前缀，并传入了一个当前调用的 CBus 对象，业务方可通过访问 `cbus` 实例来
获取调用请求，或是设置返回调用结果。

#### + isDynamic
`+ (BOOL)isDynamic;`

是否动态组件。

#### + componentName
`+ (NSString *)componentName;`

当前组件名称。

## TODO
- [ ] 超时处理
- [ ] 跨App通信

