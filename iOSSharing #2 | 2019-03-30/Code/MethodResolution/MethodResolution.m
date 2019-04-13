//
//  MethodResolution.m
//  ForwardInvocation
//
//  Created by xiebangyao on 2018/8/4.
//  Copyright © 2018年 xby. All rights reserved.
//

#import "MethodResolution.h"
#import <objc/runtime.h>

@implementation MethodResolution

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

//实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    printf("[1️⃣] %s 未实现. \n", NSStringFromSelector(sel).UTF8String);
    if (sel == @selector(nonExistentMethod)) {  //如果是要响应这个方法，那么动态添加一个方法进去
        class_addMethod(self, sel, (IMP)dynamicAddMethodIMP, "@@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

//类方法
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    printf("[1️⃣] %s 未实现. \n", NSStringFromSelector(sel).UTF8String);
//    if (sel == @selector(nonExistentMethod)) {
//        class_addMethod(self, sel, (IMP)dynamicAddMethodIMP, "@@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

id dynamicAddMethodIMP(id self, SEL _cmd) {
    printf("[✅] 调用了动态添加的方法: %s. \n", __FUNCTION__);
    return @"YES!";
}

#pragma clang diagnostic pop
@end
