# 本期为 NSUserDefaults 内容

# 目录

## [1. NSUserDefaults 能够存储哪些类型的数据？可以存储可变数据类型吗？可以存储自定义数据类型吗？](#31)
## [2. NSUserDefaults 存取操作是什么？它将数据存在何处？并且它是如何保持数据一致性的?](#32)
## [3. NSUserDefaults 旧数据总能被新设置的替换吗？](#33)
## [4. NSUserDefaults 性能如何?](#34)
## [5. NSUserDefaults 没有存储 key 的时候默认返回什么？有什么方法区分没有 key 的情况？](#35)


<h2 id="31">1. NSUserDefaults 能够存储哪些类型的数据？可以存储可变数据类型吗？可以存储自定义数据类型吗？</h2>

### （1）可存储的数据类型

* NSNumber（NSInteger、float、double、bool）
* NSString
* NSDate
* NSData
* NSArray
* NSDictionary

### （2）可以，但是取出来是不可变类型
可以将可变数据类型存入，但是取出来的时候，数据类型会变成不可变

### （3）不可以
自定义数据类型, 例如自定义模型, 需要先转成 `NSData` 类型才能存储

<h2 id="32">2. NSUserDefaults 存取操作是什么？它将数据存在何处？并且它是如何保持数据一致性的? </h2>

### （1）存取方式
```objc
//存
[[NSUserDefaults standardUserDefaults] setObject:value forKey:@"key"];
```

```objc
//取
id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
```

```objc
//强制同步数据
[[NSUserDefaults standardUserDefaults] synchronize];
```

关于 `NSUserDefaults`, 官方文档有这么一段话: 
> At runtime, you use NSUserDefaults objects to read the defaults that your app uses from a user’s defaults database. NSUserDefaults caches the information to avoid having to open the user’s defaults database each time you need a default value. When you set a default value, it’s changed synchronously within your process, and asynchronously to persistent storage and other processes.

NSUserDefaults 会将访问到的 key 和 value 缓存到内存中, 下次访问时, 如果缓存中命中这个 key, 就直接访问, 如果没有命中, 再从文件中载入, 会时不时调用 `synchronize` 来保证数据的一致性, 但是这个操作非实时的, 为了防止数据丢失, 我们应该在对重要的数据保存时使用`synchornize`方法强制写入, 但也不要过于频繁, 毕竟频繁访问数据库影响性能


### （2）存储位置

```shell
// 沙盒下
AppData/Library/Preferences/Bundle\ Identifier.plist
```

<h2 id="33">3. NSUserDefaults 旧数据总能被新设置的替换吗？</h2>
并不一定, 在使用 `registerDefaults` 来注册默认时, 旧值不一定被替换

官方注释:

> adds the registrationDictionary to the last item in every search list. This means that after NSUserDefaults has looked for a value in every other valid location, it will look in registered defaults, making them useful as a "fallback" value. Registered defaults are never stored between runs of an application, and are visible only to the application that registers them. Default values from Defaults Configuration Files will automatically be registered.

大致是说, 当应用内没有这个值时, 这个值将作为默认值存在, 如果这个 key 已经存在, 那么这个值将作为备用, 并且当 app 再次启动, 这个默认值并不会替换已经存在的值, 我们用几行代码来说明
1. 首先
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys: @"blue", @"color", nil];   
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];  
   
    return YES;
}  
```

2. 当 app 第一次 run 时, NSUserDefaults 会把 @"color" = @"blue" 写入 plist 中, 然后比如在 app 内调用了
```objc
[[NSUserDefaults standardUserDefaults] setObject:@"red" forKey:@"color"];  
```
这时 NSUserDefaults 里 @"color" = @"red"

3. 退出 app, 杀掉后台, 第1步里的 `registerDefaults` 还是会被调用, 但它会查到 @"color" key 已存在, 并不会把 @"blue" 写进去
4. 将 `registerDefaults` 修改为
```objc
NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys: @"black", @"color",@"tomson", @"username",nil];   
[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues]; 
```
这时, NSUserDefaults 内 @"color" 依然为 @"red", 但多了 @"username" = @"tomson"

<h2 id="34">4. NSUserDefaults 性能如何? </h2>

从性能上分析, 缓存的机制带来了一定的性能提升, 通过一些网上的文章了解到在10万个key的情况下, 通过`NSUserDefaults`来读取value是1ms级别的, 然而当你从plist文件中直接读取, 需要100ms的级别开销, 但是写是个相反的结果, 要是你写1个10万条数据到plist文件中是1s级别的开销，而同时写入10万条`NSUserDefaults`键值对则需要10s级别的延迟. 我们都知道在创建key/value时, 程序需要在内存中也创建一个相应的映射关系, 然后系统会时不时调用`synchronsize`方法同步数据, 很多的方法会导致创建key/value pair被阻塞

总的来说, 使用`NSUserDefaults`是比较高效的, 但是不能大量的将数据通过 NSUserDefaults 中
<h2 id="35">NSUserDefaults 没有存储 key 的时候默认返回什么？有什么方法区分没有 key 的情况？</h2>

在 Key 不存在时, 默认返回 `nil`, 区分的方法就是判断是否为空啦
