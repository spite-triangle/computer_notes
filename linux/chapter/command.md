 <h1 style="font-size:60px;text-align:center;">指令</h1>

# 文件目录

## `find`

> [!tip]
> - `-size`: 根据大小查找
>   - `-size +6k`: 大于6k
>   - `-size -10k`: 小于10k
> - `-name`: 根据名字查找
> - `-type`
>   - `d`: 文件夹
>   - `f`: 文件
>   - `l`: 软链接
> - `-empty`：查询空文件

 
<span style="font-size:24px;font-weight:bold" class="section2">忽略大小写</span>

```term
triangle@LEARN_FUCK:~$ find ./ -iname "ReadMe.md"
```

<span style="font-size:24px;font-weight:bold" class="section2">查询到文件然后执行指令</span>

- `{}`：代表`find`所查询到的内容
- `\;`：附加指令的结束标记

```term
triangle@LEARN_FUCK:~$ find ./ -type f -exec python AutoNum.py {} \; 
```

> [!note|style:flat]
> - **`-exec 执行语句` 指令：可以理解为`find`查询到一个目标，然后执行一次，「执行语句」；「执行语句」执行类似`for`循环。**
> - **`| xargs  执行语句`指令：将管道符传入的`stdout`进行「参数化」处理，再塞给后面的「执行语句」；「执行语句」对「参数」批量执行一次。**


<span style="font-size:24px;font-weight:bold" class="section2">时间查询</span>

- **`/var` 目录下找出 `90` 天之内未被访问过的文件**

```term
triangle@LEARN_FUCK:~$ find /var -type f -atime -90
```

- **`/home` 目录下找出 `120` 天之前被修改过的文件**

```term
triangle@LEARN_FUCK:~$ find /home -type f -mtime +120
```

## `ls`

<span style="font-size:24px;font-weight:bold" class="section2">显示文件名</span>

```term
triangle@LEARN_FUCK:~$ ls
chapter  linux.md
```

<span style="font-size:24px;font-weight:bold" class="section2">显示文件名与类型</span>

```term
triangle@LEARN_FUCK:~$ ls -F
chapter/  linux.md*
```

<span style="font-size:24px;font-weight:bold" class="section2">显示完整路径</span>

```term
triangle@LEARN_FUCK:~$ ls -l
total 0
drwxrwxrwx 1 triangle triangle 4096 Sep  7 21:34 chapter
-rwxrwxrwx 1 triangle triangle    0 Sep  7 21:32 linux.md
```

## `mkdir`

```term
triangle@LEARN_FUCK:~$ mkdir -p 路径 # -p：可以创建路径中没有的文件夹
```

## `du`

> [!tip]
> **`du` (disk usage): 查看文件夹和文件的磁盘占用**
> - `h`
> - `a` : 默认只显示文件夹，`a`会显示到具体文件
>   - <font color="#f44336">文件夹的大小 = 目录文件大小 + 文件夹内文件的大小; 数据块的大小</font> 
> - `s （summarize）` : 查看路径对于数据块的总大小
> - `--max-depth=` : 文件夹路径的层级

```term
triangle@LEARN_FUCK:~$ du -h
8.0K    ./chapter
8.0K    .
triangle@LEARN_FUCK:~$ du -ha
4.0K    ./chapter/command.md
4.0K    ./chapter/foundation.md
8.0K    ./chapter
0       ./linux.md
8.0K    
```

## `rm`

> [!tip]
> -`-i`：删除前询问
> -`-f`：强制删除
> -`-r`：递归

```term
triangle@LEARN_FUCK:~$  rm -i linux.md
rm: remove regular file 'linux.md'? n
```

## 查看

|  命令  | 作用                                                   |
| :----: | ------------------------------------------------------ |
| `cat`  | 直接展开全部内容                                       |
| `tail` | 默认显示文件最后的 `10` 行文本                         |
| `more` | 不能向上一行一行翻页，`Ctrl b`能回滚一页               |
| `less` | 在不加载整个文件的前提下显示文件内容，`more`的功能加强 |

<span style="font-size:24px;font-weight:bold" class="section2">添加行号</span>

```term
triangle@LEARN_FUCK:~$ cat -n linux.md
     1  fuck you
     2  linux
     3  love linux
triangle@LEARN_FUCK:~$ cat -n linux.md | less
triangle@LEARN_FUCK:~$ cat -n linux.md | more
```
> [!note|style:flat]
> - `less more`的行号可以通过`cat`添加
> - `more`重定向后，不能回滚

<span style="font-size:24px;font-weight:bold" class="section2">`tail`添加指定行</span>

```term
triangle@LEARN_FUCK:~$ tail -n 3 command.md
> **作用：用于挂载Linux系统外的储存硬件，硬盘，u盘等，挂载到`linux`系统的一个文
件夹上，方便用户查看。**
> - `mount 设备名(就是一文件路径) 挂载点(目标文件夹路径)`：挂载
> - `umount 设备名/挂载点`：卸载已经加载的文件系统
```

# 硬件相关

## `df`

> [!tip]
> **`df （disk free)` : 查看硬盘整体使用情况**
> - `-h` （human）: 会进行单位换算，方便人看
> - `-i` （inode）: 查看i节点

```term
triangle@LEARN_FUCK:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
rootfs          125G   96G   30G  77% /
none            125G   96G   30G  77% /dev
none            125G   96G   30G  77% /run
none            125G   96G   30G  77% /run/lock
none            125G   96G   30G  77% /run/shm
none            125G   96G   30G  77% /run/user
tmpfs           125G   96G   30G  77% /sys/fs/cgroup
C:\             125G   96G   30G  77% /mnt/c
D:\             109G  6.5G  103G   6% /mnt/d
E:\             121G  106G   15G  88% /mnt/e
F:\             121G   97G   24G  81% /mnt/f
G:\             226G  109G  118G  49% /mnt/g
```

## `mount`

> [!tip]
> **作用：用于挂载Linux系统外的储存硬件，硬盘，u盘等，挂载到`linux`系统的一个文件夹上，方便用户查看。**
> - `mount 设备名(就是一文件路径) 挂载点(目标文件夹路径)`：挂载
> - `umount 设备名/挂载点`：卸载已经加载的文件系统

# 数据流处理


