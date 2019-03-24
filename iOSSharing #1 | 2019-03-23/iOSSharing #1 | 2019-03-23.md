# 目录
## [1、Runtime存在的意义是什么?](#21)
## [2、根元类的isa指针指向谁?](#22)
## [3、根元类的superClass指针指向谁？](#23)
## [4、函数四要素都是什么？](#24)
## [5、实例方法去哪里找？](#25)

***

<h2 id="21">1、Runtime存在的意义是什么？</h2>
答：Objective-C 是一门动态语言，它会将一些工作放在代码运行时才处理而并非编译时。也就是说，有很多类和成员变量在我们编译的时是不知道的，而在运行时，我们所编写的代码会转换成完整的确定的代码运行。因此，只有编译器是不够的，我们还需要一个运行时系统(Runtime system)来处理编译后的代码。
这就是 Objective-C Runtime 系统存在的意义，它是整个Objc运行框架的一块基石。

平时编写的OC代码，底层都是由他实现的，如：
```objc
[receiver message];
//底层运行时会被编译器转化为：
objc_msgSend(receiver, selector)
//如果其还有参数比如：
[receiver message:(id)arg...];
//底层运行时会被编译器转化为：
objc_msgSend(receiver, selector, arg1, arg2, ...)

```

***

<h2 id="22">2、根元类的isa指针指向谁？</h2>
答： 见下一问

*** 

<h2 id="23">3、根元类的superClass指针指向谁？</h2>
答：这两题一起回答。首先看下图：

![nsobject](https://user-gold-cdn.xitu.io/2019/3/22/169a4d7604d9975b?w=986&h=1010&f=jpeg&s=102113)

先说几个概念：</br>
1）supercalss : 父类</br>
2）subclass: 子类</br>
3）isa : 概念不好说，官方文档说的也不清晰。作用是根据 isa 指针就可以找到对象所属的类，但是isa指针在代码运行时并不总指向实例对象所属的类型，所以不能依靠它来确定类型，要想确定类型还是需要用对象的 -class 方法。（PS:KVO 的实现机理就是将被观察对象的isa指针指向一个中间类而不是真实类型。）</br>
4）class : 类，一个运行时类中关联了它的父类指针、类名、成员变量、方法、缓存以及附属的协议。（一个实例对象是一个类的实例）</br>
5）meta class :元类，Objc 类本身也是一个对象
，类对象所属的类就叫做元类（一个类是元类的实例）</br>

第一列是类的实例变量，如：[Person new]或者[[Person alloc] init]出来的对象；</br>
第二列是类本身，存放父类指针、类名、成员变量、方法、缓存以及附属的协议的信息；</br>
第三列是元类</br>

* 1）isa路线：
    * 实例对象的isa指向Class
    * Class的isa指向Meta Class
    * Meta Class的isa指向根元类Root Meta Class
    * 根元类的isa指向自己</br>
* 2）superclass路线：</br>
    * 实例对象没有superclass ；</br>
    * 实例对象所在的类，存在superclass，类的superclass后面会指向Root Class，Root Class的super Class是nil；</br>
    * 元类也存在superclass，元类的superclass后面会指向Root Meta Class，而Root Meta Class的superclass却是Root Class。</br>

所以：
* 根元类的isa指针指向自己
* 根元类的superclass指向root class
* 根类的isa指向根元类
* 根类的superclass指向nil

附旧版Class结构：
```objc
typedef struct objc_class *Class;
Class 其实是指向 objc_class 结构体的指针。objc_class 的数据结构如下：
struct objc_class {
    Class isa  OBJC_ISA_AVAILABILITY;
#if !__OBJC2__
    Class super_class                                        OBJC2_UNAVAILABLE;
    const char *name                                         OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
#endif
} OBJC2_UNAVAILABLE;

```

旧版
![objc-old](https://user-gold-cdn.xitu.io/2019/3/22/169a536128859601?w=1242&h=2688&f=png&s=682226)
新版

![objc-new](https://user-gold-cdn.xitu.io/2019/3/22/169a536574fa230c?w=1242&h=2688&f=png&s=718638)

***
<h2 id="24">4、函数四要素都是什么？</h2>
答：函数名，函数参数，参数类型，返回值类型（PS:ObjC一般叫方法，不叫函数）

### OC method简单介绍
```objc
typedef struct objc_method *Method;
struct objc_method {
    SEL method_name OBJC2_UNAVAILABLE;  //方法名
    char *method_types OBJC2_UNAVAILABLE;   //方法类型
    IMP method_imp OBJC2_UNAVAILABLE;   //方法实现
}
```
objc_method 存储了方法名，方法类型和方法实现。

### 方法名类型为 SEL

方法类型 method_types 是个 char 指针，存储方法的参数类型和返回值类型
method_imp 指向了方法的实现，本质是一个函数指针
Ivar
Ivar 是表示成员变量的类型。
```objc
typedef struct objc_ivar *Ivar;
struct objc_ivar {
    char *ivar_name OBJC2_UNAVAILABLE;
    char *ivar_type OBJC2_UNAVAILABLE;
    int ivar_offset OBJC2_UNAVAILABLE;
#ifdef __LP64__
    int space OBJC2_UNAVAILABLE;
#endif
}
```
其中 ivar_offset 是基地址偏移字节

### IMP

IMP在objc.h中的定义是：
```objc
typedef id (*IMP)(id, SEL, ...);
```
它就是一个函数指针，这是由编译器生成的。当你发起一个 ObjC 消息之后，最终它会执行的那段代码，就是由这个函数指针指定的，而 IMP 这个函数指针就指向了这个方法的实现。


***
<h2 id="25">5、实例方法去哪里找？</h2>
答：其所属的类的方法表

### 拓展
问：oc是如何找到需要执行哪个方法的？</br>
答：当需要执行某个实例方法的时候（类方法类似），oc会先去该类的方法的缓存列表里面查找，若找到了，则执行，否则，去该类的方法列表中查找是否存在该方法，存在，执行该方法并更新方法缓存列表，否则，去该父类缓存以及父类方法列表查找，直到根类，若还未找到，则启用动态解析以及消息转发流程，若还是失败，报unrecognized selector异常


![](https://user-gold-cdn.xitu.io/2019/3/23/169aaa87c8593084?w=1410&h=2926&f=jpeg&s=687328)

感谢大佬提供的流程图

***
## 联系方式
**邮箱：** xiebangyao_1994@163.com</br>
**相关账号：**
* [掘金 - Adrenine](https://juejin.im/user/57c39bfb79bc440063e5ad44)
* [简书 - Adrenine](https://www.jianshu.com/u/b20be2dcb0c3)
* [Blog - Adrenine](https://adrenine.github.io/)
* [Github - Adrenine](https://github.com/Adrenine)