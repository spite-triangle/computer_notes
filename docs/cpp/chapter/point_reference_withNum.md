
 <h1 style="font-size:60px;text-align:center;">指针与引用</h1>

# 1. 指针与引用


| 类型 | 储存         | 初始化   | 二次赋值 | 形式     | sizeof     |
| ---- | ------------ | -------- | -------- | -------- | ---------- |
| 指针 | 有储存空间   | NULL     | 可以     | `类名 *` | 指针的大小 |
| 引用 | 无空间，别名 | 不能为空 | 不行     | `类名 &` | 类型的大小 |


> [!note|style:flat]
> - `c`语言没有引用机制，是靠`c++`扩展实现。


# 2. 引用

## 2.1. 引用的初始化

> [!note|style:flat]
> **引用的创建不会调用类的拷贝构造函数**

### 2.1.1. 函数变量

**直接在定义变量的时候初始化：**

```cpp
int b = 1;
int & a = b;
```

### 2.1.2. 类变量初始

> [!note|style:flat]
> **使用「初始化列表」进行初始化。**

```cpp
class Test{
public:
    int & a;

    Test(int &a) : a(a) {

    } 

};
```

## 2.2. `const`引用
### 2.2.1. 概念介绍

> [!tip]
> - **`const int & d2 = d1` 对于`d2`只是`d1`的别名；名义上`d2`并没有分配，内存地址与`d1`一摸一样；**
> - <span style="color:red;font-weight:bold"> 「`d2`的值」并没有被放到「符号表」；`d1`修改后，`d2`的值也更着改变 </span>

```cpp
int d1 = 4;
const int & d2 = d1;
d1 = 5; // 此时，d2的值也是：5
```
### 2.2.2. 常量引用

> [!tip|style:flat]
> <span style="color:blue;font-weight:bold"> 常量具有常性，只有`const`引用可以引用常量 </span>

```cpp
const int & d1 = 5;
```

### 2.2.3. 隐蔽类型转换的引用

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> `d1`是`double`类型，`d2`是`int`，`d1`赋值给 `d2`时，要先生成一个「带常性的临时变量」，然后用临时变量进行赋值，所以`int& d2 = d1;`错误。 </span>


```cpp
double d1 = 1.1；

// 错误
int& d2 = d1; 

// 正确
const int& d3 = d2;
```
## 2.3. 引用返回

1. 不能返回局部变量的引用
2. 不能返回函数内部`new`分配的内存的引用，利用引用返回，就没法释放内存了。

# 3. 智能指针

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

# 4. 野指针
&emsp;&emsp;**野指针不是NULL指针，是未初始化或者未清零的指针，在程序中乱指。**

- 指针变量没有被初始化
- 指针指向的内存被释放了，但是指针没有置NULL 
- 指针越界

# 5. 指针与数组

## 5.1. 关系
   
| 类型  | 二次修改 | 参与运算 |      sizeof()      |
| :---: | :------: | :------: | :----------------: |
| 指针  |   可以   |   可以   |   **指针的字节**   |
| 数组  |   不行   |   可以   | **声明空间的字节** |

## 5.2. 数组

> [!note|style:flat]
> - **当定义了`char s[10];`时，`s`的真实类型应该为`char * const s;`，所以`s`不可修改。**
> - <span style="color:red;font-weight:bold"> 在「形参」中，使用`type name[] 与 type name[10]`的形式接收数组，都会退化为`type * name`的形式，即`name`是当作指针处理了。 </span>

## 5.3. 数组稀奇古怪的初始化方式

| 方式                         | 说明                                                                      | 注意                                       |
| ---------------------------- | ------------------------------------------------------------------------- | ------------------------------------------ |
| `int a[10];`                 | 局部变量：未初始化；<br> 全局变量：初始化为0；<br>`static`修饰：初始化为0 |                                            |
| `int a[10] = {0}`            | 肯定初始化为0。                                                           |                                            |
| `int a[10] = {1,2,4}`        | 前三个按照设置初始化，后面全是0                                           |                                            |
| `int a[10] = {1,2,4,}`       | 编译通过                                                                  | **只能多写一个`,` 凸(▔皿▔╬)**              |
| `int a[3] = {1,2,4,}`        | 编译通过                                                                  | **凸(▔皿▔╬)**                              |
| `int a[3] = {1,2,3,4}`       | 编译报错                                                                  | **`{}`写入的初始值个数不能大于数组声明值** |
| `const int N = 10;int n[N];` | 编译通过                                                                  | 非`const`的`N`编译不通过                   |
| `#define N 10; int n[N];`    | 编译通过                                                                  |                                            |

## 5.4. 字符数组长度的计算


```cpp
char str[20] = "fuck you";

// 计算字节数
sizeof(str);

// 计算字符串的长度
strlen(str);
```

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> `sizeof(类型)`的计算值实在编译时，进行计算。以下计算是正确的。 </span> 
> ```cpp
> int a[sizeof(int)];
> ```
