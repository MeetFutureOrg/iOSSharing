//
//  CustomDictionary.h
//  MacDemo
//
//  Created by Kystar's Mac Book Pro on 2019/4/8.
//  Copyright © 2019 kystar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomDictionary : NSObject

// 读取数据，并发操作
- (id)objectForKey:(NSString *)key;

// 写入数据，异步栅栏
- (void)setObject:(id)obj forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
