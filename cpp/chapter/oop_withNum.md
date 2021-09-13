
 <h1 style="font-size:60px;text-align:center;">面向对象</h1>

# 1. 重载，重写，重定义 

- 重载 overload: <font color="#f44336">同一个类中</font>、函数名字相同、传参类型与数目不同。
- 覆盖 override: 实现父类virtual修饰函数，函数定义完全一样。<font color="#f44336">覆盖了父类的虚函数。</font>
- 重写 overwrite: 重定义父类函数，会屏蔽父类所有同名函数。

> [!note|style:flat]
> **函数名相同就会屏蔽父类同名函数**
> 
> **注** :
>用户能定义自己的C语言库函数，连接器在连接时自动使用这些新的功能函数。这个过程叫做**重定向C语言库函数**。 

# 2. 虚函数

- **虚函数实现**
   - 带有虚函数的类都会持有一个虚函数表
   - 继承带有虚函数父类的子类，会复制一份父类虚函数表，并根据自身实现情况修改虚函数表
   - 继承多个有虚函数表的子类，会维护所有的父类虚函数表
   - 实例化的对象，会持有一个指向虚函数表的指针`vptr`
   - **`vptr`在构造器被调用时，初始化赋值**
- **虚函数/纯虚函数** <font color="#f44336">子类实现后算overwrite</font>
   - 虚函数: virtual修饰，父类实现
   - 纯虚函数: virtual修饰，父类不实现，后面可有 = 0，<font color="#f44336">纯虚函数的类为抽象类。</font>

> [!note|style:flat]
> <font color="#f44336">虚函数是动绑定，运行时确定。</font>


```cpp
#include <stdio.h>

class Parent{
public:
    Parent(){
        fcn();
    }
    virtual void fcn(){
        printf("parent\n");
    }
};

class Son : public Parent{
public:
    Son(){
        fcn();
    }
    virtual void fcn(){
        printf("son \n");
    }
};

int main(int argc, char const *argv[])
{
    Son son;
    return 0;
}

```

```term
triangle@LEARN_FUCK:~$ make 
parent
son 
```

> [!note|style:flat]
> - **构造顺序是先父类，再子类；在构造父类时，`vptr`还是指向父类的虚函数表，在构造子类时，才将`vptr`修改为子类的虚函数表。**

# 3. 继承

**当私有继承和保护继承时，父类指针(引用)无法指向子类。默认为私有继承。防止多重继承，出现属性多次定义，继承时，还要使用 virtual 进行修饰。**

## 3.1. 继承内容

> [!tip]
> **子类会继承的基类的数据**
> - 基类中的每个数据成员（包括`private`，尽管子类不一定都能访问）
> - 基类中的每个普通成员函数（尽管子类不一定都能访问）
> - 与基类相同的初始数据层
> - 对于`static`类型成员的访问权（`private`除外）
>
> **子类不会继承的基类的数据**
> - 基类的「构造函数」与「析构函数」
> - 基类的友元

## 3.2. 子对象的一生

> [!tip]
> **子类对象创建**
> 1. 在栈或者堆上给整个对象分配存储空间（包括从父类继承的属性）
> 1. 调用基类的构造函数来初始化从基类继承下来的数据
> 1. 调用子类的构造函数来初始化子类中的数据成员
> 1. 此时，子类对象可以使用了
>
> **子类对象销毁**
>- 首先调用子类的析构函数 
>- 然后调用基类的析构函数
>- 最后这个对象的内存资源被回收

<!--sec data-title="创建销毁测试" data-id="createDelete" data-show=true data-collapse=true ces-->
```cpp
#include <iostream>

using namespace std;

class Parent{
public:
    Parent(){
        cout << "parent create" << endl;
    }

    ~Parent(){
        cout << "parent delete" << endl;
    }
};

class Son: public Parent{
public:
    Son(){
        cout << "son create" << endl;
    }
    ~Son(){
        cout << "son delete" << endl;
    }
};


int main(int argc, char const *argv[])
{
    Son son;
    return 0;
}

```

```term
triangle@LEARN_FUCK:~$ ./a.out
parent create
son create
son delete
parent delete
```
<!--endsec-->

## 3.3. 拒绝继承

<span style="font-size:24px;font-weight:bold" class="section2">定义`final`类</span>

```cpp
class Parent final{
};

// 报错不能被继承
class Son final : public Parent{
};

int main(int argc, char const *argv[])
{
    Son son;
    return 0;
}

```

```term
triangle@LEARN_FUCK:~$ make 
main.cpp:8:7: error: cannot derive from ‘final’ base ‘Parent’ in derived type ‘Son’
 class Son final : public Parent{
       ^~~
Makefile:12: recipe for target 'main.o' failed
```

<span style="font-size:24px;font-weight:bold" class="section2">定义`final`函数</span>

```cpp
class Parent {
public:
   // 不能被 override 
   virtual void fcn() final {

    }
};

class Son final : public Parent{
public:
    void fcn(){

    }
};

int main(int argc, char const *argv[])
{
    Son son;
    return 0;
}
```

```term
triangle@LEARN_FUCK:~$ make 
main.cpp:12:10: error: virtual function ‘virtual void Son::fcn()’
     void fcn(){
          ^~~
main.cpp:5:17: error: overriding final function ‘virtual void Parent::fcn()’
    virtual void fcn() final {
                 ^~~
Makefile:12: recipe for target 'main.o' failed
```

> [!note|style:flat]
> - **`final`：该关键字为`c++11`新增特性**
> - `virtual 类型 fcn final()`：必须和`virtual`搭配使用

# 4. 重载/多态

- **多态**: <font color="#f44336">父类与子类之间</font>，父类可以接收不同子类，产生不同的行为。
    - **virtual 修饰函数的 override：父类调用子类的实现。** <font color="#ff0000"> 该方式才实现多态。 </font>
    - **无 virtual 修饰函数的 overwrite：父类调用父类的实现。**

- **重载**: <font color="#f44336">一个类里</font>，同一名字的不同方法。

# 5. 构造/析构函数

- **构造函数** 
    - 不声明为虚函数
    - 先父类，后子类
    - 默认构造函数，即无参构造函数。
- **析构函数**
    - **要声明为虚函数; 通过多态析构子对象时，才能正确调用子类析构**
    - 先子类，再父类

## 5.1. 构造函数为啥不能为虚函数

- 构造一个对象的时候，必须知道对象的实际类型，而虚函数行为是在运行期间确定实际类型的。在构造一个对象时，由于对象还未构造成功。编译器无法知道对象的实际类型
- 虚函数的执行依赖于虚函数表。而虚函数表在构造函数中进行初始化工作，即初始化`vptr`，让他指向正确的虚函数表。而在构造对象期间，虚函数表还没有被初始化，将无法进行。 

# 6. 静绑定与动绑定

- **静态类型**：对象在声明时的类型，在编译期既已确定；
- **动态类型**：通常是指针或引用所指对象的类型，是在运行期决定的；
  
```cpp

    /*
    * A 类是声明，是obj的静态类型
    * B 类是具体实例，是obj的动态类型
    */
    A* obj = new B();
```


- **静态绑定**：绑定的是静态类型，所对应的函数或属性依赖于对象的静态类型，发生在编译期；
- **动态绑定**：绑定的是动态类型，所对应的函数或属性依赖于对象的动态类型，发生在运行期；<font color="#f44336">可以进行二次修改。</font>

```cpp
A* obj = NULL;
obj->fcn();
```

&emsp;&emsp;<font color="#f44336">上面的函数也是能正常运行的，因为obj在编译时静绑定。</font>

# 7. 构造函数

- **普通构造函数**: 不能以本类的对象作为**唯一参数**
- **默认拷贝构造函数**: 对源对象的逐个字节的复制，成员变量和源对象相同，由编译器自动生成
- **拷贝构造函数**：构造函数的一种，只有一个本类的引用的参数，用不用const修饰都一样。
- **调用拷贝构造函数，不调用普通构造**: 
    - 一个对象去初始化同类的另一个对象，<font color="#f44336">赋值不会触发。</font>
    ```cpp
    
    A a;
    // 初始化
    A b = a;
    A c(a);
    // 赋值
    b = a;
    ```
    - 作为形参的对象，是用复制构造函数初始化的。<font color="#f44336">直接传递对象，传过去的值，取决于构造函数的实现。</font>
    - `return` 语句所返回的对象

> [!note|style:flat]
> **「拷贝构造函数」不仅会覆盖掉「默认拷贝构造函数」，还会覆盖掉「默认构造函数」**

# 8. 动多态与静多态

| 类型   | 实现方式         | 确定时间 |
| ------ | ---------------- | -------- |
| 动多态 | 继承与`override` | 运行时   |
| 静多态 | 泛型             | 编译     |

# 9. 拷贝构造与赋值

- **拷贝构造函数**
  - 一种特殊的构造函数
  - 复制的对象还不存在，正在为对象初始化一块内存区域，利用复制值进行初始化。

- **赋值**
  - 一种函数操作
  - 赋值的对象已经存在，用复制值来覆盖原来的值。

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> 默认拷贝构造与默认赋值，均是原封不动的拷贝目标对象的值；对于指针也是直接拷贝指针的地址内容，会造成隐患。 </span>

- **正确的赋值**
  - **检查是否为同一个**
  - 指针内存是否要释放
  - **指针变量，对指向值进行拷贝**。

```cpp
//赋值函数
string & string::operator=(const string& other)
{
    if(this == &other) //自我检查
    {
        return *this;
    }
    //删除原有数据内存
    delete []m_data;
    int strlen = strlen(other.m_data);
    m_data = new char[strlen +1];
    strcpy(m_data ,other.m_data);
    return 8this;
}
```

> [!note|style:flat]
> **`T & operator=(const T & other)` 返回了原对象，则串行赋值，是正确的。**
> ```cpp
>    class Test{
>    public:
>          int a;
>    };
>    
>    Test a1,b1,c1;
>    // 串行赋值
>    a1 = b1 = c1;
>    // 修改返回值 修改的是 a1 的值
>    (a1 = b1).a = 12;
> ```
