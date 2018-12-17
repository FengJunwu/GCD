//
//  ViewController.m
//  GCD
//
//  Created by 冯俊武 on 2018/12/3.
//  Copyright © 2018 冯俊武. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic,assign) int ticketSurplusCount;

@end

@implementation ViewController

{
    dispatch_semaphore_t semaphore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /*
     本文用来介绍  iOS 多线程中 GCD 的相关知识以及使用方法。这大概是史上最详细、清晰的关于 GCD 的详细讲解+总结的文章了。通过本文，您将了解到：
     
     GCD 简介
     GCD 任务和队列
     GCD 的使用步骤
     GCD 的基本使用（6种不同组合区别）
     GCD 线程间的通信
     GCD 的其他方法（栅栏方法：dispatch_barrier_async、延时执行方法：dispatch_after、一次性代码（只执行一次）：dispatch_once、快速迭代方法：dispatch_apply、队列组：dispatch_group、信号量：dispatch_semaphore
     
     作者：行走的少年郎
     链接：https://juejin.im/post/5a90de68f265da4e9b592b40
     来源：掘金
     著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
     */
    
    /*
     1、为什么要使用GCD?
        因为GCD有很多好处，具体如下：
        1、GCD 可以用于多核计算
        2、GCD 会自动利用更多的CPU 内核（比如双核、四核）
        3、GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
        4、程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码
     
     
     */
    
    
    /*
     2、GCD 任务和对列
     
        任务：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。
     
            同步执行(sync):
                同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
                只能在当前线程中执行任务，不具备开启新线程的能力。
     
            异步执行(async):
                异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
                可以在新的线程中执行任务，具备开启新线程的能力。
     
     
        对列 (Dispathc Queue):这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。
            在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
     
            串行队列（Serial Dispatch Queue）:
                每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）;
     
            并发队列（Concurrent Dispatch Queue）:
                可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）;
                *注意：并发队列 的并发功能只有在异步（dispatch_async）函数下才有效
     */
    
    
    
    /*
     3、GCD 的使用步骤
        创建一个队列（串行队列或并发队列）
        将任务追加到任务的等待队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）
     
     */
    
    /*
     3.1 队列的创建方法/获取方法
     
        可以使用dispatch_queue_create来创建队列，需要传入两个参数，第一个参数表示队列的唯一标识符，用于 DEBUG，可为空，Dispatch Queue 的名称推荐使用应用程序 ID 这种逆序全程域名；第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。
     */
    //串行对列的创建方法
//    dispatch_queue_t queue_serial = dispatch_queue_create("com.fjw.test1", DISPATCH_QUEUE_SERIAL);
    //并发对列的创建方法
//    dispatch_queue_t queue_concurrent = dispatch_queue_create("con.fjw.test2", DISPATCH_QUEUE_CONCURRENT);
    
    /*
     对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。
     所有放在主队列中的任务，都会放到主线程中执行。
     可使用dispatch_get_main_queue()获得主队列。
     */
    //主对列的获取方式
//    dispatch_queue_t queue_main = dispatch_get_main_queue();
    
    /*
     对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。
     可以使用dispatch_get_global_queue来获取。需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。
     */
    //全局并发对列的获取方法
//    dispatch_queue_t queue_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*
     3.2 任务的创建方法
        GCD 提供了同步执行任务的创建方法dispatch_sync和异步执行任务创建方法dispatch_async。
     */
    //同步执行任务创建方法
//    dispatch_sync(queue_concurrent, ^{
//        NSLog(@"11");
//    });
    //异步执行任务创建方法
//    dispatch_async(queue_concurrent, ^{
//        NSLog(@"22");
//    });
    
    
    
    /*
     4、GCD 的基本使用
     */
#pragma mark--1、同步执行+并发对列
    //1、同步执行+并发对列
    /*
     所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
     所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行的（同步任务需要等待队列的任务执行结束）。
     任务按顺序执行的。按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。

     */
//    [self syncConcurrent];
    
#pragma mark--2、异步执行+并发对列
    //2、异步执行+并发对列
    /*
     可以开启多个线程，任务交替（同时）执行。
     */
//    [self asyncConcurrent];
    
#pragma mark--3、同步执行+串行对列
    //3、同步执行+串行对列
    /*
     不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
     */
//    [self syncSerial];
    
#pragma mark--4、异步执行+串行对列
    //4、异步执行+串行对列
    /*
     会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
     */
//    [self asyncSerial];
    
#pragma mark--5、同步执行+主对列
    //5、同步执行+主对列
    /*
     相互等待卡主不可行
     */
//    [self syncMain];
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
#pragma mark--6、异步执行+主对列
    //6、异步执行+主对列
    /*
     只在主线程中执行任务，执行完一个任务，再执行下一个任务
     */
//    [self asyncMain];
    
#pragma mark--7、GCD 线程间的通信
    //7、GCD 线程间的通信
    /*
     在 iOS 开发过程中，我们一般在主线程里边进行 UI 刷新，例如：点击、滚动、拖拽等事件。我们通常把一些耗时的操作放在其他线程，比如说图片下载、文件上传等耗时操作。而当我们有时候在其他线程完成了耗时操作时，需要回到主线程，那么就用到了线程之间的通讯。
     */
//    [self communication];
#pragma mark--8、删栏方法 dispatch_barrier_async
    //8、删栏方法 dispatch_barrier_async
    /*
     我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于 栅栏 一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
     dispatch_barrier_async函数会等待前边追加到并发队列中的任务全部执行完毕之后，再将指定的任务追加到该异步队列中。然后在dispatch_barrier_async函数追加的任务执行完毕之后，异步队列才恢复为一般动作，接着追加任务到该异步队列并开始执行。
     */
//    [self barrier];
#pragma mark--9、GCD延时执行方法：dispatch_affter
    //9、GCD延时执行方法：dispatch_affter
    /*
     我们经常会遇到这样的需求：在指定时间（例如3秒）之后执行某个任务。可以用 GCD 的dispatch_after函数来实现。
     需要注意的是：dispatch_after函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after函数是很有效的。
     */
//    [self after];
#pragma mark--10、GCD 一次性代码 （只执行一次）：dispatch_once
    //10、GCD 一次性代码 （只执行一次）：dispatch_once
    /*
     我们在创建单例、或者有整个程序运行过程中只执行一次的代码时，我们就用到了 GCD 的 dispatch_once 函数。使用
     dispatch_once 函数能保证某段代码在程序运行过程中只被执行1次，并且即使在多线程的环境下，dispatch_once也可以保证线程安全。
     */
//    [self once];
    
#pragma mark--11、GCD 快速迭代方法：dispatch_apply
    //11、GCD 快速迭代方法：dispatch_apply
    /*
     通常我们会用 for 循环遍历，但是 GCD 给我们提供了快速迭代的函数dispatch_apply。dispatch_apply按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
     我们可以利用异步队列同时遍历。比如说遍历 0~5 这6个数字，for 循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历多个数字。
     */
//    [self apply];
    
#pragma mark-- CGD的队列组：dispatch_group
    //12、GCD 的队列组：dispatch_group
    /*
     有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。
     
     调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合 来实现
     dispatch_group_async。
     调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。
     */
#pragma mark--12.1 dispatch_group_notify
    //12.1 dispatch_group_notify
    /*
     监听 group 中任务的完成状态，当所有的任务都执行完成后，追加任务到 group 中，并执行任务。
     */
//    [self groupNotify];
    
#pragma mark--12.2 dispatch_group_wait
    //12.2 dispatch_group_wait
    /*
     暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行。
     */
//    [self groupWait];
    
#pragma mark--12.3 dispatch_group_enter、dispatch_group_leave
    //12.3 dispatch_group_enter、dispatch_group_leave
    /*
     dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
     dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
     当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
     */
//    [self groupEnterAndLeave];
    
#pragma mark--13 GCD 信号量：dispatch_semaphore
    //13、GCD 信号量：dispatch_semaphore
    /*
     GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
     Dispatch Semaphore 提供了三个函数。
     */
    
#pragma mark--13.1 Dispatch Semaphore 线程同步
    //13.1 Dispatch Semaphore 线程同步
    /*
     我们在开发中，会遇到这样的需求：异步执行耗时任务，并使用异步执行的结果进行一些额外的操作。换句话说，相当于，将将异步执行任务转换为同步执行任务。比如说：AFNetworking 中 AFURLSessionManager.m 里面的 tasksForKeyPath: 方法。通过引入信号量的方式，等待异步执行任务结果，获取到 tasks，然后再返回该 tasks。
     */
//    [self semaphoreSync];
    
#pragma mark--13.2 Dispatch Semaphore 线程安全和线程同步（为线程加锁）
    //13.2 线程安全（使用 semaphore 加锁）
    
//    [self initTicketStatusNotSave];
    
}

//同步执行+并发对列
-(void)syncConcurrent{
    NSLog(@"currentThread----%@",[NSThread currentThread]);
    NSLog(@"syncConcurrent----begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.fjw.syncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    NSLog(@"syncConcurrent----end");
}



/**
 异步执行+并发对列
 特点：可以开启多个线程，任务交替（同时）执行。
 */
-(void)asyncConcurrent{
    NSLog(@"currentThread----%@",[NSThread currentThread]);
    NSLog(@"asyncCurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.fjw.asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    NSLog(@"asyncConcurrent----end");
}



/**
 同步执行+串行对列
 */
-(void)syncSerial{
    
    NSLog(@"currentThread----%@",[NSThread currentThread]);
    NSLog(@"asyncCurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.fjw.syncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    NSLog(@"asyncConcurrent----end");
    
}


/**
 异步执行+串行对列
 会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
-(void)asyncSerial{
    
    NSLog(@"currentThread----%@",[NSThread currentThread]);
    NSLog(@"asyncCurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.fjw.asyncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务一
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
    
    /*
     2018-12-05 13:57:58.883975+0800 GCD[12039:1950772] Could not load IOSurface for time string. Rendering locally instead.
     2018-12-05 13:57:59.013382+0800 GCD[12039:1950772] currentThread----<NSThread: 0x281e11900>{number = 1, name = main}
     2018-12-05 13:57:59.013479+0800 GCD[12039:1950772] asyncCurrent---begin
     2018-12-05 13:57:59.013599+0800 GCD[12039:1950772] asyncSerial---end
     2018-12-05 13:58:01.019794+0800 GCD[12039:1950862] 1---<NSThread: 0x281e61c80>{number = 4, name = (null)}
     2018-12-05 13:58:03.023356+0800 GCD[12039:1950862] 1---<NSThread: 0x281e61c80>{number = 4, name = (null)}
     2018-12-05 13:58:05.028869+0800 GCD[12039:1950862] 2---<NSThread: 0x281e61c80>{number = 4, name = (null)}
     2018-12-05 13:58:07.031967+0800 GCD[12039:1950862] 2---<NSThread: 0x281e61c80>{number = 4, name = (null)}
     2018-12-05 13:58:09.032888+0800 GCD[12039:1950862] 3---<NSThread: 0x281e61c80>{number = 4, name = (null)}
     2018-12-05 13:58:11.036777+0800 GCD[12039:1950862] 3---<NSThread: 0x281e61c80>{number = 4, name = (null)}
     
     异步执行+串行对列 可以看到：
     开启了一条新线程（异步执行具备开启新线程的能力，串行队列只开启一个线程）。
     所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
     任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）
     
     */
    
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMain {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
    
    /*
     2018-12-05 14:16:12.037582+0800 GCD[12064:1954644] currentThread---<NSThread: 0x280972e40>{number = 5, name = (null)}
     2018-12-05 14:16:12.037678+0800 GCD[12064:1954644] syncMain---begin
     2018-12-05 14:16:14.048088+0800 GCD[12064:1954581] 1---<NSThread: 0x28091d700>{number = 1, name = main}
     2018-12-05 14:16:16.049767+0800 GCD[12064:1954581] 1---<NSThread: 0x28091d700>{number = 1, name = main}
     2018-12-05 14:16:18.081785+0800 GCD[12064:1954581] 2---<NSThread: 0x28091d700>{number = 1, name = main}
     2018-12-05 14:16:20.083407+0800 GCD[12064:1954581] 2---<NSThread: 0x28091d700>{number = 1, name = main}
     2018-12-05 14:16:22.089215+0800 GCD[12064:1954581] 3---<NSThread: 0x28091d700>{number = 1, name = main}
     2018-12-05 14:16:24.090886+0800 GCD[12064:1954581] 3---<NSThread: 0x28091d700>{number = 1, name = main}
     2018-12-05 14:16:24.092201+0800 GCD[12064:1954644] syncMain---end
     
     在其他线程中使用同步执行 + 主队列可看到：
     
     所有任务都是在主线程（非当前线程）中执行的，没有开启新的线程（所有放在主队列中的任务，都会放到主线程中执行）。
     所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行（同步任务需要等待队列的任务执行结束）。
     任务是按顺序执行的（主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。
     

     */
}




/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
    
    
    /*
     2018-12-05 14:13:52.880323+0800 GCD[12059:1954004] currentThread---<NSThread: 0x282261340>{number = 1, name = main}
     2018-12-05 14:13:52.880429+0800 GCD[12059:1954004] asyncMain---begin
     2018-12-05 14:13:52.880562+0800 GCD[12059:1954004] asyncMain---end
     2018-12-05 14:13:54.891288+0800 GCD[12059:1954004] 1---<NSThread: 0x282261340>{number = 1, name = main}
     2018-12-05 14:13:56.892571+0800 GCD[12059:1954004] 1---<NSThread: 0x282261340>{number = 1, name = main}
     2018-12-05 14:13:58.894223+0800 GCD[12059:1954004] 2---<NSThread: 0x282261340>{number = 1, name = main}
     2018-12-05 14:14:00.895240+0800 GCD[12059:1954004] 2---<NSThread: 0x282261340>{number = 1, name = main}
     2018-12-05 14:14:02.896292+0800 GCD[12059:1954004] 3---<NSThread: 0x282261340>{number = 1, name = main}
     2018-12-05 14:14:04.897068+0800 GCD[12059:1954004] 3---<NSThread: 0x282261340>{number = 1, name = main}
     
     在异步执行 + 主队列可以看到：
     
     所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）。
     所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
     任务是按顺序执行的（因为主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。
     
     */
    
}



/**
 线程间通讯
 */
-(void)communication{
    //获取全局并发对列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //获取主对列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        //异步追加任务
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1----%@",[NSThread currentThread]);
        }
        
        //回到主线程
        dispatch_async(mainQueue, ^{
           //追加到主线程中执行的任务
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2----%@",[NSThread currentThread]);
        });
    });
    
    /*
     2018-12-05 14:35:49.377777+0800 GCD[12085:1958344] 1----<NSThread: 0x2801f6740>{number = 3, name = (null)}
     2018-12-05 14:35:51.383279+0800 GCD[12085:1958344] 1----<NSThread: 0x2801f6740>{number = 3, name = (null)}
     2018-12-05 14:35:53.384911+0800 GCD[12085:1958234] 2----<NSThread: 0x2801b1900>{number = 1, name = main}
     
     可以看到在其他线程中先执行任务，执行完了之后回到主线程执行主线程的相应操作。
     */
}


/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("com.fjw.barrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    /*
     2018-12-05 14:57:33.493990+0800 GCD[12105:1962776] 2---<NSThread: 0x280f1e400>{number = 4, name = (null)}
     2018-12-05 14:57:33.493990+0800 GCD[12105:1962774] 1---<NSThread: 0x280f0dc80>{number = 3, name = (null)}
     2018-12-05 14:57:35.495127+0800 GCD[12105:1962776] 2---<NSThread: 0x280f1e400>{number = 4, name = (null)}
     2018-12-05 14:57:35.499693+0800 GCD[12105:1962774] 1---<NSThread: 0x280f0dc80>{number = 3, name = (null)}
     2018-12-05 14:57:37.504472+0800 GCD[12105:1962774] barrier---<NSThread: 0x280f0dc80>{number = 3, name = (null)}
     2018-12-05 14:57:39.505347+0800 GCD[12105:1962774] barrier---<NSThread: 0x280f0dc80>{number = 3, name = (null)}
     2018-12-05 14:57:41.511140+0800 GCD[12105:1962776] 4---<NSThread: 0x280f1e400>{number = 4, name = (null)}
     2018-12-05 14:57:41.511140+0800 GCD[12105:1962774] 3---<NSThread: 0x280f0dc80>{number = 3, name = (null)}
     2018-12-05 14:57:43.515140+0800 GCD[12105:1962774] 3---<NSThread: 0x280f0dc80>{number = 3, name = (null)}
     2018-12-05 14:57:43.515435+0800 GCD[12105:1962776] 4---<NSThread: 0x280f1e400>{number = 4, name = (null)}
     
     在dispatch_barrier_async相关代码执行结果中可以看出：
     
     在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作。

     */
}


/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
    
    /*
     2018-12-05 17:37:38.088098+0800 GCD[12276:2001599] currentThread---<NSThread: 0x283877100>{number = 1, name = main}
     2018-12-05 17:37:38.088220+0800 GCD[12276:2001599] asyncMain---begin
     2018-12-05 17:37:40.236680+0800 GCD[12276:2001599] after---<NSThread: 0x283877100>{number = 1, name = main}
     
     在dispatch_after相关代码执行结果中可以看出：在打印 asyncMain---begin 之后大约 2.0 秒的时间，打印了 after---<NSThread: 0x60000006ee00>{number = 1, name = main}
     
     */
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
-(void)once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只执行1次的代码（这里默认是线程安全的）
    });
}

/**
 * 快速迭代方法 dispatch_apply
 */
- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
    
    /*
     2018-12-05 18:10:21.723214+0800 GCD[12313:2007318] apply---begin
     2018-12-05 18:10:21.723576+0800 GCD[12313:2007370] 1---<NSThread: 0x282946740>{number = 3, name = (null)}
     2018-12-05 18:10:21.723757+0800 GCD[12313:2007370] 2---<NSThread: 0x282946740>{number = 3, name = (null)}
     2018-12-05 18:10:21.723785+0800 GCD[12313:2007318] 0---<NSThread: 0x282915000>{number = 1, name = main}
     2018-12-05 18:10:21.723836+0800 GCD[12313:2007370] 3---<NSThread: 0x282946740>{number = 3, name = (null)}
     2018-12-05 18:10:21.723853+0800 GCD[12313:2007318] 4---<NSThread: 0x282915000>{number = 1, name = main}
     2018-12-05 18:10:21.723917+0800 GCD[12313:2007370] 5---<NSThread: 0x282946740>{number = 3, name = (null)}
     2018-12-05 18:10:21.723952+0800 GCD[12313:2007318] apply---end
     
     从dispatch_apply相关代码执行结果中可以看出：
     
     0~5 打印顺序不定，最后打印了 apply---end。
     
     因为是在并发队列中异步队执行任务，所以各个任务的执行时间长短不定，最后结束顺序也不定。但是apply---end一定在最后执行。这是因为dispatch_apply函数会等待全部任务执行完毕。
     
     */
}


/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
    /*
     2018-12-05 18:25:08.826694+0800 GCD[12318:2009328] currentThread---<NSThread: 0x28348b2c0>{number = 1, name = main}
     2018-12-05 18:25:08.826786+0800 GCD[12318:2009328] group---begin
     2018-12-05 18:25:10.833098+0800 GCD[12318:2009397] 2---<NSThread: 0x2834ddd00>{number = 3, name = (null)}
     2018-12-05 18:25:10.833110+0800 GCD[12318:2009398] 1---<NSThread: 0x2834fe040>{number = 4, name = (null)}
     2018-12-05 18:25:12.838508+0800 GCD[12318:2009397] 2---<NSThread: 0x2834ddd00>{number = 3, name = (null)}
     2018-12-05 18:25:12.838563+0800 GCD[12318:2009398] 1---<NSThread: 0x2834fe040>{number = 4, name = (null)}
     2018-12-05 18:25:14.840206+0800 GCD[12318:2009328] 3---<NSThread: 0x28348b2c0>{number = 1, name = main}
     2018-12-05 18:25:16.841772+0800 GCD[12318:2009328] 3---<NSThread: 0x28348b2c0>{number = 1, name = main}
     2018-12-05 18:25:16.841979+0800 GCD[12318:2009328] group---end
     
     从dispatch_group_notify相关代码运行输出结果可以看出： 当所有任务都执行完成之后，才执行dispatch_group_notify block 中的任务。
     */
}


/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
    
    /*
     2018-12-05 18:34:31.193180+0800 GCD[12322:2010660] currentThread---<NSThread: 0x281b86e00>{number = 1, name = main}
     2018-12-05 18:34:31.193282+0800 GCD[12322:2010660] group---begin
     2018-12-05 18:34:33.199008+0800 GCD[12322:2010710] 2---<NSThread: 0x281bd1140>{number = 3, name = (null)}
     2018-12-05 18:34:33.199016+0800 GCD[12322:2010711] 1---<NSThread: 0x281be4dc0>{number = 4, name = (null)}
     2018-12-05 18:34:35.202788+0800 GCD[12322:2010711] 1---<NSThread: 0x281be4dc0>{number = 4, name = (null)}
     2018-12-05 18:34:35.204353+0800 GCD[12322:2010710] 2---<NSThread: 0x281bd1140>{number = 3, name = (null)}
     2018-12-05 18:34:35.204524+0800 GCD[12322:2010660] group---end
    
     从dispatch_group_wait相关代码运行输出结果可以看出： 当所有任务执行完成之后，才执行 dispatch_group_wait 之后的操作。但是，使用dispatch_group_wait 会阻塞当前线程。
     */
    
    
}



/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        // 等前面的异步操作都执行完毕后，回到主线程.
//        for (int i = 0; i < 2; ++i) {
//            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
//            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
//        }
//        NSLog(@"group---end");
//    });
    
        // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
        NSLog(@"group---end");
    
    /*
     从dispatch_group_enter、dispatch_group_leave相关代码运行结果中可以看出：当所有任务执行完成之后，才执行 dispatch_group_notify 中的任务。这里的dispatch_group_enter、dispatch_group_leave组合，其实等同于dispatch_group_async。
     */
    
}


/**
 * semaphore 线程同步
 */
- (void)semaphoreSync {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
    
    /*
     2018-12-05 19:43:21.870168+0800 GCD[12486:2022778] currentThread---<NSThread: 0x280baf240>{number = 1, name = main}
     2018-12-05 19:43:21.870271+0800 GCD[12486:2022778] semaphore---begin
     2018-12-05 19:43:23.872166+0800 GCD[12486:2022856] 1---<NSThread: 0x280bef100>{number = 4, name = (null)}
     2018-12-05 19:43:23.872474+0800 GCD[12486:2022778] semaphore---end,number = 100
     
     semaphore---end 是在执行完  number = 100; 之后才打印的。而且输出结果 number 为 100。
     这是因为异步执行不会做任何等待，可以继续执行任务。异步执行将任务1追加到队列之后，不做等待，接着执行dispatch_semaphore_wait方法。此时 semaphore == 0，当前线程进入等待状态。然后，异步任务1开始执行。任务1执行到dispatch_semaphore_signal之后，总信号量，此时 semaphore == 1，dispatch_semaphore_wait方法使总信号量减1，正在被阻塞的线程（主线程）恢复继续执行。最后打印semaphore---end,number = 100。这样就实现了线程同步，将异步执行任务转换为同步执行任务。
     */
    
}

///**
// * 线程安全：使用 semaphore 加锁
// * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
// */
//- (void)initTicketStatusSave {
//    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
//    NSLog(@"semaphore---begin");
//
//    semaphoreLock = dispatch_semaphore_create(1);
//
//    self.ticketSurplusCount = 50;
//
//    // queue1 代表北京火车票售卖窗口
//    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
//    // queue2 代表上海火车票售卖窗口
//    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
//
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(queue1, ^{
//        [weakSelf saleTicketSafe];
//    });
//
//    dispatch_async(queue2, ^{
//        [weakSelf saleTicketSafe];
//    });
//}
//
///**
// * 售卖火车票(线程安全)
// */
//- (void)saleTicketSafe {
//    while (1) {
//        // 相当于加锁
//        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
//
//        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
//            self.ticketSurplusCount--;
//            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
//            [NSThread sleepForTimeInterval:0.2];
//        } else { //如果已卖完，关闭售票窗口
//            NSLog(@"所有火车票均已售完");
//
//            // 相当于解锁
//            dispatch_semaphore_signal(semaphoreLock);
//            break;
//        }
//
//        // 相当于解锁
//        dispatch_semaphore_signal(semaphoreLock);
//    }
//}

/**
 * 非线程安全：不使用 semaphore
 * 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
- (void)initTicketStatusNotSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    semaphore = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 50;
    
    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {
    while (1) {
        
        
        // 相当于加锁
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            // 相当于解锁
            dispatch_semaphore_signal(semaphore);
            break;
        }
        // 相当于解锁
        dispatch_semaphore_signal(semaphore);
    }
}



@end
