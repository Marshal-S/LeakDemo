//
//  LSProxy.m
//  LeakDemo
//
//  Created by Marshal on 2021/6/21.
//

#import "LSProxy.h"

@interface LSProxy ()

@property (nonatomic, weak) id object;

@end

@implementation LSProxy

+ (instancetype)propxyWithPerformObject:(id)object {
    LSProxy *proxy = [LSProxy alloc];
    proxy.object = object;
    return proxy;
}

//NSProxy方法查找，不会去父类查找，本类找不到方法，直接开启消息转发流程，性能相比较之下不错，很专业
//重定向和消息转发随便一个都行

//重定向
- (id)forwardingTargetForSelector:(SEL)aSelector{
//    if (self.object) {
//        return self.object;
//    }else {
//        NSLog(@"object不存在无法重定向,崩溃了");
//        return nil;
//    }
    return self.object; //将方法调用重定向到self.object代理类
}

//实例方法的消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.object methodSignatureForSelector:sel]; //使用self.object的方法签名
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (self.object)
        [invocation invokeWithTarget:self.object]; //对self.object执行该方法
    else
        NSLog(@"object不存在重定向失败，嗝屁了");
}

@end
