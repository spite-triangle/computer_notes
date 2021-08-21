
<h1 style="font-size:60px;text-align:center;">基础知识</h1>

# 1 c语言文件

头文件后缀名： .h

源文件后缀名： .c

# 2 c++文件

头文件后缀名： .h, .hpp, .hxx

源文件后缀名：.cpp, .cc, .cxx, .C .c++

.hpp: 声明和实现都有

.inl: 内联函数

# 3 内联函数

&emsp;&emsp;使用inline修饰的<font color="#4c9df8">具体函数实现，非声明</font>。<font color="#f44336">编译期间</font>对于编译器承认的inline函数，将会直接把代码拷贝到函数调用位置。

- 建议性质的关键字，只有简单的函数会被编译器承认。
- 默认地，类中定义的所有函数，除了**虚函数**之外，会隐式地或自动地当成内联函数; **虚函数也能用inline修饰，建议性质的。**
- 泛型定义


# 4 重定义
&emsp;&emsp; **`#include`会将头文件复制，同一个东西头文件实现一次，源文件实现一次就会触发重定义。** 

# 5 `main`函数

-  `int argc` : 传入参数个数，**默认为1**
-  `const char * argv[]` : 输入的参数列表
    - **一个字符串数组**
    -  `argv[0]` : 被执行程序（.exe文件）所在的绝对路径。


# 6 编译器

gcc与g++进行文件编译时，会互相调用，**但是编译.c文件除外**；**在链接时，不会互相调用。**
- **预处理**: `-E`，处理宏
- **编译**:`-S`，生成汇编
- **汇编**:`-C`，生成二进制
- **链接**:`-O`，生成目标文件
 
# 7 定义与声明
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

# 8 模块化设计

1.  模块即是一个`.c`文件和一个`.h`文件的结合，**头文件(.h)中是对于该模块接口的声明，一般都用extern进行修饰**；
2.  供给其它模块调用的外部函数及全局变量需在`.h`中文件中冠以`extern`关键字声明；
3. 模块内的函数和全局变量需在`.c`文件开头冠以`static`关键字声明；
4. <font color="#f44336" style="font-weight:bold">永远不要在.h文件中定义全局变量！</font>
5. 头文件中可以定义的实体，<font color="#f44336" style="font-weight:bold">得有头文件保护，否则会重定义。</font>
    - 值在编译时就已知的 `const` 变量的定义可以放到头文件中
    - 结构体，类的定义可以放到头文件中
    - `inline` 函数

# 9 泛型

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