
<h1 style="font-size:60px;text-align:center;">基础知识</h1>

# 1. c语言文件

头文件后缀名： .h

源文件后缀名： .c

# 2. c++文件

头文件后缀名： .h, .hpp, .hxx

源文件后缀名：.cpp, .cc, .cxx, .C .c++

.hpp: 声明和实现都有

.inl: 内联函数

# 3. 内联函数

&emsp;&emsp;使用inline修饰的<font color="#4c9df8">具体函数实现，非声明</font>。<font color="#f44336">编译期间</font>对于编译器承认的inline函数，将会直接把代码拷贝到函数调用位置。

- 建议性质的关键字，只有简单的函数会被编译器承认。
- 默认地，类中定义的所有函数，除了**虚函数**之外，会隐式地或自动地当成内联函数; **虚函数也能用inline修饰，建议性质的。**
- 泛型定义


# 4. 重定义
&emsp;&emsp; **`#include`会将头文件复制，同一个东西头文件实现一次，源文件实现一次就会触发重定义。** 

# 5. `main`函数

-  `int argc` : 传入参数个数，**默认为1**
-  `const char * argv[]` : 输入的参数列表
    - **一个字符串数组**
    -  `argv[0]` : 被执行程序（.exe文件）所在的绝对路径。


# 6. 编译器

gcc与g++进行文件编译时，会互相调用，**但是编译.c文件除外**；**在链接时，不会互相调用。**
- **预处理**: `-E`，处理宏
- **编译**:`-S`，生成汇编
- **汇编**:`-C`，生成二进制
- **链接**:`-O`，生成目标文件
 
# 7. 定义与声明
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

# 8. 模块化设计

1.  模块即是一个`.c`文件和一个`.h`文件的结合，**头文件(.h)中是对于该模块接口的声明，一般都用extern进行修饰**；
2.  供给其它模块调用的外部函数及全局变量需在`.h`中文件中冠以`extern`关键字声明；
3. 模块内的函数和全局变量需在`.c`文件开头冠以`static`关键字声明；
4. <font color="#f44336" style="font-weight:bold">永远不要在.h文件中定义全局变量！</font>
5. 头文件中可以定义的实体，<font color="#f44336" style="font-weight:bold">得有头文件保护，否则会重定义。</font>
    - 值在编译时就已知的 `const` 变量的定义可以放到头文件中
    - 结构体，类的定义可以放到头文件中
    - `inline` 函数

# 9. 泛型

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

# 10. 类型安全

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


# 11. 类型转换

## 11.1. `c`风格

### 11.1.1. 自动转换

**将一种类型的数据赋值给另外一种类型的变量时就会发生自动类型转换**

```cpp
float f = 100;
```
> [!note]
> 1. **`100`先转为一个「带有常性的临时变量`100.0`」**
> 1. **然后再将「带有常性的临时变量`100.0`」赋值给`f`**

### 11.1.2. 混合数学运算

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

### 11.1.3. 强制转换

- <span style="color:red;font-weight:bold"> `(类型)`的优先级高于运算符 </span>
```cpp
// 结果为 5.0
float b=(int)10.2 /0.2;
```

### 11.1.4. 类型转换只是临时性的


> [!note|style:flat]
> <span style="color:red;font-weight:bold"> 无论是自动类型转换还是强制类型转换，都是先将原来的值转化一个「临时的`const`类型值」，然后再进行赋值，并不会更改原来的数值。 </span>

## 11.2. `c++`类型转化

### 11.2.1. 原因

> [!note]
> - **`c`风格的转换不容易查找**
> - **没有对转化进行分类，容易出问题。**

### 11.2.2. 分类

| 类型转化             | 描述                           |
| -------------------- | ------------------------------ |
| `static_cast`        | 静态类型转换。                 |
| `reinterpreter_cast` | 重新解释类型转换。             |
| `dynamic_cast`       | 子类和父类之间的多态类型转换。 |
| `const_cast`         | 去掉`const`属性转换            |

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> 这些转换形式，都能通过`c`风格实现。 </span>

### 11.2.3. `static_cast` 静态类型转换

**静态类型转换：在编译期内即可决定其类型的转换，就是一般变量间的转换。**

```cpp
float dpi;
int num3 = static_cast<int> (dPi);
```

### 11.2.4. `dynamic_cast`

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

### 11.2.5. `const_cast`

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

### 11.2.6. `reinterpret_cast`

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

