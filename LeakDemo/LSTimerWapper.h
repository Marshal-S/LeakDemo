//
//  LSTimer.h
//  LeakDemo
//
//  Created by Marshal on 2021/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSTimerWapper : NSObject

- (instancetype)initTimerWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector  repeat:(BOOL)repeat;

- (void)removeTimer;

@end

NS_ASSUME_NONNULL_END
