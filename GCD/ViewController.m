//
//  ViewController.m
//  GCD
//
//  Created by JND on 2017/12/25.
//  Copyright © 2017年 JND. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /************************************
     * 1.主线程
     ************************************/
    dispatch_async(dispatch_get_main_queue(), ^{
        //主线程中执行
    });
    
    /************************************
     * 2.后台线程处理方法
     ************************************/
    [self performSelectorInBackground:@selector(doWork) withObject:nil];
    
    
#pragma MARK-- dispatch_queue_create 通过GCD的API生成 dispatch queue
    /************************************
     * 3.DISPATCH_QUEUE_CONCURRENT
     * 并发队列
     * 不等待执行中处理结果  使用多个线程
     ************************************/
    dispatch_queue_t myConcurrentDispatchQueus = dispatch_queue_create("com.yanglao.GCD.myConcurrentDispatchQueus", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(myConcurrentDispatchQueus, ^{
        NSLog(@"1111");
    });
    dispatch_async(myConcurrentDispatchQueus, ^{
        NSLog(@"2222");
    });
    dispatch_async(myConcurrentDispatchQueus, ^{
        NSLog(@"3333");
    });
    dispatch_async(myConcurrentDispatchQueus, ^{
        NSLog(@"4444");
    });
    
    
    /************************************
     * 4. Serial Dispatch Queue
     * 串行队列
     * 等待现在执行中的处理结果 使用一个线程
     ************************************/
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("com.yanglao.GCD.mySerialDispatchQueue", NULL);
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"111");
    });
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"222");
    });
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"333");
    });
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"444");
    });
    
#pragma MARK-- Main Dispatch Queue/Global Dispatch Queue 获取系统标准提供的Dispatch Queue
    /************************************
     * 5.Main Dispatch Queue
     * 主线程执行
     ************************************/
    //获取主线程方法
    dispatch_queue_t mainDispatchQueue = dispatch_get_main_queue();
    dispatch_async(mainDispatchQueue, ^{
       //主线程
    });
    /************************************
     * 6.Global Dispatch Queue
     * 全局队列
     ************************************/
    //Global Dispatch Queue(高优先级)的获取方法
    dispatch_queue_t globalDispatchQueueHigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(globalDispatchQueueHigh, ^{
       //最高优先级
    });
    
    //Global Dispatch Queue(默认优先级)的获取方法
    dispatch_queue_t globalDispatchQueueDefault = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalDispatchQueueDefault, ^{
       //默认优先级
    });
    
    //Global Dispatch Queue(低优先级)的获取方法
    dispatch_queue_t globalDispatchQueueLow = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_async(globalDispatchQueueLow, ^{
       //低优先级
    });
    
    //Global Dispatch Queue(后台优先级)的获取方法
    dispatch_queue_t globalDispatchQueueBackGroud = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(globalDispatchQueueBackGroud, ^{
        //后台线程
    });
    
    /************************************
     * 7.dispatch_set_target_queue
     * 变更生成的dispatch Queue 的执行优先级
     ************************************/
    
    /**
     dispatch_set_target_queue 变更执行优先级

     @param object#> Dispatch Queue description#>
     @param queue#> Global Dispatch Queue description#>
     @return 系统提供的 Main Dispatch Queue 和 Global Dispatch Queue 均不可指定
     将 Dispatch Queue 指定为 dispatch_set_target_queue 函数的参数，不仅可以变更Dispatch Queue 的执行优先级，还可以作为Dispatch Queue的执行阶层。
     */
    dispatch_set_target_queue(mySerialDispatchQueue, globalDispatchQueueBackGroud);
    
    
    /************************************
     * 8.dispatch_after
     * dispatch_after 函数并不是在指定时间后执行处理，而是在指定时间追加处理到Dispatch Queue（在3秒后将指定的 block 追加到 Main Dispatch Queue）
     * dispatch_time 一般用于计算相对时间，而 disoatch walltime 函数用于计算绝对时间
     ************************************/
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        NSLog(@"延时3秒后执行");
    });
    
    /************************************
     * 9.Dispatch Group
     *A B C 3个并发下载任务，怎样在第一时间知道任务全部完成？
     dispatch_group 可以帮我们实现这样的控制。
     ************************************/
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"block1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"block2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"block3");
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"完成");
    });
    
    /************************************
     * 10.Dispatch_barrier_async
     * dispatch_barrier_async 函数会等待追加到Concurrent Dispatch Queue 上的并行执行的处理全部处理结束后，在将指定的处理追加到该Concurrent Dispatch Queue 中，然后在由dispatch_barrier_async 函数追加的处理执行完毕后，Concurrent Dispatch Queue 才恢复为一般的动作，追加到Concurrent Dispatch Queue 的处理又开始执行。
     * 试用Concurrent Dispatch Queue 和 Dispatch_barrier_async 函数可实现高效的数据库访问和文件访问。
     ************************************/
    
    dispatch_queue_t MyQueue = dispatch_queue_create("com.yanglao.GCD.MyQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(MyQueue, ^{
        NSLog(@"11111");
    });
    dispatch_async(MyQueue, ^{
        NSLog(@"22222");
    });
    dispatch_async(MyQueue, ^{
        NSLog(@"33333");
    });
    
    dispatch_barrier_async(MyQueue, ^{
        NSLog(@"Dispatch_barrier_async函数");
    });
    dispatch_async(MyQueue, ^{
        NSLog(@"44444");
    });
    dispatch_async(MyQueue, ^{
        NSLog(@"55555");
    });
    dispatch_async(MyQueue, ^{
        NSLog(@"66666");
    });
    
    /************************************
     * 11.dispatch_sync 同步，指定的block"同步"的追加到指定的Dispatch Queue 中，在追加block结束之前，dispatch_sync 函数会一直等待。
     * 我们假设一种情况:执行Main Dispatch Queue 时，使用另外的线程Global Dispatch Queue 进行处理，处理结束后，立即使用得到的结果，这种情况下使用dispatch_sync函数。
     * 一旦调用dispatch_sync 函数，那么在指定的处理结束之前，该函数不会返回。
     * 正因为dispatch_sync 函数使用简单，所以也容易引起问题，即死锁。
     ************************************/
    dispatch_queue_t myQueueSync = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(myQueueSync, ^{
        NSLog(@"同步");
    });
    
    //死锁：1
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_sync(mainQueue, ^{
//        NSLog(@"死锁1");
//    });
    //死锁：2
//    dispatch_queue_t myQueueSync2 = dispatch_queue_create("com.yanglao.GCD.myQueueSync2", NULL);
//    dispatch_async(myQueueSync2, ^{
//        dispatch_sync(queue, ^{
//            NSLog(@"死锁2");
//        });
//    });
    
    /************************************
     * 12.dispatch_apply
     * dispatch_apply 函数是 dispatch_sync 函数和dispatch Group 的关联API。该函数按指定的次数将指定的block追加到Dispatch queue 中，并等待全部执行结束。
     ************************************/
    
    dispatch_queue_t queueApply = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queueApply, ^{
        
        /**
         dipatch_apply

         @param 10 重复次数
         @param queueApply Dispatch Queue
         @param index 带有参数的block
         */
        dispatch_apply(10, queueApply, ^(size_t index) {
            //并列处理全部对象
            NSLog(@"%zu",index);

        });
        
        //dispatch_apply 函数中的处理全部执行结束
        //在Main Dispatch Queue 中非同步执行
        dispatch_sync(dispatch_get_main_queue(), ^{
           //在Main Dispatch Queue 中执行处理
            //用户界面更新
            NSLog(@"完成");
        });
        
        
    });

    /************************************
     *13. dispatch_suspend 暂停
     * dispatch_resume 恢复
     * 当追加大量的dispatch queue 时，在追加处理的时候，有时希望不执行已追加的处理。例如演算结果被block 截获时，一些处理会对这个结果造成影响。
     * 在这种情况下，只要挂起dispatch queue 即可。 当执行时再恢复。
     ************************************/
    
    //dispatch_suspend 函数挂起指定的dispatch queue.
//    dispatch_suspend(queue);
    
    //dispatch_resume 函数恢复指定的dispatch queue;
//    dispatch_resume(queue);
    
    /************************************
     *14. dispatch Semaphone 信号量
     * 是持有计数的信号，该计数是多线程编程中的计数类型信号。所谓信号，类似于过马路时常用的手旗。可以通过时举起手旗，不可通过时放下手旗。而在Dispatch Semaphone 中，使用计数来实现该功能。计数为0时等待，计数为1或大于1时，减去1而不等待。
     *
     ************************************/
    
    //该源代码使用Global Dispatch Queue 更新NSMutableArray类对象，所以执行后由内存错误导致应用程序异常结束的概率很高。此时应用应该使用Dispatch Semaphone
//    dispatch_queue_t queueSemaohone = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 100000; ++i) {
//        dispatch_async(queueSemaohone, ^{
//            [array addObject:[NSNumber numberWithInt:i]];
//        });
//    }
    
    
    dispatch_queue_t queueSemaohone = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /**
     生成Dispatch Semaphone
     dispatch Semaphone 的计数初始值设定为 “1”。
     保证可访问NSMumberArray 类对象的线程同时只能有1个。
     */
    dispatch_semaphore_t semaphone = dispatch_semaphore_create(1);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 100000; ++i) {
        dispatch_async(queueSemaohone, ^{
            /*
             *等待 Dispatch Semaphore
             *一直等待，直到Dispatch Semaphore 的计数值达到大于等于1.
             */
            dispatch_semaphore_wait(semaphone, DISPATCH_TIME_FOREVER);
            /*
             *由于Dispatch Semaphore 的计数达到大于等于1，所以将Dispatch semaphore 的计数减去1，由dispatch_semaphore_wait 函数执行返回。
             *
             *即执行到此时的Dispatch Semaphore 的计数恒为0；
             *
             *由此可访问NSMumberArray 类对象的线程只有一个，因此可安全地进行更新。
             *
             */
            
            [array addObject:[NSNumber numberWithInt:i]];
            
            /*
             * 排他控制处理结束
             *所以通过 dispatch_seamphone_signal 函数，将Dispatch Semaphore 的计数值加1。
             *
             *如果有通过dispatch_semaphone_wait函数,等待Dispatch Semaphore 的计数值增加的线程，就由最先等待的线程执行。
             *
             */
            dispatch_semaphore_signal(semaphone);
        });
    }
    
    /************************************
     * 15.dispatch_once
     * 单例模式 在多线程环境下执行，也可保证百分之百安全。
     ************************************/
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*
         * 初始化
         */
    });
    
    
    
}

/**
 后台线程处理方法
 */
-(void)doWork{
    /*
     长时间处理任务
     */
    
    [self performSelectorOnMainThread:@selector(downWork) withObject:nil waitUntilDone:nil];
    
    
//这是一个测试
}

/**
 主线程处理方法
 */
-(void)downWork{
    /**
     例如用户界面的更新
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
