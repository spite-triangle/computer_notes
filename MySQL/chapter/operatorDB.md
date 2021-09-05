
 <h1 style="font-size:60px;text-align:center;">数据库、表操作</h1>

# `SQL`语法

## 结尾

`;` 表示一行代码解释。

## 注释

```sql

-- 单行注释

/**
* 多行注释
*/
```

## 特殊名称

**如果表名或者字段的名称和`sql`关键字冲突，或者带有特殊字符，这时候就需要用到 ` `` `。**

```sql
create database `database`;
```

## 命名

> [!note|style:flat]
> **`SQL`的关键字，字段名均不区分大小写。**

# 数据库需要操作的内容

> [!note]
> 1. 操作数据库
> 1. 操作表
> 1. 操作表中的数据

# 操作数据库

## 添加数据库

`if not exists`: 判断为真，才执行命令。

```sql
create database [if not exists] 数据库名;
```

## 删除数据库

`if exists`: 判断为真，才执行。

```sql
drop database [if exists] 数据库;
```

## 使用数据库

```sql
use `数据库名` 
```

## 字符集

```sql
create database `名称` character set utf8 collate utf8_general_ci;
```

- `character set utf8`：设定字符集
- `collate utf8_general_ci`：校验字符集


# 操作表

## 数据库数据类型


### 数值

| 类型        | 描述                                             | 字节  |
| ----------- | ------------------------------------------------ | ----- |
| `tinyint`   | 最小的数                                         | 1     |
| `smallint`  | 较小的数                                         | 2     |
| `mediumint` | 中等                                             | 3     |
| `int`       | **标准**                                         | **4** |
| `bigint`    | 较大的                                           | 8     |
| `float`     |                                                  | 4     |
| `double`    |                                                  | 8     |
| `decimal`   | **字符串的浮点数，防止浮点数丢失精度；金融行业** |       |


### 字符串

| 类型       | 描述                                                        | 字节      |
| ---------- | ----------------------------------------------------------- | --------- |
| `char`     | **固定长度字符串，设定的长度全部用完**                      | 0 ~ 255   |
| `varchar`  | **存储变长的字符串，设定的长度只是最大值**                  | 0 ~ 65535 |
| `tinytext` | 微型文本串，不能指定默认长度                                | 0 ~ 255   |
| `text`     | **文本串，存储可变长度的非Unicode数据，不能指定默认长度。** | 0 ~ 65535 |

### 日期

| 类型        | 格式                     | 描述             |
| ----------- | ------------------------ | ---------------- |
| `date`      | YYYY-MM-DD               | 年月日           |
| `time`      | hh:mm:ss                 | 时分秒           |
| `datetime`  | **YYYY-MM-DD hh:mm:ss**  | **年月日时分秒** |
| `timestamp` | **1970.1.1到现在的毫秒** | **时间戳**       |
| `year`      |                          | 年               |

### null

> [!note|style:flat]
> - **不要使用`null`进行算数运算**
> - **字符串的空为`''`，并非`null`**

## 类型的属性

| 字段       | 作用                                                                                                              | 注意                                                                                                                              |
| ---------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `unsigned` | 无符号整型                                                                                                        | **不能为负数**                                                                                                                    |
| `zerofill` | 未使用的字节，根据`length`进行`0`填充                                                                             |                                                                                                                                   |
| `Auto Inc` | 自增，在上一条记录上加一                                                                                          | 1. **用来设计唯一的主键** <br> 2. **必须为整数**  <br> 3. **可以设定初始值、步长** <br> 3. 超过类型最大值时，设置为最大值，并报错 |
| `not null` | 1. 勾选，不给对应元素复制，就会报错 <br>  2. 不选，不填值默认为`null`                                             |                                                                                                                                   |
| `default`  | 设置默认值                                                                                                        |                                                                                                                                   |
| `length`   | 1.数值，**显示的长度**`0001` <br>                                                 2.`char,varchar`,**字符的长度** |                                                                                                                                   |

## 表的列名(正式项目用)

| 列名         | 作用                                                   |
| ------------ | ------------------------------------------------------ |
| `id`         | 主键                                                   |
| `version`    | 乐观锁                                                 |
| `is_delete`  | 伪删除，只是标记数据被删除，但是数组仍然储存在数据库中 |  |
| `gmt_create` | 创建时间                                               |
| `gmt_update` | 修改时间                                               |


## 表的类型

| 项目     | 描述                       | `MYISAM` | `INNODB`           |
| -------- | -------------------------- | -------- | ------------------ |
| 事务     |                            | 不支持   | 支持               |
| 行锁定   | 多用户，可对行操作进行锁定 | 不支持   | 支持               |
| 外键约束 |                            | 不支持   | 支持               |
| 全文索引 |                            | 支持     | 不支持             |
| 储存空间 |                            | 较小     | 约为`MYISAM`的两倍 |

**物理空间储存：**

- **表都存储在指定数据库的文件夹下**
- `INNODB` **两个文件**
  - `.frm`: 存储表的结构信息，在数据库文件夹下
  - `ibdata1`: **存储数据，与数据库文件夹同级**
- `MYISAM` **三个文件**
  - `.frm`: 存储表的结构信息
  - `.MYD`：存储数据
  - `.MYI`：存储索引

## 创建表

```sql
create table [if not exists] `表明`(
    `列名` 类型(length) [属性] [索引] [注释],
        ....
    `列名` 类型(length) [属性] [索引] [注释],
    primary key (`列名`)
)[表类型] [字符集] [注释];
```

<!--sec data-title="案例代码" data-id="create_table" data-show=true data-collapse=true ces-->

```sql
CREATE table if not exists `student`(
    `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '学号',
    `name` VARCHAR(10) NOT NULL DEFAULT '李华' COMMENT '名字',
    `sex` VARCHAR(2) NOT NULL DEFAULT '男' COMMENT '性别',
    `number` VARCHAR(11) NOT NULL DEFAULT '10086' COMMENT '电话',
    PRIMARY KEY(`id`) 
)engine=InnoDB charset=utf8 COMMENT='学生';
```
<!--endsec-->


> [!note|style:flat]
> **给定了`not null`属性后，就不能再设置`default null`。**

## 查看表

### 查看表的列结构

```sql
describe `表名`;
```

### 查看表的创建代码

```sql
show create table `表名`;
```

## 修改表

### 修改表名

```sql
alter table `表名` rename as `新表名`;
```
### 增加字段（列）

```sql
alter table `表名` add `列名` 类型名(length) [属性] [索引] [注释];
```

### 修改字段（列）

**修改类型，约束（列属性）：**

```sql
alter table `表名` modify `列名` [类型，约束];
```

**可以重命名，修改类型，约束：**

```sql
alter table `表名` change `列名` `新列名` [类型，约束];
```

> [!note|style:flat]
> **重新修改字段，`[类型，约束]`也会跟着以前修改掉，不指定就没有。**

### 删除字段

```sql
alter table `表名` drop `列名`;
```

## 删除表

```sql
drop table [if exists] `表名`;
```