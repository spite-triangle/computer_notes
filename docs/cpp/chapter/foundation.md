
<h1 style="font-size:60px;text-align:center;">基础知识</h1>

# c语言文件

头文件后缀名： .h

源文件后缀名： .c

# c++文件

头文件后缀名： .h, .hpp, .hxx

源文件后缀名：.cpp, .cc, .cxx, .C .c++

.hpp: 声明和实现都有

.inl: 内联函数

# 内联函数

&emsp;&emsp;使用inline修饰的<font color="#4c9df8">具体函数实现，非声明</font>。<font color="#f44336">编译期间</font>对于编译器承认的inline函数，将会直接把代码拷贝到函数调用位置。

- 建议性质的关键字，只有简单的函数会被编译器承认。
- 默认地，类中定义的所有函数，除了**虚函数**之外，会隐式地或自动地当成内联函数; **虚函数也能用inline修饰，建议性质的。**
- 泛型定义

# c与c++区别

- `C`是面向过程的语言，`C++`是面向对象的语言
- `C++`中`new`和`delete`是对内存分配的运算符，取代了`C`中的库函数`malloc`和`free`
- `C++`中有引用的概念，`C`中没有
- `C++`引入了类的概念，`C`中没有
- `C++`有函数重载，`C`没有，但是有「标准库函数的重定向」
- `C`变量只能在函数的开头处声明和定义「旧版编译器」；而`C++`随时定义随时使用

## `int f()` 与 `int f(void)` 区别

**`c`语言：**
- `int f()` : 表示返回值为`int`，接受任意参数的函数
- `int f(void)`: 表示返回值为`int`的无参函数

**`c++`中：**

- `int f()`和 `int f(void)`：都表示返回值为`int`的无参函数

## 三目运算

```cpp
int a = 1;
int b = 2;
(a<b ? a : b) = 3;
(a<b ? 1 : b) = 3;  //错误
```

- `c`语言：三目运算不能作为左值
- `c++`：三目运算符可直接返回变量本身，既可作为右值使用，又可作为左值使用
  - **注意**：三目运算符可能返回的之中如果有一个是常量值，则不能作为左值

# 重定义
&emsp;&emsp; **`#include`会将头文件复制，同一个东西头文件实现一次，源文件实现一次就会触发重定义。** 


## 结构体

<span style="font-size:24px;font-weight:bold" class="section2">1. c</span>

```cpp
#include <stdio.h>
struct Test
{
    int a;
    int b;
    const int c;
    void (*fcn)();
};

int main(int argc, char const *argv[])
{
    struct Test t = {1,2,3};
    printf("%d\n",t.c);
    return 0;
}
```

<span style="font-size:24px;font-weight:bold" class="section2">2. c++</span>

```cpp
#include <stdio.h>

struct Test
{
private:
    int a;
public:
    int b;
    const int c;
    static int d;

    Test(int a,int b,int c)
    :c(c)
    {
        this->a = a;
        this->b = b;
    }

    virtual void fcn(){
        printf("parent \n");
    }

    ~Test(){

    }
};

int Test::d = 1;

struct Son:public Test{
    Son(int a,int b,int c)
    : Test(a,b,c)
    {

    }

    virtual void fcn(){
        printf("son \n");
    }
};

int main(int argc, char const *argv[])
{
    Son s(1,2,3);
    Test& t = s;
    t.fcn();
    printf("b: %d c: %d d: %d\n",s.b,s.c,s.d);
    return 0;
}

```

<span style="font-size:24px;font-weight:bold" class="section2">3. 对比总结</span>

| 项目              | `c`                    | `c++`          |
| ----------------- | ---------------------- | -------------- |
| `const`变量       | 可以                   | 可以           |
| `const`变量初始化 | 定义变量时`{,,}`初始化 | 初始化参数列表 |
| `static` 变量     | 不行                   | 可以           |
| 函数定义          | 函数指针               | 直接定义       |
| 结构体声明        | `struct 名字 变量;`    | `名字 变量;`   |
| 访问权限          | 没有                   | 有             |
| 构造、析构函数    | 没有                   | 有             |
| 继承              | 没有                   | 有             |
| 多态              | 没有                   | 有             |


<span style="font-size:24px;font-weight:bold" class="section2">4. 恶心追加</span>


```cpp

#include <stdio.h>

struct Test{
};

class A{
};

int main(int argc, char const *argv[])
{
    printf("c++ struct: %d, c++ class %d \n", sizeof(Test), sizeof(A));
    return 0;
}
```

```c
#include <stdio.h>

struct Test
{
};

int main(int argc, char const *argv[])
{
    printf("%d\n",sizeof(struct Test));
    return 0;
}
```

> [!note|style:flat]
> - **c++: 空结构体与空类的`sizeof`为`1`。**
> - **c: 空结构体的`sizeof`为`0`**
> - `C++`标准规定类的大小不为`0`，空类的大小为`1`，当类不包含虚函数和非静态数据成员时，其对象大小也为`1`


# `main`函数

-  `int argc` : 传入参数个数，**默认为1**
-  `const char * argv[]` : 输入的参数列表
    - **一个字符串数组**
    -  `argv[0]` : 被执行程序（.exe文件）所在的绝对路径。


# 编译器

gcc与g++进行文件编译时，会互相调用，**但是编译.c文件除外**；**在链接时，不会互相调用。**
- **预处理**: `-E`，处理宏
- **编译**:`-S`，生成汇编
- **汇编**:`-C`，生成二进制
- **链接**:`-O`，生成目标文件
 
# 动态链接与静态链接

<span style="font-size:24px;font-weight:bold" class="section2">1. 对比</span>

- **静态链接**
    - 在编译链接时，直接将需要的执行代码拷贝到调用处
    - 程序发布的时候就不需要依赖库，但是体积可能会相对大一些。
- **动态链接**
    - 在编译时，不直接拷贝可执行代码，而记录一系列符号和参数，在程序运行或加载时将这些信息传递给操作系统，操作系统负责将需要的动态库加载到内存中，然后程序在运行到指定的代码时，去共享执行内存中已经加载的动态库可执行代码，最终达到运行时连接的目的。
    - 多个程序可以共享同一段代码，而不需要在磁盘上存储多个拷贝
    - 运行时加载，可能会影响程序的前期执行性能
    - 发布程序时，要把动态库也一起带上

<span style="font-size:24px;font-weight:bold" class="section2">2. 静态链接库</span>

<!--sec data-title="案例代码" data-id="example_lib" data-show=true data-collapse=true ces-->

`math.h`

```cpp
#ifndef __MATH_H__
#define __MATH_H__

extern int add(int a,int b);

#endif // __MATH_H__
```
`math.cpp`
```cpp
int add(int a,int b){
    return a + b;
}
```
`main.cpp`
```cpp
#include <stdio.h>
#include "math.h"

int main(int argc, char const *argv[])
{
    printf("%d \n",add(10,11));    
    return 0;
}
```
<!--endsec-->

```term
triangle@LEARN_FUCK:~$ gcc -c math.cpp # 生成 .o 文件
triangle@LEARN_FUCK:~$ ar rcs libmath.a math.o  # 打包生成静态库
triangle@LEARN_FUCK:~$ gcc main.cpp -L. -lmath # 使用静态库
triangle@LEARN_FUCK:~$ ./a.out
21
```

> [!note|style:flat]
> **`-lmath`：对于库的名字，不要加 `lib` 和 `.a`**

<span style="font-size:24px;font-weight:bold" class="section2">3. 动态库</span>

```term
triangle@LEARN_FUCK:~$ gcc -fPIC -c math.cpp # -fPIC 表示生成与路径无关的代码
triangle@LEARN_FUCK:~$ gcc -shared -o libmath.so math.o # 生成动态库
triangle@LEARN_FUCK:~$ gcc main.cpp -L. -lmath # 使用动态库
triangle@LEARN_FUCK:~$ export LD_LIBRARY_PATH=$(pwd) # 添加动态库查找位置
triangle@LEARN_FUCK:~$ ./a.out
21
```

# 定义与声明
- **定义**：表示创建变量或分配存储单元
    - **定义必须有，且只能出现一次**

- **声明**：说明变量的性质，但并不分配存储单元;在 **链接** 时，查找具体定义。
    - **声明可以出现多次**

- **变量：**
    ```cpp
    // 声明
    extern int i;

    // 声明了未定义，但是不能重复声明
    class Test{
    public:
        static int a;
    };

    // 定义
    int Test::a = 0;

    // 声明又定义
    int i;
    int i = 1;
    extern int i = 1; // 函数外部才能被初始化
    ```
    <font color="#f44336" style="font-weight:bold">源文件中的全局变量 `int a;` 形式，默认修饰符为 `extern`。</font>
- **函数**: 带有`{ }`的就是定义，否则就是声明。

# 模块化设计

1.  模块即是一个`.c`文件和一个`.h`文件的结合，**头文件(.h)中是对于该模块接口的声明，一般都用extern进行修饰**；
2.  供给其它模块调用的外部函数及全局变量需在`.h`中文件中冠以`extern`关键字声明；
3. 模块内的函数和全局变量需在`.c`文件开头冠以`static`关键字声明；
4. <font color="#f44336" style="font-weight:bold">永远不要在.h文件中定义全局变量！</font>
5. 头文件中可以定义的实体，<font color="#f44336" style="font-weight:bold">得有头文件保护，否则会重定义。</font>
    - 值在编译时就已知的 `const` 变量的定义可以放到头文件中
    - 结构体，类的定义可以放到头文件中
    - `inline` 函数

# 泛型

- **`template<typename T,class A>`: `typename , class`作用一样。**
- <span style="color:red;font-weight:bold"> 泛型的定义和实现必须在同一个文件中。 </span>

```cpp
class Car{
public:
    // 类型别名
    typedef float Speed;
    // 内部类
    class Wheel{
    };
    static float price;
};

float Car::price = 10;

// 定义泛型
template<typename T>
class PrivateCar{
public:
    // 定义变量
    typename T::Speed v;
    typename T::Wheel wheels;

    float getPrice(){
        T::price = 100;
        // 变量
        return T::price; 
    }
};
```

# 类型安全

**类型安全:指同一段内存在不同的地方，会被强制要求使用相同的描述来解释(内存中的数据是用类型来解释的)，除非使用类型强制转换。**

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> `c/c++` 并不是类型安全的语言。</span>

<!--sec data-title="案例" data-id="example_typeSafe" data-show=true data-collapse=true ces-->
```cpp
int main()
{
    // 使用浮点的形式输出整型，编译能够通过
    printf("%f\n",10); 
    
    // d的输出值很有可能不是 5 ，而是其他值，因为字节数错了。
    int i=5;
    void* pInt=&i;
    double d=(*(double*)pInt);
    cout<<d<<endl;
    return 0;
}
```
<!--endsec-->


# 类型转换

## `c`风格

### 自动转换

**将一种类型的数据赋值给另外一种类型的变量时就会发生自动类型转换**

```cpp
float f = 100;
```
> [!note]
> 1. **`100`先转为一个「带有常性的临时变量`100.0`」**
> 1. **然后再将「带有常性的临时变量`100.0`」赋值给`f`**

### 混合数学运算

**在不同类型的混合运算中: 将参与运算的所有数据先转换为同一种类型，然后再进行计算，最后结果在根据右端类型进行类型转化。**

> [!note|style:flat]
> 1. **同一类型：转换按数据长度增加的方向转换同一**
> 1. <span style="color:blue;font-weight:bold"> 所有的浮点运算都是以`double`进行的，即使只有`float` </span>
> 1. <span style="color:blue;font-weight:bold"> `char `和 `short` 参与运算时，必须先转换成 `int` 类型。 </span>
> 1. <span style="color:red;font-weight:bold"> 运算结果值均是「带有常性的临时变量」（不管最后有没有类型转换） </span>

```cpp
int a = 1.9 + 1.6  + 'a'; // 结果 100
float b= 10 / 3; // 结果为 3
```

> **如果除数和被除数都是整数，结果为整数; 如果有一个非整数，否则为小数**

<p style="text-align:center;"><img src="../../image/cpp/typeTransform.png" align="middle" /></p>

### 强制转换

- <span style="color:red;font-weight:bold"> `(类型)`的优先级高于运算符 </span>
```cpp
// 结果为 5.0
float b=(int)10.2 /0.2;
```

### 类型转换只是临时性的


> [!note|style:flat]
> <span style="color:red;font-weight:bold"> 无论是自动类型转换还是强制类型转换，都是先将原来的值转化一个「临时的`const`类型值」，然后再进行赋值，并不会更改原来的数值。 </span>

## `c++`类型转化

### 原因

> [!note]
> - **`c`风格的转换不容易查找**
> - **没有对转化进行分类，容易出问题。**

### 分类

| 类型转化             | 描述                           |
| -------------------- | ------------------------------ |
| `static_cast`        | 静态类型转换。                 |
| `reinterpreter_cast` | 重新解释类型转换。             |
| `dynamic_cast`       | 子类和父类之间的多态类型转换。 |
| `const_cast`         | 去掉`const`属性转换            |

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> 这些转换形式，都能通过`c`风格实现。 </span>

### `static_cast` 静态类型转换

**静态类型转换：在编译期内即可决定其类型的转换，就是一般变量间的转换。**

```cpp
float dpi;
int num3 = static_cast<int> (dPi);
```

### `dynamic_cast`

**用于多态中父子类之间的多态转换**

> [!tip]
> - **转换成功，返回转换后类型；**
> - **转换失败，返回空值**
> - <span style="color:red;font-weight:bold"> 只能用于`type *`与`type &`转换。 </span>

```cpp
Animal* base = NULL;
base = new Cat();

// 将⽗类指针转换成⼦子类，
Dog	*pDog = dynamic_cast<Dog*>(base);

```

### `const_cast`

> [!note|style:flat]
> - **去除`const`属性**
> - <span style="color:red;font-weight:bold"> 只能用于`type *`与`type &`转换。 </span>


```cpp
volatile const int a=1;
int& b = const_cast<int&>(a);
b = 2;
cout << a << endl; // 值为 2

const int c=1;
int& d = const_cast<int&>(c);
d = 2;
cout << c << endl; // 值为 1
```

> [!note|style:flat]
> - **得用`volatile`才能让`a`输出值改变，不然`a`到常量表取值。**
> - **`a`与`b`地址一样**

### `reinterpret_cast`

**就是对内存进行重新规划，并不会改变内存里的二进制值。**

```cpp
int num = 0x00636261;//用16进制表示32位int，0x61是字符'a'的ASCII码
int * pnum = &num;
char * pstr = reinterpret_cast<char *>(pnum);
return 0;
```

> [!note]
> - **`pstr`与`pnum`指向地址值一样。**
> - **`pstr`按照`1`字节计算；`pnum`按照`4`字节计算。**

