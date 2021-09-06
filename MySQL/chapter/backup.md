 <h1 style="font-size:60px;text-align:center;">备份</h1>

# 作用

> [!note|style:flat]
> - **防止删库跑路。**
> - **转移数据库**

# 直接拷贝文件

**将硬盘上的数据库文件，直接备份。**

# 命令行

**导出：**

```term
triangle@LEARN_FUCK:~$ mysqldump -h[host] -u[user] -p[password] `数据库` `表1` `表2`> 备份路径/备份文件.sql
```

```term
triangle@LEARN_FUCK:~$ mysqldump -hlocalhost -uroot -p123456 school student > ~/a.sql 
```

**导入：**

```term
mysql>$ use 数据库 # 导入表，先切换数据库
mysql>$ source 路径/a.sql  
```

```term
triangle@LEARN_FUCK:~$mysql -u[user] -p[password] [数据库] < 路径/a.sql 
```
