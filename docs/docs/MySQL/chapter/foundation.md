
 <h1 style="font-size:60px;text-align:center;">控制台操作</h1>

# 连接数据库

```term
triangle@LEARN_FUCK:~/mysql$ mysql -u root -p 
```

# 退出连接

```term
mysql>$ exit; 
```

# 修改密码

```sql
update mysql.user set authentication_string=password('新密码') where user='用户名' and Host ='localhost';
```

# 刷新权限

```term
mysql>$  flush privileges;
```

# 创建数据库

```term
mysql>$ create database [数据库名]; 
```

# 删除数据库

```term
mysql>$ drop database [数据库名];
```

# 显示所有数据库

```term
mysql>$ show DATABASES;
```

# 切换数据库

```term
mysql>$ use [数据库名称]
Database changed
```
# 查看数据库中所有的表

==先选中一个数据库，然后才能查看所选中的数据库中的表。==

```term
mysql>$ show tables;
```

# 查看一个表中的内容

```term
mysql>$ describe [表名]; 
```




