//
//  LostMethodClass_FastFowarding.m
//  ForwardInvocation
//
//  Created by xiebangyao on 2018/8/4.
//  Copyright © 2018年 xby. All rights reserved.
//

#import "LostMethodClass_FastFowarding.h"
#import <objc/runtime.h>
#import "FastFowarding.h"

@implementation LostMethodClass_FastFowarding {
    FastFowarding *_fastFowarding;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    printf("[2️⃣] 转发给其它对象去响应 %s方法.\n", NSStringFromSelector(aSelector).UTF8String);
    _fastFowarding = [FastFowarding new];
    if ([_fastFowarding respondsToSelector:@selector(nonExistentMethod)]) { //如果FastFowarding对象能响应这个方法，那就让该对象去处理
        return _fastFowarding;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
