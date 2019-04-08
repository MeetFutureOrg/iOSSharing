//
//  CustomDictionary.m
//  MacDemo
//
//  Created by Kystar's Mac Book Pro on 2019/4/8.
//  Copyright © 2019 kystar. All rights reserved.
//

#import "CustomDictionary.h"

@interface CustomDictionary ()

//多线程需要访问的数据量
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

//模拟场景，允许多个线程同时访问字典，但是只有一个线程可以写字典
@implementation CustomDictionary {

    //定义一个并发队列
    dispatch_queue_t _concurrent_queue;
    
}

- (instancetype)init {
    if (self = [super init]) {
        _concurrent_queue = dispatch_queue_create("com.mf.read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        _dataDic = @{}.mutableCopy;
    }
    
    return self;
}

// 读取数据，并发操作
- (id)objectForKey:(NSString *)key {
    __block id obj;
    //同步读取数据
    dispatch_sync(_concurrent_queue, ^{
        obj = [self.dataDic objectForKey:key];
    });
    
    return obj;
    
}

// 写入数据，异步栅栏
- (void)setObject:(id)obj forKey:(NSString *)key {
    //异步栅栏调用设置数据
    dispatch_barrier_async(_concurrent_queue, ^{
        [self.dataDic setObject:obj forKey:key];
    });
}

@end
