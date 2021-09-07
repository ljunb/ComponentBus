//
//  CBusManager.h
//  
//
//  Created by ljunb on 2021/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBusManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;

@end

NS_ASSUME_NONNULL_END
