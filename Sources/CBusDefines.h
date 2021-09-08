//
//  CBusDefines.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#ifndef CBusDefines_h
#define CBusDefines_h

#if !defined CBUS_DYNAMIC
#if __has_attribute(objc_dynamic)
#define CBUS_DYNAMIC __attribute__((objc_dynamic))
#else
#define CBUS_DYNAMIC
#endif
#endif

#define CBUS_EXTERN extern __attribute__((visibility("default")))

#define CBus_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define CBus_UNLOCK(lock) dispatch_semaphore_signal(lock);

/**
 结束回调
 
 @param result 回调结果，可能为nil
 @param error 错误信息
 */
typedef void(^CBusCompletion)(id _Nullable result, NSError * _Nullable error);

@class CBus;
@class CBusResponse;

typedef void(^CBusAsyncCallResponse)(CBus * _Nonnull cbus);

#endif /* CBusDefines_h */
