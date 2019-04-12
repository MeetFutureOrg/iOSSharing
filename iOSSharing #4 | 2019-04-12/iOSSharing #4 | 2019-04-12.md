# 目录
## [1、请用一句话概述分类的概念，并阐述分类的优点。](#21)
## [2、多个同宿主分类中的都重写了一个同名方法，哪个分类的同名方法会生效？为什么？](#22)
## [3、@property(copy)NSMutableArray *array这样声明属性会出现什么问题？](#23)
## [4、说一说KVO在重写NSKVONotifying对象的setter方法中，添加了哪两个关键方法？](#24)
## [5、如何实现一个完整的单例？](#25)

***
<h2 id="21">1、请用一句话概述分类的概念，并阐述分类的优点。</h2>
答：
概述
* Objective-C中的分类是修饰模式的一种具体实现，主要作用是在不改变原有类的基础上，动态的为类扩展功能（添加方法）。

分类的优点
* 声明私有方法
* 分解庞大的类文件
* 将Framework私有方法公开化
* 模拟多继承
***
<h2 id="21">2、多个同宿主分类中的都重写了一个同名方法，哪个分类的同名方法会生效？为什么？</h2>
答：
运行时在处理分类时会倒序遍历分类数组，最先访问最后编译的类，最后编译的类的同名方法最终生效。
下面我们来看看源码解析：
```objc
int mcount = 0; // 记录方法的数量
int propcount = 0; // 记录属性的数量
int protocount = 0; // 记录协议的数量
int i = cats->count; // 获取分类个数
bool fromBundle = NO; // 记录是否是从 bundle 中取的
while (i--) { // 从后往前遍历,保证先取最后编译的类
    auto&; entry = cats->list[i]; // 分类,locstamped_category_t 类型
    
    // 取出分类中的方法列表;如果是元类,取得的是类方法列表;否则取得的是实例方法列表
    method_list_t *mlist = entry.cat->methodsForMeta(isMeta);
    if (mlist) {
        mlists[mcount++] = mlist; // 将方法列表放入 mlists 方法列表数组中
        fromBundle |= entry.hi->isBundle(); // 分类的头部信息中存储了是否是 bundle,将其记住
    }
    // 取出分类中的属性列表,如果是元类,取得是nil
    property_list_t *proplist = entry.cat->propertiesForMeta(isMeta);
    if (proplist) {
        proplists[propcount++] = proplist; // 将属性列表放入 proplists 属性列表数组中
    }
// 取出分类中遵循的协议列表
    protocol_list_t *protolist = entry.cat->protocols;
    if (protolist) {
        protolists[protocount++] = protolist; // 将协议列表放入 protolists 协议列表数组中
    }
} 
```
***
<h2 id="21">3、@property(copy)NSMutableArray *array这样声明属性会出现什么问题？</h2>
答：
NSMutableArray经过copy修饰后是NSArray（不可变数组）。
如果对经copy修饰后的可变数组进行增删改的操作，实际上是在操作不可变数组，从而会引起程序异常，引起Crash。
***
<h2 id="21">4、说一说KVO在重写NSKVONotifying对象的setter方法中，添加了哪两个关键方法？</h2>
答：
```objc
-(void)willChangeValueForKey:(NSString *)key;
-(void)didChangeValueForKey:(NSString *)key;
```
***
<h2 id="21">5、如何实现一个完整的单例？</h2>
答：
```objc
#import "SingletonSample.h"

@interface SingletonSample()<NSCopying>

@end

@implementation SingletonSample
+(instancetype)sharedInstance
{
    static SingletonSample *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end

```
***

## 联系方式
**邮箱：** adrenine@163.com</br>
* [掘金 - Adrenine](https://juejin.im/user/57c39bfb79bc440063e5ad44)
* [简书 - Adrenine](https://www.jianshu.com/u/b20be2dcb0c3)
* [Blog - Adrenine](https://adrenine.github.io/)
* [Github - Adrenine](https://github.com/Adrenine)
 
**邮箱：** holaux@gmail.com</br>
* [掘金 - oneofai](https://juejin.im/user/596490e6f265da6c306535c4)
* [Blog - oneofai](https://oneofai.github.io/)
* [Github - oneofai](https://github.com/oneofai)

**邮箱：** ledahapple@icloud.com</br>
* [Github - ledah217](https://github.com/ledah217)
* [Notion - 217](https://www.notion.so/217)