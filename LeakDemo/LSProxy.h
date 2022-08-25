//
//  LSProxy.h
//  LeakDemo
//
//  Created by Marshal on 2021/6/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSProxy : NSProxy

+ (instancetype)propxyWithPerformObject:(id)object;

@end

@interface LSProxyTimerWrapper : NSObject

- (instancetype)initTimerWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeat:(BOOL)repeat;

@end

NS_ASSUME_NONNULL_END
