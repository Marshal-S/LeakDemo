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

NS_ASSUME_NONNULL_END
