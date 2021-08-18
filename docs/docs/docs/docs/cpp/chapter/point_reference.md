
 <h1 style="font-size:60px;text-align:center;">指针与引用</h1>

# 1 指针与引用


   |      | 储存         | 初始化     | 二次赋值 | 形式   |
   | ---- | ------------ | ---------- | -------- | ------ |
   | 指针 | 有储存空间   | NULL       | 可以     | 类名 * |
   | 引用 | 无空间，别名 | 已有的对象 | 不行     | 类名 & |


> [!note|style:flat]
> <font color="#f44336" style="font-weight:bold">c语言没有引用机制，是靠c++扩展实现。</font>

# 2 对象与类

   |      | 描述                         | 储存                                                              |
   | ---- | ---------------------------- | ----------------------------------------------------------------- |
   | 类   | 模板，包括属性和行为         | 无                                                                |
   | 对象 | 类的实例化，主要是数据的集合 | 主要只储存了属性，储存位置看具体情况 ; 函数放代码段，所有对象通用 |

# 3 智能指针

&emsp;&emsp;通过库函数<memory>，管理对象指针。

-  ~~std::auto_ptr~~ : 废弃
- unique_ptr: 对象只能一个指针持有。
    ```cpp
     // 初始化赋值
     std::unique_ptr<int> p1(new int(5));
     // 移交所有权，p1将变无效
     std::unique_ptr<int> p2 = std::move(p1);
     // 滞后赋值
     unique_ptr<string> p3;
     p3 = unique_ptr<string>(new string ("You"));
    ```
- shared_ptr: 多个指针指向相同的对象。内部会有一个指向计数器，当计数器变为0时，系统就会对这个对象进行销毁，线程安全。
    ```cpp
    // make_shared生成
    std::shared_ptr<int> p1 = std::make_shared<int>(10);
    // 拷贝赋值
    std::shared_ptr<int> p2;
    p2 = p1;
    ```
- weak_ptr: <font color="#4c9df8">没有重载operator*和->，用于防止shared_ptr循环引用。</font>

# 4 野指针
&emsp;&emsp;**野指针不是NULL指针，是未初始化或者未清零的指针，在程序中乱指。**

- 指针变量没有被初始化
- 指针指向的内存被释放了，但是指针没有置NULL 
- 指针越界

# 5 指针与数组

   
|       | 二次修改 | 参与运算 |     sizeof     |
| :---: | :------: | :------: | :------------: |
| 指针  |   可以   |   可以   |   指针的字节   |
| 数组  |   不行   |   可以   | 声明空间的字节 |

