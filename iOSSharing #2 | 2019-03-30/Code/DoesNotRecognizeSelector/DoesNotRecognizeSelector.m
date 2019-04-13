//
//  DoesNotRecognizeSelector.m
//  ForwardInvocation
//
//  Created by xiebangyao on 2018/8/4.
//  Copyright © 2018年 xby. All rights reserved.
//

#import "DoesNotRecognizeSelector.h"

@implementation DoesNotRecognizeSelector

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    printf("[5️⃣] 最终抛出错误: %s.\n", NSStringFromSelector(aSelector).UTF8String);
//    [super doesNotRecognizeSelector: aSelector];
}

@end
