# 本期为NSUserDefault内容
### 1、关于底层实现，就比如那个 NSUserDefault  ，这个东西怎么存的？ 深一点，这个东西本质就是沙盒里的一个文件， 在深一点，这个东西怎么读写的？ 那就可能用到了 文件读写的类， 在深一点，读写过程中，是怎么保证不会出错，多处同时读写会有什么问题， 那就涉及到线程安全，互斥锁，在深一点，文件读写是需要时间的，怎么保证你写进去了，立马就能读出数据，这也就是NSUserDefault 为什么提供了 synchronize 这个函数。

# 目录

## [1. NSUserDefault能够存储哪些类型的数据？可以存储可变数据类型吗？可以存储自定义数据类型吗？](#31)
## [2. NSUserDefault存取操作是什么？它将数据存在何处？](#32)
## [3. NSUserDefault是如何读取数据的？](#33)
## [4. NSUserDefault是如何存储数据且保持数据一致性的？](#34)
## [5. NSUserDefault没有存储key的时候默认返回什么？有什么方法区分没有key的情况？](#35)


<h2 id="31">1. NSUserDefault能够存储哪些类型的数据？可以存储可变数据类型吗？可以存储自定义数据类型吗？</h2>

### （1）可存储的数据类型

* NSNumber（NSInteger、float、double、bool）
* NSString
* NSDate
* NSData
* NSArray
* NSDictionary

### （2）可以，但是取出来是不可变类型
可以将可变数据类型存入，但是取出来的时候，数据类型会变成不可变。

### （3）不可以
自定义数据类型，需要先转成NSData类型才能存储。

<h2 id="32">2. NSUserDefault是如何存取的？它将数据存在何处？</h2>

### （1）存取方式
```objc
//存
[[NSUserDefaults standardUserDefaults] setObject:@"value" forKey:@"key"];
```

```objc
//取
[[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
```

```objc
//强行同步数据
[[NSUserDefaults standardUserDefaults] synchronize];
```
其他类型数据类似。

### （2）存储位置
沙盒下`AppData/Library/Preferences/Bundle Identifier.plist`

<h2 id="33">3. NSUserDefault是如何读取数据的？</h2>

<h2 id="34">4. NSUserDefault是如何存储数据且保持数据一致性的？</h2>



