# 目录
- [简介](#CBus简介)
    - [核心功能](#核心功能)
    - [优势](#优势)
- [快速开始](#快速开始)
    - [封装CBus组件](#封装CBus组件)
    - [调用CBus组件](#调用CBus组件)
- [CBusAPIs](#CBusAPIs)   
    - [CBus](#CBus)
    - [CBus(LifeCycle)](#CBus(LifeCycle))  
    - [CBus(Register)](#CBus(Register))  
    - [CBusComponent](#CBusComponent)
    - [CBusClient](#CBusClient)
    - [CBusRequest](#CBusRequest)
    - [CBusResponse](#CBusResponse)
    - [CBusDispatcher](#CBusDispatcher)
    - [CBusInterceptor](#CBusInterceptor)

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

#### request
`@property (nonatomic, strong, readonly) CBusRequest *request;`

每次发起一个调用请求，都会新建 CBusRequest 对象，同时返回一个新的 CBus 对象。`request` 即是当前调用的请求实例。

#### 发起CBusRequest
CBus 提供了一系列创建 CBusRequest 的快捷方法：
- 同步调用
    - `+ (CBus *)callRequestWithComponent:action:`
    - `+ (CBus *)callRequestWithComponent:action:params:`
    - `+ (CBus *)callRequestWithComponent:action:params:timeout:`
- 异步调用
    - `+ (void)asyncCallRequestWithComponent:action:`
    - `+ (void)asyncCallRequestWithComponent:action:params:`
    - `+ (void)asyncCallRequestWithComponent:action:params:complete:`
    - `+ (void)asyncCallRequestWithComponent:action:params:timeout:complete:`
    - `+ (void)asyncCallRequestWithComponent:action:params:completeOnMainThread:`
    - `+ (void)asyncCallRequestWithComponent:action:params:timeout:completeOnMainThread:`

这些方法，实际内部都会生成一个 CBusRequest 对象，其实质是调用了 CBus 的另外两个方法：
- `+ (CBus *)execute:(CBusRequest *)request;`
- `+ (void)enqueue:(CBusRequest *)request complete:(CBusAsyncCallCompletion)complete;`

#### response
`@property (nonatomic, strong, readonly) CBusResponse *response;`

当前调用的响应结果。

#### - finished:
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

### CBus(LifeCycle)
组件与App生命周期方法绑定处理。
#### + callAppDelegateActionForSelector:arguments:
`+ (BOOL)callAppDelegateActionForSelector:(SEL)aSelector arguments:(NSArray *)arguments;`

参考自 [Bifrost生命周期处理](https://github.com/youzan/Bifrost/blob/a1af5b0ecb5909d289a8e4641ccf3c8b23b175fe/Bifrost/Lib/Bifrost.m#L206) 。

### CBus(Register)
动态组件注册相关。
#### + registerDynamicComponentForClass:
`+ (void)registerDynamicComponentForClass:(Class)componentClass;`

根据类型注册一个动态组件。

#### + registerDynamicComponentForName:cls:
`+ (void)registerDynamicComponentForName:(NSString *)componentName cls:(Class)componentClass;`

给定名称和类型注册一个动态组件。

#### + unregisterDynamicComponentForClass:
`+ (void)unregisterDynamicComponentForClass:(Class)componentClass;`

根据类型取消注册一个动态组件。

#### + unregisterDynamicComponentForName:
`+ (void)unregisterDynamicComponentForName:(NSString *)componentName;`

根据名称取消注册一个动态组件。


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

### CBusClient
CBus 内核中持有一个默认的 CBusClient 对象，该对象是方法调用的实际管理者，其主要包含以下功能：
* 初始化调用请求
* 持有方法线程调度管理者
* 设置全局的拦截器

#### dispatcher
`@property (nonatomic, strong, readonly) CBusDispatcher *dispatcher;`

方法线程调度管理者，具体见 [CBusDispatcher](#CBusDispatcher) 。

#### interceptors
`@property (nonatomic, copy, readonly) NSArray<id<CBusInterceptor>> *interceptors;`

自定义拦截器列表，全局生效。

#### - newCall:
`- (CBusRealCall *)newCall:(CBus *)cbus;`

初始化一个调用请求。

#### - addInterceptor:
`- (void)addInterceptor:(id<CBusInterceptor>)interceptor;`

添加一个拦截器。

#### - addInterceptors:
`- (void)addInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors;`

批量添加拦截器。

### CBusRequest
每次 CBus 的方法调用，都需要生成一个 CBusRequest 实例，该实例中包含了当前请求所有的信息。
#### component
`@property (nonatomic, copy, readonly) NSString *component;`

目标组件名称。

#### action
`@property (nonatomic, copy, readonly) NSString *action;`

目标组件方法名称。

#### params
`@property (nonatomic, strong, readonly) NSDictionary *params;`

参数实体。

#### timeout
`@property (nonatomic, assign, readonly) NSTimeInterval timeout;`

当前请求的超时时间。

#### isDeliverOnMainThread
`@property (nonatomic, assign, readonly) BOOL isDeliverOnMainThread;`

是否在主线程结束回调。

#### interceptors
`@property (nonatomic, copy, readonly) NSArray<id<CBusInterceptor>> *interceptors;`

当前请求的拦截器。

#### 新建请求
可通过以下两个方法，生成对应的请求实体：
* `+ requestWithComponent:action:params:`
* `+ requestWithComponent:action:params:timeout`;

#### deliverOnMainThread
`- (void)deliverOnMainThread;`

结束回调切换回主线程。

#### 添加拦截器
可添加单个或多个拦截器：
* `- (void)addInterceptor:(id<CBusInterceptor>)interceptor;`：添加一个请求拦截器
* `- (void)addInterceptors:(NSArray<id<CBusInterceptor>> *)interceptors;`：批量添加请求拦截器

#### 设置超时时间
可直接通过 `aRequest.timeout = 4` 来手动设置超时时间。

### CBusResponse
CBusResponse 中包含了每个方法调用的响应结果。

#### result
`@property (nonatomic, strong, readonly) NSDictionary *result;`

响应结果。

#### code
`@property (nonatomic, assign, readonly) CBusCode code;`

响应码。

#### success
`@property (nonatomic, assign, readonly, getter=isSuccess) BOOL success;`

是否响应成功。

#### 生成响应结果
根据不同场景，提供了以下方法用于快速生成不同响应结果：
* `+ (instancetype)success:(NSDictionary *)result;`：快速返回一个成功结果，其 `code=1, isSuccess=YES`
* `+ (instancetype)errorCode:(CBusCode)code;`：根据给定的 `code`，快速返回一个失败结果，其 `isSuccess=NO`
* `+ (instancetype)error:(NSDictionary *)result;`：快速返回一个失败结果，其 `isSuccess=NO`
* `+ (instancetype)error:(nullable NSDictionary *)result code:(CBusCode)code;`：快速返回一个自定义的失败结果，其 `isSuccess=NO`


### CBusDispatcher
CBus 所有的异步调用，都将加入到 CBusDispatcher 中维护的操作队列中，其默认的最大操作数是64。

#### - enqueue:
`- (void)enqueue:(CBusAsyncCall *)asyncCall;`

开始执行一个异步调用。

#### - onResult:completion:
`- (void)onResult:(CBus *)cbus completion:(CBusAsyncCallCompletion)completion;`

触发异步方法回调。

#### - cancelAllCalls
`- (void)cancelAllCalls;`

取消所有的异步方法调用。

### CBusInterceptor
TODO
