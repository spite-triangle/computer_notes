 <h1 style="font-size:60px;text-align:center;">事务</h1>
 
# 1. 事务概念

> [note]
> **概念：一段业务逻辑，要么全部成功，要么全部失败，不允许某部分成功的情况。**
> **代码实现：就是将一组`SQL`代码放到一个批次中执行。**

# 2. `ACID`原则

参考博客：[事务ACID理解](https://blog.csdn.net/dengjili/article/details/82468576)

## 2.1. 介绍

|        概念         | 描述                                                                                                                   |
| :-----------------: | ---------------------------------------------------------------------------------------------------------------------- |
|  原子性(atomicity)  | 整个过程要么全部成功，要么全部失败                                                                                     |
| 一致性(consistency) | 操作后与操作前，数据状态一致                                                                                           |
|  隔离性(isolation)  | 多用户并发，不会相互影响                                                                                               |
| 持久性(durability)  | 事务「**提交**」到数据库，数据库改变且不可逆(**回滚无效**) <br> 事务没有提交到数据库，数据库恢复原状（**数据库回滚**） |


## 2.2. 隔离所导致的问题

### 2.2.1. 脏读

**`A,B`事务同时对「同一数据」进行操作，`A`在执行过程中并「还未提交」，`B`在「数据最开始的状态」上进行了修改并提交。这样`B`就对数据进行了脏读。**

> [!note|style:flat]
> <span style="color:blue;font-weight:bold"> 还有事务在运行时，进行数据获取，提交修改。 </span>

### 2.2.2. 不可重复读

**在`A`事务运行时，多次对统一行数据进行「读取」。在此期间有其他事务「对数据修改」完成了提交，这样就会导致`A`事务的多次读取「数据值不一样」。**

> [!note|style:flat]
> <span style="color:blue;font-weight:bold"> 多次读同一位置的数据，值不一样 </span>

### 2.2.3. 幻读

**在`A`事务运行时，多次对数据进行「读取」。在此期间有其他事务「添加了新数据修」完成了提交，这样`A`事务前后读取的「数据量不一样」。**

> [!note|style:flat]
> <span style="color:blue;font-weight:bold"> 多次读取某几行数据，突然多了一行数据 </span>

# 3. `SQL`操作

## 3.1. 事务自动提交

> [!note|style:flat]
> **`MySQL`默认开启自动提交。**

```sql
-- 关闭
set autocommit = 0;

-- 开启
set autocommit = 1;
```

## 3.2. 存档点 (了解)

```sql
-- 存档点
savepoint 保存点
-- 回退存档点
rollback to 保存点
-- 删除存档点
release 保存点
```

> [!note|style:flat]
> 事务失败了，这存档点也没啥用了。

## 3.3. 事务


```sql

-- 关闭自动提交
set autocommit = 0;

-- 开启事务
start transaction

具体代码逻辑

-- 成功：提交
commit;

-- 失败：回滚，恢复数据
rollback;

-- 开启自动提交
set autocommit = 1;

```

> [!note|style:flat]
> - **首先要关闭自动提交，事务执行完在开启。**
> - **在`commit rollback`后，就会关闭事务，所有特别关闭`transaction`**


