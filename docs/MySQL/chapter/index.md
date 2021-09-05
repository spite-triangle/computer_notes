
 <h1 style="font-size:60px;text-align:center;">索引</h1>
 
# 索引简介

> [!note]
> **作用：快速提升`MySQL`获取数据的速度。**
> **效果：小数据的时候用处不大，大数据时效果十分明显。**

# 索引分类

> [!tip]
> - `primary key()`：主键索引
>   - 唯一标识，主键不可重复
>   - 一张表最多只能有一个主键
> - `unique key()`：唯一索引
>   - 同一字段的数据不课重复 
>   - 一张表可以可以表示多个字段
> - `key/index`：常规索引
>   - 默认的常规索引
> - `fullText`：全文索引
>   - 只有特定数据库类型支持(`MYISAM`)
>   - 快速定位数据

# 索引指令

## 显示表中所有的索引

```sql
show index from `表名`;
```

## 索引的创建

### 创建表时

```sql
create table `表名`(
    字段。。。
    primary key (`字段`),
    unique key `索引名`(`字段名`),
    key `索引名` (`字段名`),
    fullText key `索引名` (`字段名`)
)engine=INNODB charset=utf8;
```

### 已经创建好的表

```sql
alter table `表名` add unique key `索引名` (`字段名`);
alter table `表名` add key `索引名` (`字段名`);
alter table `表名` add fulltext key `索引名` (`字段名`);
```

```sql
create 类型 index 索引名 on `表名`(`字段`);
```

## 分析`explain`

**作用：分析`select`查询语句使用情况。**

```sql
explain select 查询语句;
```

# 索引原则

> [!note|style:flat]
> 1. **索引不是越多越好**
> 1. **不需要对经常变动的数据添加索引**
> 1. **小数据不需要索引**
> 1. **索引添加到需要经常查询的字段上**

