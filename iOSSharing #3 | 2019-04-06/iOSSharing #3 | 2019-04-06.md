# 目录
## [1、atomic关键字内部使用的是什么锁？](#21)
## [2、串行同步开几条线程？](#22)
## [3、串行异步开几条线程？](#23)
## [4、并发同步开几条线程？](#24)
## [5、并发异步开几条线程？](#25)

***

<h2 id="21">1、atomic关键字内部使用的是什么锁？</h2>
答：</br>

**首先了解一些基本概念:** 

* 临界区：指的是一块对公共资源进行访问的代码，并非一种机制或是算法。

* 自旋锁：是用于多线程同步的一种锁，线程反复检查锁变量是否可用。由于线程在这一过程中保持执行，因此是一种忙等待。一旦获取了自旋锁，线程会一直保持该锁，直至显式释放自旋锁。 自旋锁避免了进程上下文的调度开销，因此对于线程只会阻塞很短时间的场合是有效的。

* 互斥锁（Mutex）：是一种用于多线程编程中，防止两条线程同时对同一公共资源（比如全局变量）进行读写的机制。该目的通过将代码切片成一个一个的临界区而达成。

* 读写锁：是计算机程序的并发控制的一种同步机制，也称“共享-互斥锁”、多读者-单写者锁) 用于解决多线程对公共资源读写问题。读操作可并发重入，写操作是互斥的。 读写锁通常用互斥锁、条件变量、信号量实现。

* 信号量（semaphore）：是一种更高级的同步机制，互斥锁可以说是semaphore在仅取值0/1时的特例。信号量可以有更多的取值空间，用来实现更加复杂的同步，而不单单是线程间互斥。

* 条件锁：就是条件变量，当进程的某些资源要求不满足时就进入休眠，也就是锁住了。当资源被分配到了，条件锁打开，进程继续运行。

* 死锁：指两个或两个以上的进程在执行过程中，由于竞争资源或者由于彼此通信而造成的一种阻塞的现象，若无外力作用，它们都将无法推进下去，这些永远在互相等待的进程称为死锁进程。

* 轮询（Polling）：一种CPU决策如何提供周边设备服务的方式，又称“程控输出入”。轮询法的概念是，由CPU定时发出询问，依序询问每一个周边设备是否需要其服务，有即给予服务，服务结束后再问下一个周边，接着不断周而复始。

**锁的类型：**
* 互斥锁

    * NSLock
    * pthread_mutex
    * pthread_mutex(recursive)递归锁
    * @synchronized

* 自旋锁

    * OSSpinLock
    * os_unfair_lock

* 读写锁

    * pthread_rwlock

* 递归锁

    * NSRecursiveLock

    * pthread_mutex(recursive)（见上）

* 条件锁

    * NSCondition
    * NSConditionLock

* 信号量

    * dispatch_semaphore


![time](
https://i.loli.net/2019/04/04/5ca5a766b143c.png) 

```
//10000000
OSSpinLock:                 112.38 ms
dispatch_semaphore:         160.37 ms
os_unfair_lock:             208.87 ms
pthread_mutex:              302.07 ms
NSCondition:                320.11 ms
NSLock:                     331.80 ms
pthread_rwlock:             360.81 ms
pthread_mutex(recursive):   512.17 ms
NSRecursiveLock:            667.55 ms
NSConditionLock:            999.91 ms
@synchronized:             1654.92 ms

//1000
OSSpinLock:                   0.02 ms
dispatch_semaphore:           0.03 ms
os_unfair_lock:               0.04 ms
pthread_mutex:                0.06 ms
NSLock:                       0.06 ms
pthread_rwlock:               0.07 ms
NSCondition:                  0.07 ms
pthread_mutex(recursive):     0.09 ms
NSRecursiveLock:              0.12 ms
NSConditionLock:              0.18 ms
@synchronized:                0.33 ms
```


![atomic](
https://i.loli.net/2019/04/04/5ca5a77ed27d7.jpg)

atomic使用的是自旋锁，主要用于赋值操作等轻量操作（散列表，引用计数，弱引用指针赋值），而互斥锁一般都是锁线程，比如单例。
***
<h2 id="22">2、串行同步开几条线程？</h2>
答：

**首先了解一些基本概念:** 
* 同步：只能在**当前**线程中执行任务，**不具备**开启新线程的能力
* 异步：可以在**新的**线程中执行任务，**具备**开启新线程的能力
* 串行：一个任务执行完毕后，再执行下一个任务
* 并发：多个任务并发（同时）执行

![](https://i.loli.net/2019/04/04/5ca5a36b7307e.png)
![](https://i.loli.net/2019/04/04/5ca5a36b84774.png)

![](https://i.loli.net/2019/04/04/5ca5a561c538a.jpeg)

不开新线程
***
<h2 id="23">3、串行异步开几条线程？</h2>
答：
开启一条新线程

***
<h2 id="24">4、并发同步开几条线程？</h2>
答：
不开新线程

***
<h2 id="25">5、并发异步开几条线程？</h2>
答：
开启多条

***

## 联系方式
**邮箱：** xiebangyao_1994@163.com
**邮箱：** holaux@gmail.com</br>
**相关账号：**
* [掘金 - Adrenine](https://juejin.im/user/57c39bfb79bc440063e5ad44)
* [简书 - Adrenine](https://www.jianshu.com/u/b20be2dcb0c3)
* [Blog - Adrenine](https://adrenine.github.io/)
* [Github - Adrenine](https://github.com/Adrenine)
 
**联合编辑：**
* [掘金 - oneofai](https://juejin.im/user/596490e6f265da6c306535c4)
* [Blog - oneofai](https://oneofai.github.io/)
* [Github - oneofai](https://github.com/oneofai)
</br>
* [Github - ledah217](https://github.com/ledah217)