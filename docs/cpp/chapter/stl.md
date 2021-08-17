
 <h1 style="font-size:60px;text-align:center;">STL</h1>

# 1 简介
&emsp;&emsp;STL（Standard Template Library），即标准模板库，是一个具有工业强度的，高效的C++程序库。该库包含了诸多在计算机科学领域里所常用的**基本数据结构**和**基本算法**。
- 数据结构和算法的分离
- 不是面向对象的
- 广泛应用泛型

主要构成有六大组件: 

- 容器（Container）
- 迭代器（Iterator）
- 算法（Algorithm）
- 仿函数（Functor）
- 适配器（Adaptor）
- 分配器（allocator）

# 2 容器（Container）

- **序列式容器**（Sequence containers）
    - Vector: 动态数组
    - Deque: 双端队列，是一种具有**队列和栈**的性质的数据结构。元素可以从两端弹出，**其限定插入和删除操作在表的两端进行**。
    - List: 双向链表
- **关联式容器**（Associated containers)
    -  Set/Multiset: Set内的相同数值的元素只能出现一次; Multisets内可包含多个数值相同的元素。
    - Map/Multimap: map只允许key唯一；multimap中key可以重复使用；

> [!note|style:flat]
> `set map multiset multimap` 通过红黑实现，无序 `unorder_map unorder_set` 通过哈希表实现。
 


# 3 分配器
<font color="#f44336">容器类自动申请和释放内存，无需new和delete操作。</font>

# 4 迭代器
- 遍历数据用的。
- <font color="#f44336">支持运算符:  `*;+＋;＝＝;！＝;＝` </font>。
- <font color="#f44336"> 指针操作 </font>

```cpp
    Container c;
    Container::iterator it;
    for(it=c.begin();it!=c.end();it++){
        // vector 获取值
        *it;
        // map 获取键值对
        it->first;
        it->second;
    }
```

- <span style="color:red;font-weight:bold"> 带迭代器的容器遍历 </span>

```cpp
    // 只读
    for(auto item:containers){

    }
    // 可修改 能修改的值
    for(auto& item:containers){

    }
```

# 5 算法

### 1. 头文件
&emsp;&emsp;算法部分主要由头文件`<algorithm>`，<numeric>和<functional>组成。

- `<algorithm>`: 由一大堆模版函数组成的，可以认为每个函数在很大程度上都是独立的，其中常用到的功能范围涉及到比较、交换、查找、遍历操作、复制、修改、移除、反转、排序、合并等等。
- `<numeric>`: 只包括几个在序列上面进行简单数学运算的模板函数，包括加法和乘法在序列上的一些操作。
- `<functional>`: 中则定义了一些模板类，用以声明函数对象。

### 2. 常用算法

&emsp;&emsp; [STL常用算法](https://blog.csdn.net/b_ingram/article/details/118874862)


# 6 仿函数

&emsp;&emsp; **钩子函数，可以当参数传递，让具体算法进行调用。** 系统定义好的仿函数: `<functional\>`

- 函数指针实现

- 仿函数实现: 
    1. 定义一个**简单的类**
    2. 实现 `operator()` 操作符，**本质上就定义了一个符号函数**。

```cpp
    #include <stdio.h>
    #include <algorithm>
    #include <vector>

    class Compare{
        public:
        bool operator()(int a,int b){
            return a > b;
        } 
    };

    int main(int argn,const char* args[]){
        vector<int> vec(5,1);
        vec[0] = 2;
        vec[1] = 1;
        vec[2] = 9;
        vec[3] = 3;
        vec[4] = 1;

        // 排序算法
        sort(vec.begin(),vec.end(),Compare());

        // 实际的函数调用
        bool flag = Compare()(10,12); 
    }
```

> [!note|style:flat]
> **注意：**
> **`Compare()`是定义了一个临时对象**，作为参数传递给了 `sort()`；**若`sort()`没有采用引用传递，则对象将是值传递。** 


# 7 容器适配器

&emsp;&emsp;对基础容器进行功能扩展，标准库提供了三种顺序容器适配器: 

- **queue**(FIFO队列)
- **stack**(栈)
- **priority_queue**(优先级队列)

|      容器      |   头文件   | 默认容器 |      可选容器       |               说明               |
| :------------: | :--------: | :------: | :-----------------: | :------------------------------: |
|     queue      | `<queue\>` |  deque   |     list、deque     | 基础容器必须提供push_front()运算 |
| priority_queue | `<queue\>` |  vector  |    vector、deque    |   基础容器必须提供随机访问功能   |
|     stack      | `<stack\>` |  deque   | vector、list、deque |                                  |
