
 <h1 style="font-size:60px;text-align:center;">关键字</h1>

# 1. `new/delete`
&emsp;&emsp;编译器关键字，会调用构造器与析构器。malloc/free为库函数实现。

# 2. `const`

```cpp
// 限定内容
const int*p;
int const *p;

// 限定指针
 int* const p;

// 都限定
const int* const p;
```

> [!note|style:flat]
> **不可变的 := 可变的 ，反过来不行。**

## 2.1 c

- const变量: **可以通过指针修改值，就是一个建议**。

## 2.2 c++

- **类成员函数后**: 这个函数不会对这个类对象的数据成员（准确地说是非静态数据成员）作任何改变。 <font color="#f44336" style="font-weight:bold">const函数内，只能调用const函数。</font>
- **类成员函数前**: 返回值是一个常量，不能修改，**通常用来限定引用**。
- **const变量**: 
    - 编译器会将常量优化，放到符号表，<font color="#f44336" style="font-weight:bold">取值会从表中直接获取，而不是去内存</font>。通过指针修改值后，值不变。
    - 添加关键字`volatile`，可以防止编译器优化，从内存取值。通过指针修改值后，值会变。
- **const对象**: 只能访问`const`与`static`修饰的内容。

# 3. override

&emsp;&emsp;配合 **virtual** 关键字使用；修饰**子类 override 函数**。

# 4. volatile

- 避免优化、强制内存读取的顺序。
- **没有线程同步的语义**

# 5. static
- **函数体内**： 修饰的局部变量作用范围为该函数体，**在内存只被分配一次，下次调用的时候维持了上次的值**。
- <font color="#f44336" style="font-weight:bold">源文件全局</font>：修饰的全局变量或函数，范围限制在声明它的模块内，**不能被extern找到**。
- **类中修饰成员变量**: 表示该变量属于整个类所有，对类的所有对象只有一份拷贝。
    - <font color="#f44336">在类里声明，到类外实现</font>
    - **类外全局处实现**，不用`static`修饰
    - **全对象共享**
- **类中修饰成员函数**: 表示该函数属于整个类所有，**不接受this指针**，只能访问类中的`static`成员变量。
    - **类的里/外都能实现**，类外实现省略`static`

# 6.  extern "C"
&emsp;&emsp;会指示编译器这部分代码按`C`语言的进行编译，而不是`C++`的;能够正确实现`C++`代码调用其他`C`语言代码。

# 7.  extern
&emsp;&emsp;使用`include`将另一个文件全部包含进去可以引用另一个文件中的变量，但是这样做的结果就是，被包含的文件中的所有的变量和方法都可以被这个文件使用，这样就变得不安全。如果只是希望一个文件使用另一个文件中的某个变量还是使用`extern`关键字更好。
- <font color="#f44336">源文件</font>中的全局变量与函数定义，默认都能被`extern`找到。

# 8.  friend
&emsp;&emsp;**可以让外部函数或者外部类，访问私有类的私有属性与函数。**
- **友元函数**
    - 定义在类外的普通函数
    - 需要在类中声明
- **友元类**: 友元类的所有成员函数都是另一个类的友元函数，都可以访问另一个类中的隐藏信息（包括私有成员和保护成员）。
    - 不能被继承
    - 两个类的关系是单向的
    - 不可传递

# 8.  储存类型符
- **auto**：所有**局部变量**默认的存储类， **对于C， 块语句中也可定义局部变量，形参也是。** 
- **register**: 存储在寄存器中（只是建议，具体实现看编译器）。
- **static**：局部修饰变量后改变了生存期;全局变量修饰后改变了作用域
- **extern**：引入其他`.C`文件中已定义的非`static`全局变量;可以在函数的内外声明变量或者函数。
- **mutable**：仅适用于类的对象成员变量，它允许`const`函数能对成员变量进行修改

# 9.  cin

## 9.1. 简介

- 遇到  `\n`  才会将写入内容加载到缓冲区
- `\n` 也算一个字符，会被加载到缓冲区
- 缓冲区为空时，`cin` 阻塞等待数据;一旦缓冲区中有数据，就触发 `cin` 去读取数据。
- **遇到`EOF`会结束。**

    > [!tip|style:flat] **可用来循环读取值**
    > ```cpp
    >    while(cin >> value){}
    > ```

## 9.2. 用法

### 1. `cin >>` 
  - 连续从键盘读取想要的数据，<font color="#f44336">以空格、tab 、换行为分隔符</font>。

      ```cpp
          char a;
          int b;
          float c;
          string 
          cin>>a>>b>>c;
      ```

 - 当 `cin >>`  从缓冲区中读取数据时，**若缓冲区中第一个字符是空格、tab或换行这些分隔符时，cin>> 会将其<font color="#f44336">忽略并清除</font>，继续读取下一个字符**; 若缓冲区为空，则继续等待。<font color="#f44336">但是如果读取成功，字符后面的 **空白符号** 是残留在缓冲区的，cin>> 不做处理。</font>
 - 不想略过空白字符，那就使用 noskipws 流控制。
 - `cin >>`的返回值为  `cin` ;当输入 `EOF` （windows:ctrl+z， Linux:ctrl+d）时， `cin >>` 会返回0。

      ```cpp
      int a;
      // 当输入 EOF 时，可以终止循环
      while（cin >> a）{

      }
      ```


### 2.  `cin.get()` 

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


### 3. `cin.getline（）`  **读取行** 

```cpp
istream& getline(char* s, streamsize count); //默认以换行符结束
istream& getline(char* s, streamsize count, char delim);
```

- **换行符(结束符)会被清理掉**，<span style="color:red;font-weight:bold"> 但末尾其余空白符会被读取。 </span>
-  `getline(cin,string,"结束符")` 功能更强。<font color="#f44336">传入的是  `cin`  ，不是  `stdin`  </font>

## 9.3. cin 清空输入缓冲区

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

# 10.  `::` 

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

# 11. include

-  `#include<>` :**只从从标准库文件目录下搜索**，对于标准库文件搜索效率快。

-  `#include""` :**首先从用户工作目录下开始搜索**，对于自定义文件搜索比较快，然后搜索标准库。
