//
//  LSTarget.h
//  LeakDemo
//
//  Created by Marshal on 2021/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSTarget : NSObject

- (instancetype)initWithBlock:(void(^)(void))block;

- (void)loopMethod;

@end

NS_ASSUME_NONNULL_END
