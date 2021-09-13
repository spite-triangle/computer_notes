
 <h1 style="font-size:60px;text-align:center;">关键字</h1>

# new/delete

编译器分配内存的关键字，会调用构造器与析构器。`malloc/free`为库函数实现。

> [!note|style:flat]
> **`new/delete`与`malloc/free`分配内存后，均没用初始化。**

```cpp
    // 分配内存，没有初始化
    int* a = new int[10];
    // 分配内存，初始化 0 
    int* a = new int[10]();
    // 通过传值初始化
    int* a = new int[10](另一个int[10]的数组);
    delete[] a;

    // 申请一个值的空间
    int* b = new int(5);
    delete b;

    // malloc 函数申请空间，没有初始化
    int* a = (int *) malloc(sizeof(int)*10);
    free(a);
```


# const

```cpp
// 限定内容
const int*p;
int const *p;

// 限定指针
 int* const p;

// 都限定
const int* const p;
```

- **类成员函数后**: 这个函数不会对这个类对象的数据成员（准确地说是非静态数据成员）作任何改变。 <font color="#f44336" style="font-weight:bold">const函数内，只能调用const函数。</font>
- **类成员函数前**: 返回值是一个常量，不能修改，**通常用来限定引用**。
- **const变量**: 
    - 编译器会将常量优化，<font color="#f44336" style="font-weight:bold">放到「符号表」（`c++`才有），取值会从表中直接获取，而不是去内存</font>。通过指针修改值后，值不变。
    - 编译过程中若发现使用常量则直接以符号表中的值替换
    - 添加关键字`volatile`，可以防止编译器优化，从内存取值。通过指针修改值后，值会变。
- **const对象**: 只能访问`const`与`static`修饰的内容。

# override

&emsp;&emsp;配合 **virtual** 关键字使用；修饰**子类 override 函数**。

# volatile

- **作用**：访问寄存器要比访问内存要块，因此`CPU`会优先访问该数据在寄存器中的存储结果，但是内存中的数据可能已经发生了改变，而寄存器中还保留着原来的结果。为了避免这种情况的发生将该变量声明为`volatile`，**告诉`CPU`每次都从内存去读取数据。**

- **没有线程同步的语义**

# static
- **函数体内**： 修饰的局部变量作用范围为该函数体，**在内存只被分配一次，下次调用的时候维持了上次的值**。
- <font color="#f44336" style="font-weight:bold">源文件全局</font>：修饰的全局变量或函数，范围限制在声明它的模块内，**不能被extern找到**。
- **类中修饰成员变量**: 表示该变量属于整个类所有，对类的所有对象只有一份拷贝。
    - <font color="#f44336">在类里声明，到类外实现</font>
    - **类外全局处实现**，不用`static`修饰
    - **全对象共享**
- **类中修饰成员函数**: 表示该函数属于整个类所有，**不接受this指针**，只能访问类中的`static`成员变量。
    - **类的里/外都能实现**，类外实现省略`static`

#  extern "C"
- 会指示编译器这部分代码按`C`语言的进行编译，而不是`C++`的;能够正确实现`C++`代码调用其他`C`语言代码。

#  extern
- **问题**：`include`可以使当前文件能够包含其他文件，能够使用里面的「变量或者函数」。但是这样做的结果就是，被包含的文件中的所有的「变量和函数」都可以被这个文件使用，这样就变得不安全。
- **限制某些「变量和函数」不能被其他文件使用：**
  - **`.h`文件：能被其他文件使用的变量或者函数，利用`extern`进行修饰限定。不想被其他文件使用的，就别在`.h`里写。**
  - **`.cpp`文件：不想被其他文件所使用的变量或者函数，利用`static`进行修饰。**
- <font color="#f44336">源文件</font>中的全局变量与函数定义，默认都能被`extern`找到。

> [!tip]
> **限制某些「结构体和类」:** 
> - 想给别人用，就把声明写`.h`里；不想给别人用，就把声明写`.cpp`里。
> - **结构体和类的「定义」，不能使用`extern`与`static`进行修饰。**

#  friend
**可以让外部函数或者外部类，访问私有类的私有属性与函数。**

- **友元函数**
    - 定义在类外的普通函数
    - 需要在类中声明
- **友元类**: 友元类的所有成员函数都是另一个类的友元函数，都可以访问另一个类中的隐藏信息（包括私有成员和保护成员）。
    - 不能被继承
    - 两个类的关系是单向的
    - 不可传递

#  储存类型符
- **auto**：所有**局部变量**默认的存储类， **对于C， 块语句中也可定义局部变量，形参也是。** 
- **register**: 存储在寄存器中（只是建议，具体实现看编译器）。
- **static**：局部修饰变量后改变了生存期;全局变量修饰后改变了作用域
- **extern**：引入其他`.C`文件中已定义的非`static`全局变量;可以在函数的内外声明变量或者函数。
- **mutable**：仅适用于类的对象成员变量，它允许`const`函数能对成员变量进行修改

#  cin

## 简介

- 遇到  `\n`  才会将写入内容加载到缓冲区
- `\n` 也算一个字符，会被加载到缓冲区
- 缓冲区为空时，`cin` 阻塞等待数据;一旦缓冲区中有数据，就触发 `cin` 去读取数据。
- **遇到`EOF`会结束。**

    > [!tip|style:flat] **可用来循环读取值**
    > ```cpp
    >    while(cin >> value){}
    > ```

## 用法

### `cin >>` 
  - 连续从键盘读取想要的数据，<font color="#f44336">以空格、tab 、换行为分隔符</font>。

      ```cpp
          char a;
          int b;
          float c;
          string 
          cin>>a>>b>>c;
      ```

 - 当 `cin >>`  从缓冲区中读取数据时，**若缓冲区中第一个字符是空格、tab或换行这些分隔符时，cin>> 会将其<font color="#f44336">忽略并清除</font>，继续读取下一个字符**; 若缓冲区为空，则继续等待。<font color="#f44336">但是如果读取成功，字符后面的 **空白符号** 是残留在缓冲区的，`cin>>` 不做处理。</font>
 - 不想略过空白字符，那就使用 noskipws 流控制。
 - `cin >>`的返回值为  `cin` ;当输入 `EOF` （windows:ctrl+z， Linux:ctrl+d）时， `cin >>` 会返回`0`。

      ```cpp
      int a;
      // 当输入 EOF 时，可以终止循环
      while（cin >> a）{

      }
      ```


###  `cin.get()` 

> [!note|style:flat]
> <font color="#f44336" style="font-weight:bold">缓冲区没有东西时，会堵塞等待。</font>

```cpp
int get();
istream& get(char& var);
istream& get( char* s, streamsize n );
istream& get( char* s,  streamsize  n, char delim);
```
**读取字符** :

```cpp

#include <iostream>
using namespace std;

int main() {
    char a;
    char b;
    a=cin.get();
    cin.get(b);
    cout << a << b <<endl;
    return 0;
}

```

- <font color="#f44336" style="font-weight:bold">从输入缓冲区读取单个字符时不忽略分隔符，直接将其读取。</font>

**读取行** 
```cpp
istream& get(char* s, streamsize n)
istream& get(char* s, size_t n, char delim)
```
-  `s` ，接收字符串用的数组
-  `n` ，读取个数。<font color="#f44336">实际读取个数为  `n - 1` ，留了一个给  `\0` </font>
-  `delim` ，指定终止符
- **换行符(结束符)会被留在缓冲区**，<span style="color:red;font-weight:bold"> 但末尾其余空白符会被读取。 </span>


### `cin.getline（）`  **读取行** 

```cpp
istream& getline(char* s, streamsize count); //默认以换行符结束
istream& getline(char* s, streamsize count, char delim);
```

- **换行符(结束符)会被清理掉**，<span style="color:red;font-weight:bold"> 但末尾其余空白符会被读取。 </span>
-  `getline(cin,string,"结束符")` 功能更强。<font color="#f44336">传入的是  `cin`  ，不是  `stdin`  </font>

## cin 清空输入缓冲区

### 方法一
```cpp
istream &ignore(streamsize num=1, int delim=EOF);
```

- **跳过输入流中  `num`  个字符，或遇到终止符  `delim` 结束（包括终止符）。**
-  `ignore()` ** 会阻塞等待，最好别用  `EOF` 做终止符**。
-  `num` : 可以设置一个很大的数
    ```
    #include <limits>
    numeric_limits<std::streamsize>::max();
    ```

### 方法二

```cpp
fflush(stdin);
```

#  `:: / :` 

## `::`
- 当局部变量与全局变量重名，可以修饰变量，访问全局变量。<font color="#f44336">仅c++支持</font>

    ```cpp
    int x;  // Global x 
    
    int main() 
    { 
    int x = 10; // Local x 
    cout << "Value of global x is " << ::x; 
    cout << "\nValue of local x is " << x;  
    return 0; 
    } 
    ```

- 在类之外定义函数

- 访问类的全局变量

    ```cpp
    class Test 
    {   
    public: 
        static int x; 
    };

    int Test::x = 1;

    void main(){
        Test::x;
    }
    ```

- 如果有多个继承，父类变量名重名，子类可以做区分。

- 两个命名空间重命名

- 访问内部类

    ```cpp
    #include<iostream> 
    using namespace std; 
    
    class outside 
    { 
    public: 
        int x; 
        class inside 
        { 
        public: 
                int x; 
                static int y;  
                int foo(); 
    
        }; 
    }; 
    int outside::inside::y = 5;  
    
    int main(){ 
        outside A; 
        outside::inside B; 
    
    }
    ```

## `:`

- **foreach**

```cpp
    for(int item:vector){
        
    }
```

- **继承**

- **参数初始化列表**

```cpp
class Father{
public:
    Father(){
        cout << "father" << endl;
    }
};
// 继承
class Son:public Father{
public:
    // 参数化列表
    Son():Father(){
        cout << "son" << endl;
    }
};
```

## 参数初始化列表

- **初始化父类的构造器**
- **初始化`const`变量**
- **初始化`var &`引用变量**

```cpp
class Father{
public:
    Father(){
        cout << "father" << endl;
    }
};
class Son:public Father{
public:
    int& a;
    const int b;
    // 参数初始化列表
    Son(a,b):Father(),a(a),b(b){
        cout << "son" << endl;
    }
};
```


# include

-  `#include<>` :**只从从「标准库头文件目录」下搜索**，对于标准库文件搜索效率快。

-  `#include""` :**首先从「当前源文件目录」开始搜索，然后搜索标准库**，对于自定义文件搜索比较快。

# type-3

## 总结`type-3`

| 名称       | 作用                                              | 注意                                                           |
| ---------- | ------------------------------------------------- | -------------------------------------------------------------- |
| `typedef`  | 给变量`A`赋予一个别名`B`                          | **1)`A`当前作用域可以访问的** <br> **2)`B`只在当前作用域有效** |
| `typeid()` | 获取类型信息，也就是**对象原始模板的信息**        | **泛型**                                                       |
| `typename` | 1）**声明泛型类型**；<br> 2）**声明泛型内嵌类型** | 下面解释                                                       |

## `typeid()`

```cpp
    // 查看类型
    typedef int FUCK;
    int var;
    const type_info & infoInt = typeid(int);
    const type_info & infoDef = typeid(FUCK);
    const type_info & infoVar = typeid(var);

    // 查看信息
    info.name(); // 类型原始模板的名称
    info.hash_code(); // 类型原始模板的哈希码

    // 查看两个类型是否一样
    if(infoInt == infoDef)

```

> [!note|style:flat]
> 1 **`infoInt,infoDef,infoVar`都是一样的，他们的原始模板都是`int`**。
> 
> 2 **泛型识别类型**
> ```cpp
> template<typename T>
> void print(T& a){
>    if(typeid(a) == typeid(int)){
>        cout << "True" << endl;
>    }
> }
> ```
> 3 **无法确定继承原始类型，输出为`Father`；`s`被首先`Father`静绑定了。**
> ```cpp
> class Father{};
> class Son : public Father{};
> int main(){
>     Father * s = new Son();
>     cout << typeid(s).name() << endl;
>     delete son;
>     return 0;
> }
> ```

## `typename`

- **声明泛型类型**

    ```cpp
        // 泛型
        template<typename T>
        class Test{
        public:
            void print(const T & a){
                cout << a << endl; 
            }
        };

        int main(){
            Test<int> test;

            test.print(10);

            return 0;
        }
    ```

    > [!note|style:flat]
    > **`Test<int> test;`是在编译时确定，属于静态绑定。**


- **声明泛型内嵌类型**
    - **泛型：大前提**
    - **内嵌：在类的内部定义类型。**
    ```cpp
        class Car{
        public:
            // 类型别名
            typedef float Speed;
            // 内部类
            class Wheel{
            };
        };
    ```
    <span style="color:red;font-weight:bold"> 当使用泛型的内嵌类型定义变量时，需要利用`typename`进行说明，否则编译器不知道这个是类型还是`static`变量。</span>

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

        template<typename T>
        class PrivateCar{
            public:
            // 定义变量
            typename T::Speed v;
            typename T::Wheel wheels;
            float getPrice(){
                // 变量
                return T::price; 
            }
        }; 
    ```
    > [!note|style:flat]
    > **不用`typename`的列外情况**
    > ```cpp
    > template<class T>
    > class Derived: public Base<T>::内部类型
    > {
    >   Derived(int x) : Base<T>::内部类型(x)
    >   {
    >   ...
    >   }
    > }
    > ```


# private/protected/public

## 类的内部对外

> [!note]
> **默认修饰为`private`**
  
| 修饰成员     | private | protected | public |
| ------------ | ------- | --------- | ------ |
| 外部能否访问 | 不行    | 不行      | 可以   |

## 继承

> [!note]
> **默认继承为`private`**

### 子类内部对父类的访问

| 修饰父类成员 | private | protected | public |
| ------------ | ------- | --------- | ------ |
| 子类能否访问 | 不行    | 可以      | 可以   |


> [!note|style:flat]
> **继承限定对子类访问父类，没有一丢丢的影响，访问权限和上面一样。**

### 子类的父类成员对外

| 修饰继承         | private                                         | protected             | public   |
| ---------------- | ----------------------------------------------- | --------------------- | -------- |
| 子类中的父类成员 | `public`变`private` <br> `protected`变`private` | `public`变`protected` | 保持原样 |

# `a = a + b`与`a += b`

**对于`a = a + b`而言，可以等价于：**

> [!tip]
> ```cpp
> temp = a;
> temp += b;
> a = temp;
> ```
> - <span style="color:red;font-weight:bold"> `temp`就是类型转换中的那个「常性中间变量」。 </span
> - **就效率而言`a += b`比较快。**

# 宏变量

| 名称          | 描述                                                                       |
| ------------- | -------------------------------------------------------------------------- |
| `_LINE_ `     | 这会在程序编译时包含当前行号                                               |
| `_FILE_`      | 这会在程序编译时包含当前文件名                                             |
| `_DATE_`      | 这会包含一个形式为 `month/day/year`                                        |
| `_TIME_`      | 这会包含一个形式为 `hour:minute:second` 的字符串，它表示程序被编译的时间。 |
| `__cplusplus` | 是`c++`进行编译，还是`c`语言进行编译                                       |
