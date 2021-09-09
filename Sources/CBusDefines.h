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

// CBus lock
#define CBus_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define CBus_UNLOCK(lock) dispatch_semaphore_signal(lock);


@class CBus;
/// async call completion
typedef void(^CBusAsyncCallCompletion)(CBus * _Nonnull cbus);

/// execption code
typedef NS_ENUM(NSUInteger, CBusExecptionCode) {
    CBusExecptionCodeRequestNull = 10001,
    CBusExecptionCodeTimeout = 10002,
};




#endif /* CBusDefines_h */
