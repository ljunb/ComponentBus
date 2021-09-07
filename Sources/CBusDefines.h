//
//  CBusDefines.h
//  ComponentBus
//
//  Created by ljunb on 2021/9/4.
//

#ifndef CBusDefines_h
#define CBusDefines_h

#define CBUS_EXTERN extern __attribute__((visibility("default")))
/**
 结束回调
 
 @param result 回调结果，可能为nil
 @param error 错误信息
 */
typedef void(^CBusCompletion)(id _Nullable result, NSError * _Nullable error);

@class CBus;
@class CBusRequest;
@class CBusResponse;

typedef void(^CBusAsyncCallResponse)(CBusRequest * _Nonnull req, CBus * _Nonnull cbus);

#endif /* CBusDefines_h */
