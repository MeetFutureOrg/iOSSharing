# 目录
## [1、类方法去哪里找？](#21)
## [2、isa指针有几种类型么？](#22)
## [3、分类的方法具体是在什么时候添加到类的方法列表中？](#23)
## [4、class_addMethod()都需要什么参数?](#24)
## [5、iOS消息转发流程](#25)


***

<h2 id="21">1、类方法去哪里找？</h2>
答：
见上一期《iOS Sharing #01 | 2019-03-23》第5问

[5、实例方法去哪里找？](https://juejin.im/post/5c94ad73f265da60c833e86d)

***
<h2 id="22">2、isa指针有几种类型么？</h2>
答：
isa指针分，指针类型和非指针类型，32位只做地址保存，非嵌入式64位架构下，包含除类地址外的其他信息。

![isa指针类型](https://user-gold-cdn.xitu.io/2019/3/28/169c2dfbc688be64?w=1686&h=1072&f=jpeg&s=85856)

***
<h2 id="23">3、分类的方法具体是在什么时候添加到类的方法列表中？</h2>
答：
类在编译后会以 class_ro_t 的结构把类的信息存储在 bits 里，运行时的 realizeClass 之后，会把 ro 中的所有信息拷贝到 bits 的 data 内，即以 class_rw_t 的形式存在，分类里的方法即在这个时候添加到类的方法表里，并在方法表数组的最前面



***

<h2 id="24">4、class_addMethod()都需要什么参数?</h2>
答：

```objc
/**
* Adds a new method to a class with a given name and implementation.
*
* @param cls The class to which to add a method.
* @param name A selector that specifies the name of the method being added.
* @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
* @param types An array of characters that describe the types of the arguments to the method.
*
* @return YES if the method was added successfully, otherwise NO
* (for example, the class already contains a method implementation with that name).
*
* @note class_addMethod will add an override of a superclass's implementation,
* but will not replace an existing implementation in this class.
* To change an existing implementation, use method_setImplementation.
*/
OBJC_EXPORT BOOL class_addMethod(Class cls, SEL name, IMP imp,
const char *types)
__OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);

```

* 给类添加一个新的方法和该方法的具体实现
* BOOL: 返回值，YES -------方法添加成功 NO --------方法添加失败
* Class cls: 将要给添加方法的类，传的类型 ［类名 class］
* SEL name: 将要添加的方法名，传的类型  @selector(方法名)
* IMP imp：实现这个方法的函数 ，传的类型  
    * 1、C语言写法：（IMP）方法名 
    * 2、OC的写法：class_getMethodImplementation(self,@selector(方法名：))
* const char *types：表示我们要添加的方法的返回值和参数
* "v@:@"：
    * 'v'是添加方法无返回值   
    * '@'表示是id(也就是要添加的类) 
    * '：'表示添加的方法类型  
    * '@'表示参数类型

const char *types含义表：
Code | Meaning
- | :-: | -: 
c | A char
i | An int
s | A short
l | A long l is treated as a 32-bit quantity on 64-bit programs.
q | A long long
C | An unsigned char
I | An unsigned int
S | An unsigned short
L | An unsigned long
Q | An unsigned long long
f | A float
d | A double
B | A C++ bool or a C99 _Bool
v | A void
* | A character string (char *)
@ | An object (whether statically typed or typed id)
# | A class object (Class)
: | A method selector (SEL)
[array type] | An array
{name=type...} | A structure
(name=type...) | A union
bnum | A bit field of num bits
^type | A pointer to type
? | An unknown type (among other things, this code is used for function pointers)

**注意：**</br>
用这个方法添加的方法是无法直接调用的，必须用performSelector：调用。
因为performSelector是运行时系统负责去找方法的，在编译时候不做任何校验；如果直接调用编译是会自动校验。
添加方法是在运行时添加的，你在编译的时候还没有这个本类方法，所以当然不行。

***

<h2 id="25">5、iOS消息转发流程</h2>
答：</br>
消息转发机制基本分为三个步骤：</br>

* 1、动态方法解析
* 2、备用接受者
* 3、完整转发

[代码](https://github.com/Adrenine/ForwardInvocation)

![](https://user-gold-cdn.xitu.io/2019/3/28/169c2f8e872c748b?w=780&h=408&f=png&s=37142)

类方法：
![类方法](https://user-gold-cdn.xitu.io/2019/3/28/169c2fb8e0754da2?w=822&h=1036&f=png&s=134393)

实例方法：
![实例方法](https://user-gold-cdn.xitu.io/2019/3/28/169c2fbff0f91b68?w=856&h=1384&f=png&s=202132)

详细流程：
![详细流程](https://i.loli.net/2019/03/29/5c9dcfbd2b74c.jpg)

感谢大佬提供的图片。
***

## 联系方式
**邮箱：** xiebangyao_1994@163.com</br>
**相关账号：**
* [掘金 - Adrenine](https://juejin.im/user/57c39bfb79bc440063e5ad44)
* [简书 - Adrenine](https://www.jianshu.com/u/b20be2dcb0c3)
* [Blog - Adrenine](https://adrenine.github.io/)
* [Github - Adrenine](https://github.com/Adrenine)

**联合编辑：**
* [掘金 - oneofai](https://juejin.im/user/596490e6f265da6c306535c4)
* [Blog - oneofai](https://oneofai.github.io/)
* [Github - oneofai](https://github.com/oneofai)