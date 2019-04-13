//
//  LostMethodClass_NormalFowarding.m
//  ForwardInvocation
//
//  Created by xiebangyao on 2018/8/4.
//  Copyright © 2018年 xby. All rights reserved.
//

#import "LostMethodClass_NormalFowarding.h"
#import "NormalForwarding.h"
#import <objc/runtime.h>

@implementation LostMethodClass_NormalFowarding {
    NormalForwarding *_normalForwarding;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    printf("[3️⃣] 对方法进行签名: %s.\n", NSStringFromSelector(aSelector).UTF8String);
    if (aSelector == @selector(nonExistentMethod)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    printf("[4️⃣] 转发此次调用: %s.\n", NSStringFromSelector(anInvocation.selector).UTF8String);
    if (anInvocation.selector == @selector(nonExistentMethod)) {
        _normalForwarding = [NormalForwarding new];
        [anInvocation invokeWithTarget:_normalForwarding];
    }
}

@end
