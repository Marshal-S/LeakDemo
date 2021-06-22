//
//  LSTarget.m
//  LeakDemo
//
//  Created by Marshal on 2021/6/22.
//

#import "LSTarget.h"

@interface LSTarget ()
{
    void(^_block)(void);
}

@end

@implementation LSTarget

- (instancetype)initWithBlock:(void(^)(void))block {
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (void)loopMethod {
    if (_block) _block();
}

@end
