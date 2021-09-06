
 <h1 style="font-size:60px;text-align:center;">控制台操作</h1>

# 1. 连接数据库

```term
triangle@LEARN_FUCK:~/mysql$ mysql -u root -p 
```

# 2. 退出连接

```term
mysql>$ exit; 
```

# 3. 修改密码

```sql
update mysql.user set authentication_string=password('新密码') where user='用户名' and Host ='localhost';
```

# 4. 刷新权限

```term
mysql>$  flush privileges;
```

# 5. 创建数据库

```term
mysql>$ create database [数据库名]; 
```

# 6. 删除数据库

```term
mysql>$ drop database [数据库名];
```

# 7. 显示所有数据库

```term
mysql>$ show DATABASES;
```

# 8. 切换数据库

```term
mysql>$ use [数据库名称]
Database changed
```
# 9. 查看数据库中所有的表

<span style="color:blue;font-weight:bold"> 先选中一个数据库，然后才能查看所选中的数据库中的表。 </span>


```term
mysql>$ show tables;
```

# 10. 查看一个表中的内容

```term
mysql>$ describe [表名]; 
```




