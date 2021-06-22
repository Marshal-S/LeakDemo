//
//  LSTimer.m
//  LeakDemo
//
//  Created by Marshal on 2021/6/21.
//

#import "LSTimerWapper.h"

@interface LSTimerWapper ()
{
    BOOL _canRespondsSelector;
}

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LSTimerWapper

- (instancetype)initTimerWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector  repeat:(BOOL)repeat {
    self.target = target;
    self.selector = selector;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(loopMethod) userInfo:nil repeats:YES];
    _canRespondsSelector = [target respondsToSelector:selector];
    return self;
}

- (void)loopMethod {
    if (_canRespondsSelector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector];
#pragma clang diagnostic pop
    }
}

- (void)removeTimer {
    [self.timer isValid];
    self.timer = nil;
}

@end
