
# 目录

## [1. block的循环引用是如何造成的？](#31)
## [2. 使用UIAnimation的block回调时，需不需要使用__weak避免循环引用？为什么？](#32)
## [3. block属性是否可以用strong修饰？](#33)
## [4. 什么场景下才需要对变量使用__block?](#34)
## [5. 运行以下GCD多线程代码，控制台将打印什么?](#35)


<h2 id="31">1. block的循环引用是如何造成的？</h2>

```objectivec
------------Light.h------------
#import <Foundation/Foundation.h>
@interface Light : NSObject
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) void (^block)(void);
@end

------------Light.m------------
#import "Light.h"
@implementation Light
@end

------------main.m------------
#import "Light.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        Light *loveLight = [Light alloc] init];
        loveLight.color = @"green";
        
        loveLight.block = ^{
            NSLog(@"%@",loveLight.color);
        };
        
        loveLight.block();
    }
}
```
我们在上面的代码中创建了一个Light（光）类，并声明两个属性color（颜色）及block。然后我们实例化一个对象loveLight并对其属性赋值，实现并调用block，造成循环引用。
然后我们通过clang代码，了解这段代码内部的部分实现：

```objectivec
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  RMPerson *__strong person;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Light *__strong _loveLight, int flags=0) : loveLight(_loveLight) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Light *__strong loveLight = __cself->loveLight; // bound by copy

            NSLog((NSString *)&__NSConstantStringImpl__var_folders_5l_0xn052bn6dgb9z7pfk8bbg740000gn_T_main_d61985_mi_0,((int (*)(id, SEL))(void *)objc_msgSend)((id)loveLight, sel_registerName("color")));
        }

static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {

_Block_object_assign((void*)&dst->loveLight, (void*)src->loveLight, 3/*BLOCK_FIELD_IS_OBJECT*/);

}

...后省略
```

通过clang后的源码我们可以知道：
- 对象的创建本身就是强引用（默认strong修饰）。
- 对象对block属性赋值，在ARC下,block作为返回值时或者赋值给一个strong/copy修饰的对象会自动调用copy，**loveLight强引用block**。
- 对象的block在其内部捕获了对象本身，block在自动调用copy的时候，_Block_object_assign（clang源码最后一行）会根据捕获变量的所有权修饰符，来对变量的引用计数进行操作。此处loveLight本身是strong修饰，则引用计数+1，**block强引用loveLight对象**。
- 所以双方互相引用，造成了循环引用。

同时面试中面试官还可能会询问你如何检测到内存泄漏，我们可以通过Instruments中的Leaks进行检测，也可以选择facebook发布的FBRetainCycleDetector内存泄漏检测工具。

---

<h2 id="32">2. 使用UIView Animation的block回调时，是否需要考虑循环引用的问题？为什么？</h2>

首先UIView Animation使用时，不需要考虑循环引用的问题。

UIKit将动画直接集成到UIView的类中，当内部的一些属性发生改变时，UIView将为这些改变提供动画支持，并以类方法的形式提供接口。

而block造成循环引用的主要原因是对象与block的相互持有，UIView Animation的block本身处于类方法中，在使用时并不属于调用控制器。同时控制器也无法强引用一个类，所以不会造成循环引用的问题。

---

<h2 id="33">3. block属性是否可以用strong修饰？</h2>

~~block属性可以使用strong属性修饰符修饰，但是不推荐，会有内存泄漏的隐患。~~

~~首先，ARC中block用copy属性修饰符修饰是MRC时代延续的产物，提醒开发者可能存在的内存问题。同时copy的确是可以用strong来替代的。~~

~~我们都知道block在OC中有三种类型：~~
~~- _NSConcreateGlobalBlock 全局的静态block，不会访问任何外部变量。~~
~~- _NSConcreateStackBlock 栈区的block，当函数返回时会被销毁。~~
~~- _NSConcreateMallocBlock 堆区的block，当引用计数为0时被销毁。~~

~~block在MRC下可以存在于全局区、栈区和堆区，而在ARC下，block会自动从栈区拷贝到堆区（除了裸写block实现块），所以只存在于全局区和堆区。
所以对于栈区block，MRC下处于栈区，想在作用域外调用就得copy到堆区；ARC则自动copy堆区。~~

~~那么这个时候问题就来了，strong属性修饰符并不能拷贝，就会有野指针错区的可能，造成Crash。这种情况很少见，但是不代表不可能发生，所以最好还是使用copy属性修饰符。~~
    
更正：
针对Block属性修饰符的问题在撰写的时候的确没有考虑周全，我们将在以下予以更正和解答。
首先，在以下情形中block会自动从栈拷贝到堆：
1、当 block 调用 copy 方法时，如果 block 在栈上，会被拷贝到堆上；
2、当 block 作为函数返回值时，编译器自动将 block 作为 _Block_copy 函数，效果等同于直接调用 copy 方法；
3、当 block 被赋值给 __strong id 类型的对象或 block 的成员变量时，编译器自动将 block 作为 _Block_copy 函数，效果等同于直接调用 copy 方法；
4、当 block 作为参数被传入方法名带有 usingBlock 的 Cocoa Framework 方法或 GCD 的 API 时。这些方法会在内部对传递进来的 block 调用 copy 或 _Block_copy 进行拷贝;

那针对上述自动拷贝的情况我们做一个实验：
ARC下strong修饰block，且不引用外部变量，block类型为__NSGlobalBlock
ARC下strong修饰block，引入外部变量，block类型为__NSMallocBlock

所以由此就可以理解为ARC下strong修饰的block并没有处于栈区的可能，也就不存在作用域结束栈区内容销毁野指针的问题了。
但是为了保证修饰符和block特性的一致性，使用copy修饰符仍然是最为合适的。

---

<h2 id="34">4. 什么场景下才需要对变量使用__block?</h2>

赋值场景下使用__block，使用场景下不需要。
我们来对比下赋值场景和使用场景

```objectivec
//赋值场景
NSMutableArray *__block array = nil;

void(^Block)(void) = ^{
    array = [NSMutableArray array];
};

Block();
    
//使用场景
NSMultableArray *array = [NSMultableArray array];

void(^Block)() = ^{
    [array addObject:@"1"];
};

Block();
```

<h2 id="35">5. 运行以下GCD多线程代码，控制台将打印什么?</h2>

```objectivec
dispatch_queue_t gQueue= dispatch_get_global_queue(0, 0);
    
NSLog(@"1");
dispatch_sync(gQueue, ^{
    NSLog(@"2");
    dispatch_sync(gQueue, ^{
        NSLog(@"3");
     });
    NSLog(@"4");
    });
NSLog(@"5");
```

答案：12345

首先打印1，全局队列本质是并发队列也就是并发同步，同步任务不开起线程，在主线程执行打印2。
然后全局队列执行同步任务，依旧不开启线程，在主线程执行打印3。
同步任务完成，依旧存在于全局队列同步执行，打印4.
同步任务完成，打印5。