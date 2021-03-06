# iOS Sharing
**Knowledge points about iOS.**

### [#01 | 2019-03-23](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%231%20%7C%202019-03-23/iOSSharing%20%231%20%7C%202019-03-23.md)
#### 1、Runtime存在的意义是什么?
#### 2、根元类的isa指针指向谁?
#### 3、根元类的superClass指针指向谁？
#### 4、函数四要素都是什么？
#### 5、实例方法去哪里找？

### [#02 | 2019-03-30](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%232%20%7C%202019-03-30/iOSSharing%20%232%20%7C%202019-03-30.md)
#### 1、类方法去哪里找？
#### 2、isa指针有几种类型么？
#### 3、分类的方法具体是在什么时候添加到类的方法列表中？
#### 4、class_addMethod()都需要什么参数?
#### 5、iOS消息转发流程

### [#03 | 2019-04-06](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%233%20%7C%202019-04-06/iOSSharing%20%233%20%7C%202019-04-06.md)
#### 1、atomic关键字内部使用的是什么锁？
#### 2、串行同步、串行异步、并发同步、并发异步各自会开几条线程？
#### 3、为什么需要在主线程更新UI？
#### 4、iOS中如何用多线程实现多读单写?
#### 5、iOS多线程中有多少种方式可以做到等待前面线程执行完毕再执行后面的线程？

### [#04 | 2019-04-13](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%234%20%7C%202019-04-13/iOSSharing%20%234%20%7C%202019-04-13.md)
#### 1、请用一句话概述分类的概念，并阐述分类的优点。
#### 2、多个同宿主分类中的都重写了一个同名方法，哪个分类的同名方法会生效？为什么？
#### 3、@property(copy)NSMutableArray *array这样声明属性会出现什么问题？
#### 4、说一说KVO在重写NSKVONotifying对象的setter方法中，添加了哪两个关键方法？
#### 5、如何实现一个完整的单例？


### [#05 | 2019-04-21](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%235%20%7C%202019-04-21/iOSSharing%20%235%20%7C%202019-04-21.md)
#### 1. Scoket 连接和 HTTP 连接的区别
#### 2. 关于 HTTP 的请求 GET 和 POST 的区别
#### 3. HTTPS 加密过程与原理
#### 4. Socket 原理
#### 5. 关于 TCP 的慢启动特性

### [#06 | 2019-04-27](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%236%20%7C%202019-04-26/iOSSharing%20%236%20%7C%202019-04-26.md)
#### 1. block的循环引用是如何造成的？
#### 2. 使用UIAnimation的block回调时，需不需要使用__weak避免循环引用？为什么？
#### 3. block属性是否可以用strong修饰？
#### 4. 什么场景下才需要对变量使用__block?
#### 5. 运行以下GCD多线程代码，控制台将打印什么?

### [#07 | 2019-05-05](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%237%20%7C%202019-05-05/iOSSharing%20%237%20%7C%202019-05-05.md)
#### 1. id、self、super 它们从语法上有什么区别？
#### 2. block 修改捕获变量除了用 __block 还可以怎么做？有哪些局限性？
#### 3. 什么情况使用 weak 关键字，相比 assign 有什么不同？
#### 4. weak属性需要在dealloc中置nil么？
#### 5. ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些？

### [#08 | 2019-05-12](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%238%20%7C%202019-05-12/iOSSharing%20%238%20%7C%202019-05-12.md)
#### 1. NSUserDefaults 能够存储哪些类型的数据？可以存储可变数据类型吗？可以存储自定义数据类型吗？
#### 2. NSUserDefaults 没有存储 key 的时候默认返回什么？
#### 3. NSUserDefaults 存取操作是什么？它将数据存在何处？并且它是如何保持数据一致性的?
#### 4. NSUserDefaults 旧数据总能被新设置的替换吗？
#### 5. NSUserDefaults 性能如何?

### [#09 | 2019-05-19](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%239%20%7C%202019-05-19/iOSSharing%20%239%20%7C%202019-05-19.md)
#### 1. setNeedsLayout、layoutIfNeeded与layoutSubviews区别？
#### 2. UIView与CALayer的区别？
#### 3. loadView什么时候被调用？它有什么作用？默认实现是怎么样的？
#### 4. UIViewController的完整生命周期？
#### 5. UIView动画支持的属性有哪些？

### [#10 | 2019-05-27](https://github.com/MeetFutureOrg/iOSSharing/blob/master/iOSSharing%20%2310%20%7C%202019-05-27/iOSSharing%20%2310%20%7C%202019-05-27.md)

#### 1. Category、 Extension和继承的区别？
#### 2. isKindOfClass、isMemberOfClass作用分别是什么？
#### 3. 开发中逆向传值的方式有哪些？
#### 4. 开发中方法延迟执行的方式有哪些？
#### 5. +load 和 +initialize 的区别是什么？