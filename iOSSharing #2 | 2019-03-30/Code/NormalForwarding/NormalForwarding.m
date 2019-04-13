//
//  NormalForwarding.m
//  ForwardInvocation
//
//  Created by xiebangyao on 2018/8/4.
//  Copyright © 2018年 xby. All rights reserved.
//

#import "NormalForwarding.h"

@implementation NormalForwarding
- (void)nonExistentMethod {
    printf("[✅] %s 对 %s 进行了响应.\n", self.className.UTF8String, __FUNCTION__);
}

@end
