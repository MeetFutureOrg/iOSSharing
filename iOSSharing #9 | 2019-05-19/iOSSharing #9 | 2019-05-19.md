# 目录

## [1. setNeedsLayout、layoutIfNeeded与layoutSubviews区别？](#31)
## [2. UIView与CALayer的区别？](#32)
## [3. loadView什么时候被调用？它有什么作用？默认实现是怎么样的？](#33)
## [4. UIViewController的完整生命周期？](#34)
## [5. UIView动画支持的属性有哪些？](#35)


<h2 id="31">1. setNeedsLayout、layoutIfNeeded与layoutSubviews区别？</h2>

### (1)、setNeedsLayout

用于更新视图以及其子视图布局，不会立即更新，是一个异步方法，需要在主线程调用。该方法将视图以及其子视图标记，在下一个更新周期执行更新操作，不知道具体更新时间。

关于`setNeedsLayout`，官方文档描述如下：
> Call this method on your application’s main thread when you want to adjust the layout of a view’s subviews. This method makes a note of the request and returns immediately. Because this method does not force an immediate update, but instead waits for the next update cycle, you can use it to invalidate the layout of multiple views before any of those views are updated. This behavior allows you to consolidate all of your layout updates to one update cycle, which is usually better for performance.

### (2)、layoutIfNeeded
用于更新视图以及其子视图布局，立即更新，不会等待更新周期，从根视图开始更新视图子树，若无待更新的布局，直接退出。

关于`layoutIfNeeded`，官方文档描述如下：
> Use this method to force the view to update its layout immediately. When using Auto Layout, the layout engine updates the position of views as needed to satisfy changes in constraints. Using the view that receives the message as the root view, this method lays out the view subtree starting at the root. If no layout updates are pending, this method exits without modifying the layout or calling any layout-related callbacks.

### (3)、layoutSubviews

一般是在`autoresizing`或者 `constraint-based`的情况下重写此方法。常用场景是当视图不是使用frame初始化的时候，我们可以在此方法进行一些精细化布局。如子视图相对于父视图使用约束布局，子视图init时，不具有frame直到约束建立，因为不知道约束建立完成时机，而我们又确实需要frame进行一些计算，为确保计算时拿到的frame不为空，此时，我们可以将计算的过程放于此，并配合`setNeedsLayout`或者`layoutIfNeeded`进行视图刷新。

关于`layoutSubviews`，官方文档描述如下：

> Subclasses can override this method as needed to perform more precise layout of their subviews. You should override this method only if the autoresizing and constraint-based behaviors of the subviews do not offer the behavior you want. You can use your implementation to set the frame rectangles of your subviews directly.

> You should not call this method directly. If you want to force a layout update, call the setNeedsLayout method instead to do so prior to the next drawing update. If you want to update the layout of your views immediately, call the layoutIfNeeded method.

<h2 id="32">2. UIView与CALayer的区别？</h2>

* UIView可以响应事件，CALayer不可以响应事件
* 一个 Layer 的 frame 是由它的 anchorPoint,position,bounds,和 transform 共同决定的，而一个 View 的 frame 只是简单的返回 Layer的 frame
* UIView主要是对显示内容的管理而 CALayer 主要侧重显示内容的绘制
* 在做 iOS 动画的时候，修改非 RootLayer的属性（譬如位置、背景色等）会默认产生隐式动画，而修改UIView则不会。


<h2 id="33">3. loadView什么时候被调用？它有什么作用？默认实现是怎么样的？</h2>

### 1）、什么时候被调用？
每次访问UIViewController的view(比如controller.view、self.view)而且view为nil，loadView方法就会被调用。
### 2）、有什么作用？
loadView方法是用来负责创建UIViewController的view
### 3）、默认实现是怎样的？
默认实现即`[super loadView]`里面做了什么事情。
#### a)、 它会先去查找与UIViewController相关联的xib文件，通过加载xib文件来创建UIViewController的view
* 如果在初始化UIViewController指定了xib文件名，就会根据传入的xib文件名加载对应的xib文件
```objc
[[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
```
* 如果没有明显地传xib文件名，就会加载跟UIViewController同名的xib文件
```objc
[[MyViewController alloc] init]; // 加载MyViewController.xib
```
#### b) 、如果没有找到相关联的xib文件，就会创建一个空白的UIView，然后赋值给UIViewController的view属性，大致如下
```objc
self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];

```
`[super loadView]`里面就大致完成a)和b)中叙述的内容

**Tips:**</br>
若要自己重写`loadView`方法，此时为节省开销，应避免调用`[super loadView]`方法。


<h2 id="34">4. UIViewController的完整生命周期？</h2>

按照执行顺序排列：
* `init`初始化ViewController
* `loadView`当view需要被展示而它却是nil时，viewController会调用该方法。如果代码维护View的话需要重写此方法，使用xib维护View的话不用重写。
* `viewDidLoad`执行完loadView后继续执行viewDidLoad，loadView时还没有view，而viewDidLoad时view已经创建好了。
* `viewWillAppear`视图将出现在屏幕之前，马上这个视图就会被展现在屏幕上了;
* `viewDidAppear`视图已在屏幕上渲染完成 当一个视图被移除屏幕并且销毁的时候的执行顺序，这个顺序差不多和上面的相反;
* `viewWillDisappear`视图将被从屏幕上移除之前执行
* `viewDidDisappear`视图已经被从屏幕上移除，用户看不到这个视图了
* `viewWillUnload`如果当前有能被释放的view，系统会调用viewWillUnload方法来释放view
* `viewDidUnload`当系统内存吃紧的时候会调用该方法，在iOS 3.0之前didReceiveMemoryWarning是释放无用内存的唯一方式，但是iOS 3.0及以后viewDidUnload方法是更好的方式。在该方法中将所有IBOutlet（无论是property还是实例变量）置为nil（系统release view时已经将其release掉了）。在该方法中释放其他与view有关的对象、其他在运行时创建（但非系统必须）的对象、在viewDidLoad中被创建的对象、缓存数据等。一般认为viewDidUnload是viewDidLoad的镜像，因为当view被重新请求时，viewDidLoad还会重新被执行。
* `dealloc`视图被销毁，此处需要对你在init和viewDidLoad中创建的对象进行释放.关于viewDidUnload ：在发生内存警告的时候如果本视图不是当前屏幕上正在显示的视图的话，viewDidUnload将会被执行，本视图的所有子视图将被销毁以释放内存,此时开发者需要手动对viewLoad、viewDidLoad中创建的对象释放内存。因为当这个视图再次显示在屏幕上的时候，viewLoad、viewDidLoad 再次被调用，以便再次构造视图。


<h2 id="35">5. UIView动画支持的属性有哪些？</h2>

* frame: 位置和大小
* bounds
* center
* transform
* alpha
* backgroundColor
* contentStretch

基本用法：
```objc
+ (void)animateWithDuration:(NSTimeInterval)duration 
                      delay:(NSTimeInterval)delay 
                    options:(UIViewAnimationOptions)options 
                 animations:(void (^)(void))animations 
                 completion:(void (^)(BOOL finished))completion;
```
参数说明：

* duration ：整个动画持续的时间
* delay：动画在多久之后开始，值为 0 表示代码执行到这里后动画立刻开始
* options：一些有关动画的设置，例如想要动画刚开始比较快，到快结束时比较慢，都在这里设置。
* animations：在这个 block 中写入你想要执行的代码即可。block 中对视图的动画属性所做的改变都会生成动画
* completion：动画完成后会调用，finished 表示动画是否成功执行完毕。可以将动画执行完成后需要执行的代码写在这里



