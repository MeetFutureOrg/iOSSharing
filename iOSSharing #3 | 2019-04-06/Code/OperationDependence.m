//
//  OperationDependence.m
//  MacDemo
//
//  Created by Kystar's Mac Book Pro on 2019/4/8.
//  Copyright © 2019 kystar. All rights reserved.
//

#import "OperationDependence.h"

@implementation OperationDependence

- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("com.mf.barrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"等待任务1，2上面执行完毕");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4");
    });
}

- (void)groupNotifier {
    // 全局变量group
    dispatch_group_t group = dispatch_group_create();
    // 并行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 进入组（进入组和离开组必须成对出现, 否则会造成死锁）
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
        dispatch_group_leave(group);
    });

    // 进入组
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        NSLog(@"2");
        dispatch_group_leave(group);
    });
    
    // wait：可以不使用
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"3");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"main");
        });
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{  // 监听组里所有线程完成的情况
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"4");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"5");
            });
            
        });
        
        dispatch_group_leave(group);
    });
}

- (void)operationDependency {
    //创建队列
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    //创建操作
    NSBlockOperation *operation1=[NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第1次操作，线程：%@",[NSThread currentThread]);
    }];
    NSBlockOperation *operation2=[NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第2次操作，线程：%@",[NSThread currentThread]);
    }];
    NSBlockOperation *operation3=[NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第3次操作，线程：%@",[NSThread currentThread]);
    }];
    //添加依赖
    [operation1 addDependency:operation2];
    [operation2 addDependency:operation3];
    //将操作添加到队列中去
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    
}

-(void)semaphore {
    /*比如说我们需要请求三张元素图，拼合成一张海报。
      我们需要先对元素图进行请求而后才能合成海报，这就形成了依赖关系。
      我们通过semaphore限制资源数为3，供请求元素图使用，待请求完成后，释放信号量，便能走到合成的耗时操作。
    */
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    
    //元素图1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"请求第1张元素图");
        sleep(1);
        NSLog(@"第1张元素图Get");
        dispatch_semaphore_signal(semaphore);
    });
    
    //元素图2
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"请求第2张元素图");
        sleep(1);
        NSLog(@"第2张元素图Get");
        dispatch_semaphore_signal(semaphore);
    });
    
    //元素图3
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"请求第3张元素图");
        sleep(1);
        NSLog(@"第3张元素图Get");
        dispatch_semaphore_signal(semaphore);
    });
    
    //合成海报
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"合成海报");
        sleep(1);
        NSLog(@"海报Get");
        dispatch_semaphore_signal(semaphore);
    });
}

@end
