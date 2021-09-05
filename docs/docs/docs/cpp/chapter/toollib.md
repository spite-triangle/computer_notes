
<h1 style="font-size:60px;text-align:center;">工具库</h1>


# 1 math

```cpp
#include<math.h>

// 绝对值
int abs(int);
double fabs(double);

// 四舍五入
double round(double);

// 取整
double ceil(double num); // 向上取整
double floor(double num);// 向下取整

// 余数
double fmod(double num，double base);
%; 只能用于int;

```
# 2 regex

-  `\b` : 字符边界
-  `.` : 除 `\n` 以外所有字符
-  `\w` : 等价于 `[(0-9)(a-z)(A-Z)(_)]` ，数字，字母，下划线
-  `\W` : 上面取反 `[^(0-9)(a-z)(A-Z)(_)]`
-  `\d` : 数字
-  `\D` : 上面取反
-  `\s` : 空白符(空格，制表符，换行)
-  `\S` : 上面取反
-  `regex_search` : <font color="#f44336">只返回第一次匹配到的子串</font>
- <font color="#4c9df8">上面的匹配字符，编程用时还要再加一个 `\` </font>

```cpp
#include <regex>

// 定义表达式
regex reg("[a-z0-9]+");

// 是否匹配
bool regex_match(string,regex);//全匹配
bool regex_search(string,regex);//子串匹配，只匹配第一次找到的

// 捕获
bool reg_search(string，smatch，regex);
smatch.size(); //匹配到的个数: 表达式匹配 + 捕获匹配
smatch.str(0); // 整个正则匹配到的部分
smatch.str(i); // 0之后的，都是捕获部分
smatch.prefix().str(); // 未匹配的前部分
smatch.prefix().str();// 未匹配的后部分
```
# 3 匿名函数

> [!note]
> **只有`c++11`以上的编译器才支持。**

```cpp
    [capture](Parameters)->return_type{
        body;
    }
```

- `capture`: 

    ```cpp
    []        //未定义变量.试图在Lambda内使用任何外部变量都是错误的.
    [x, &y]   //x 按值捕获, y 按引用捕获.
    [&]       //用到的任何外部变量都隐式按引用捕获
    [=]       //用到的任何外部变量都隐式按值捕获
    [&, x]    //x显式地按值捕获. 其它变量按引用捕获
    [=, &z]   //z按引用捕获. 其它变量按值捕获
    ```
    > [!note|style:flat]
    > **`[this](){this->;}` 对于 `this`只能用值捕获。**

- `parameters`: 参数列表

- `return_type`: 返回值

```cpp
    sort(vec.begin(),vec.end(),[](const Entry & A,const Entry & B) -> bool{
        return A.val > B.val;
    });
```