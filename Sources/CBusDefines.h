//
//  CBusDefines.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#ifndef CBusDefines_h
#define CBusDefines_h

#if !defined CBUS_OBJC_DYNAMIC
#if __has_attribute(objc_dynamic)
#define CBUS_OBJC_DYNAMIC __attribute__((objc_dynamic))
#else
#define CBUS_OBJC_DYNAMIC
#endif
#endif

#define CBUS_EXTERN extern __attribute__((visibility("default")))

// CBus lock
#define CBus_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#define CBus_UNLOCK(lock) dispatch_semaphore_signal(lock);


@class CBus;
/// async call completion
typedef void(^CBusAsyncCallCompletion)(CBus * _Nonnull cbus);

/// cbus code
typedef NS_ENUM(NSUInteger, CBusCode) {
    CBusCodeUnknown = -1,
    CBusCodeSuccess = 1,
    CBusCodeRequestNull = 10001,
    CBusCodeTimeout = 10002,
    CBusCodeAleadyExecuted = 10003,
    CBusCodeCanceled = 10004,
    CBusCodeComponentNotFound = 20001,
    CBusCodeComponentNameEmpty = 20002,
    CBusCodeNotConformsToProtocol = 30001,
    CBusCodeNotRecognizeSelector = 30002,
};

CBUS_EXTERN NSString * _Nonnull CBusDescriptionForCode(CBusCode code);

#endif /* CBusDefines_h */
