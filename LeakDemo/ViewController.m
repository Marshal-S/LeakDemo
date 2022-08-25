//
//  ViewController.m
//  LeakDemo
//
//  Created by Marshal on 2021/6/18.
//

#import "ViewController.h"
#import "LSTarget.h"
#import "LSTimerWapper.h"
#import "LSProxy.h"

@interface ViewController ()

@property UIView *animateView;

@property NSString *name;

@property void(^testBlock)(void);
@property void(^testBlock2)(ViewController *vc);

@property LSTarget *target;
@property LSProxy *proxy;

@property NSTimer *timer;

@property LSTimerWapper *lsTimer;

@property LSProxyTimerWrapper *proxyWrapper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self animateBlock];
//    [self testBlockLeak];
//    [self testBlockLeak2];
//    [self testBlockLeak3];
    
//    [self testTimer1];
//    [self testTimer2];
//    [self testTimer3];
//    [self testTimer4];
//    [self testTime4];
//    [self testTimer5];
    [self testTimer6];
}

- (void)delegateTest {
    //代理对象delegate记得上weak就行了
    //如果是strong，则引用环内存泄露 self -> delegate -> self
}

- (void)animateBlock {
    self.animateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.animateView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animateView];
    
    [UIView animateWithDuration:3 animations:^{
        self.animateView.frame = CGRectMake(0, 300, 40, 40);
    }];
}

//测试block引起的leak
- (void)testBlockLeak {
    self.testBlock = ^ {
        self.name = @"";
    };
    self.testBlock();
}

- (void)testBlockLeak2 {
    self.testBlock2 = ^(ViewController *vc) {
        vc.name = @"";
    };
    self.testBlock2(self);
}

- (void)testBlockLeak3 {
    //下面两个都可以
    __weak typeof(self) wself = self;
//    __weak __typeof(self) wself = self;
    self.testBlock2 = ^(ViewController *vc) {
        wself.name = @"";
    };
    self.testBlock2(self);
}

//正常使用timer
- (void)testTimer1 {
    //runloop->timer->self->timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loopSelector) userInfo:nil repeats:YES];
}

//从父控制器移除移除timer,dealloc不用移除了
- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)testTimer2 {
    //不会存在循环引用  self->timer     runloop->timer->block
    __weak typeof(self) wself = self;
    //注意：该方法必须要ios10之后才行
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        wself.name = @"";
        NSLog(@"timer的打印");
    }];
}

- (void)testTimer3 {
    //使用target作为中间代理对象，这个selector是对target发送消息，因此target要解决方法调用的问题，否则会崩溃
    __weak typeof(self) wself = self;
    self.target = [[LSTarget alloc] initWithBlock:^{
        [wself loopSelector];
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.target selector:@selector(loopMethod) userInfo:nil repeats:YES];
}

- (void)testTime4 {
    self.lsTimer = [[LSTimerWapper alloc] initTimerWithInterval:1 target:self selector:@selector(loopSelector) repeat:YES];
}

- (void)testTimer5 {
    //使用虚类NSProxy转发消息给当前类
    self.proxy = [LSProxy propxyWithPerformObject:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self.proxy selector:@selector(loopSelector) userInfo:nil repeats:YES];
}

- (void)testTimer6 {
    //使用虚类NSProxy转发消息给当前类，封装一下
    //属性持有自动释放，释放时机跟当前控制器一样，无需在dealloc中结束
    self.proxyWrapper = [[LSProxyTimerWrapper alloc] initTimerWithInterval:1 target:self selector:@selector(loopSelector) userInfo:nil repeat:YES];
}

- (void)loopSelector {
    NSLog(@"timer的打印");
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.lsTimer) {
        [self.lsTimer removeTimer];
    }
}

@end
