//
//  CBus+LifeCycle.m
//  CBus
//
//  Created by ljunb on 2021/9/11.
//

#import "CBus+LifeCycle.h"
#import "CBusComponentRegister.h"

@implementation CBus (LifeCycle)

+ (BOOL)callAppDelegateActionForSelector:(SEL)aSelector arguments:(NSArray *)arguments {
    BOOL result = NO;
    for (id<CBusComponent> component in CBusComponentRegister.allComponents) {
        if (![component conformsToProtocol:@protocol(CBusComponent)]) {
            NSLog(@"Warning: component %@ doesn't conforms to protocol CBusComponent", component);
            continue;
        }
        if ([component respondsToSelector:aSelector]) {
            BOOL ret = NO;
            [self invokeTarget:component action:aSelector arguments:arguments returnValue:&ret];
            if (!result) {
                result = ret;
            }
        }
    }
    return result;
}

+ (BOOL)invokeTarget:(id)target
              action:(_Nonnull SEL)selector
           arguments:(NSArray* _Nullable )arguments
         returnValue:(void* _Nullable)result; {
    if (target && [target respondsToSelector:selector]) {
        NSMethodSignature *sig = [target methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:target];
        [invocation setSelector:selector];
        for (NSUInteger i = 0; i<[arguments count]; i++) {
            NSUInteger argIndex = i+2;
            id argument = arguments[i];
            if ([argument isKindOfClass:NSNumber.class]) {
                //convert number object to basic num type if needs
                BOOL shouldContinue = NO;
                NSNumber *num = (NSNumber*)argument;
                const char *type = [sig getArgumentTypeAtIndex:argIndex];
                if (strcmp(type, @encode(BOOL)) == 0) {
                    BOOL rawNum = [num boolValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                } else if (strcmp(type, @encode(int)) == 0
                           || strcmp(type, @encode(short)) == 0
                           || strcmp(type, @encode(long)) == 0) {
                    NSInteger rawNum = [num integerValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                } else if(strcmp(type, @encode(long long)) == 0) {
                    long long rawNum = [num longLongValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                } else if (strcmp(type, @encode(unsigned int)) == 0
                           || strcmp(type, @encode(unsigned short)) == 0
                           || strcmp(type, @encode(unsigned long)) == 0) {
                    NSUInteger rawNum = [num unsignedIntegerValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                } else if(strcmp(type, @encode(unsigned long long)) == 0) {
                    unsigned long long rawNum = [num unsignedLongLongValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                } else if (strcmp(type, @encode(float)) == 0) {
                    float rawNum = [num floatValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                } else if (strcmp(type, @encode(double)) == 0) { // double
                    double rawNum = [num doubleValue];
                    [invocation setArgument:&rawNum atIndex:argIndex];
                    shouldContinue = YES;
                }
                if (shouldContinue) {
                    continue;
                }
            }
            if ([argument isKindOfClass:[NSNull class]]) {
                argument = nil;
            }
            [invocation setArgument:&argument atIndex:argIndex];
        }
        [invocation invoke];
        NSString *methodReturnType = [NSString stringWithUTF8String:sig.methodReturnType];
        if (result && ![methodReturnType isEqualToString:@"v"]) { //if return type is not void
            if([methodReturnType isEqualToString:@"@"]) { //if it's kind of NSObject
                CFTypeRef cfResult = nil;
                [invocation getReturnValue:&cfResult]; //this operation won't retain the result
                if (cfResult) {
                    CFRetain(cfResult); //we need to retain it manually
                    *(void**)result = (__bridge_retained void *)((__bridge_transfer id)cfResult);
                }
            } else {
                [invocation getReturnValue:result];
            }
        }
        return YES;
    }
    return NO;
}

@end
