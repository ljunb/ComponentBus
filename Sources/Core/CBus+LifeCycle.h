//
//  CBus+LifeCycle.h
//  CBus
//
//  Created by ljunb on 2021/9/11.
//

#import <CBus/CBus.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBus (LifeCycle)

/**
 * 通知App生命周期到所有组件
 * @param aSelector 生命周期方法
 * @param arguments 相应参数
 *
 * 参考自Bifrost https://github.com/youzan/Bifrost/blob/a1af5b0ecb5909d289a8e4641ccf3c8b23b175fe/Bifrost/Lib/Bifrost.m#L206
 * @return 处理结果
 */
+ (BOOL)callAppDelegateActionForSelector:(SEL)aSelector arguments:(NSArray *)arguments;

@end

NS_ASSUME_NONNULL_END
