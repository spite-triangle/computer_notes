# 1. `Linux` 简介

## 1.1. `Linux` 系统结构

参考博客：
- [用户空间和内核空间的区别](https://zhuanlan.zhihu.com/p/343597285)

<p style="text-align:center;"><img src="../../image/linux/linuxStructure.png" align="middle" /></p>

<span style="font-size:24px;font-weight:bold" class="section2">`Linux`系结结构:</span>

- **用户空间(User Space)** ：用户空间又包括用户的应用程序`(User Applications)`、C 库`(C Library)` 
- **内核空间(Kernel Space)** ：内核空间又包括系统调用接口`(System Call Interface)`、内核`(Kernel)`、平台架构相关的代码`(Architecture-Dependent Kernel Code) `。

**原因：**

- 现代 `CPU` 实现了不同的工作模式，不同模式下 `CPU` 可以执行的指令和访问的寄存器不同。
- `Linux` 从 `CPU` 的角度出发，为了保护内核的安全，把系统分成了两部分，防止用户程序不稳定把系统给搞崩溃。


<span style="font-size:24px;font-weight:bold" class="section2">进程、内存：</span>


- **内存分配**：根据结构上的区分，内存被分为了两大块，两个空间有着各自的内存区域。
- **内核态: 当进程/线程运行在「内核空间」时就处于「内核态」。**
  -  `CPU `可以执行任何指令
  -  代码不受任何的限制，可以自由地访问任何有效地址
  -  代码也可以直接进行端口的访问
- **用户态: 当进程/线程运行在「用户空间」时则处于「用户态」。**
  - 代码执行要受到 `CPU `的很多检查
  - 访问内存地址受限制，比如：进程只能访问映射其地址空间的页表项中规定的在用户态下可访问页面的虚拟地址。
- <span style="color:red;font-weight:bold"> 所有系统资源的管理都是在「内核态」执行。 </span>

<span style="font-size:24px;font-weight:bold" class="section2">用户态切换到内核态</span>

**原因：**

所有系统资源的管理通过内核态完成，那我们应用程序需要访问磁盘，读取网卡的数据，新建一个线程都需要从「用户态」切换到「内存态」。

**方式：**
- **系统调用:** 通过对系统提供的`API`接口函数进行调用，完成从「用户态」切换到「内存态」。
- **中断：** 利用软中断`init 6`，用户可以进行系统重启。
  - **硬中断：** 外部硬件状态发生改变所引起的中断；例如，插入一个u盘，网卡收到数据包的时候
  - **软中断：** 由当前进程所触发的中断；例如，`init 6`


| 类型   | 触发     | CPU            | 时间             | 案例             |
| ------ | -------- | -------------- | ---------------- | ---------------- |
| 硬中断 | 硬件触发 | 马上中断处理   | 较短时间内完成   | 插入一个u盘      |
| 软中断 | 进程触发 | 不一定马上运行 | 处理时间相对较长 | `init 6`重启系统 |

> [!tip|style:flat]
> **扩展：根据`CPU`运行情况，可以把「中断」分为「外中断」与「内中断」，执行逻辑顺序一样。**
> - **中断（外中断）**：「外中断」就是通常所述的「中断」，由`CPU`外部事件所触发的。
> - **异常（内中断）**：`CPU`内部程序运行，**指令执行出错**，把程序玩崩溃了。
> 
> 参考博客：[中断与异常的区别](https://blog.csdn.net/qq_29996285/article/details/88078939)

## 1.2. `init`进程


**`linux`系统启动后，第一个被创建的「用户态」进程就是`init`进程。** 
1. 执行系统初始化脚本，创建一系列的进程（它们都是`init`进程的子孙）；
1. 在一个死循环中等待其子进程的退出事件，并调用`waitid`用来完成「收尸」工作；
1. `init`进程不会被暂停
1. `PID`永远为`1`


```term
triangle@LEARN_FUCK:~$ pstree
init─┬─init───bash───pstree
     └─{init}
```



# 2. 运行级别

## 2.1. 7大运行级别

> [!tip]
> - `0`：系统停机 
> - `1`：单用户工作状态，root权限，用于系统维护，禁止远程登陆 
> - `2`：多用户状态(没有NFS) 
> - `3`：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式 
> - `4`：系统未使用，保留 
> - `5`：X11控制台，桌面模式 
> - `6`：系统正常关闭并重启

```term
triangle@LEARN_FUCK:~$ init 运行级别号
triangle@LEARN_FUCK:~$ runlevel # 当前运行级别
5
```

## 2.2. service


# 3. 文件
参考博客：
- [Linux下七种文件类型、文件属性及其查看方法](https://blog.csdn.net/rong09_13/article/details/79233956)
- [深入理解linux i节点(inode)](https://blog.csdn.net/feiyinzilgd/article/details/5609157)
- [目录文件](https://zhidao.baidu.com/question/488568249980342132.html#:~:text=%E5%9C%A8Linux%E4%B8%8B%E4%B8%80%E5%88%87%E7%9A%86%E6%96%87%E4%BB%B6%EF%BC%8C%E5%9B%A0%E6%AD%A4%E7%9B%AE%E5%BD%95%E4%B9%9F%E6%98%AF%E6%96%87%E4%BB%B6%E3%80%82%20%E6%89%80%E4%BB%A5%EF%BC%8C%E9%80%9A%E8%BF%87%20ls%20-al%20%E5%91%BD%E4%BB%A4%E6%98%BE%E7%A4%BA%E7%9A%84%E7%9B%AE%E5%BD%95%E5%A4%A7%E5%B0%8F%E5%B9%B6%E9%9D%9E%E5%B8%B8%E8%A7%84%E6%84%8F%E4%B9%89%E4%B8%8A%E5%8C%85%E5%90%AB%E5%85%B6%E5%AD%90%E6%96%87%E4%BB%B6%E7%9A%84%E6%80%BB%E5%A4%A7%E5%B0%8F%EF%BC%8C%E8%80%8C%E6%98%AF%E5%8D%95%E7%BA%AF%E6%8C%87%E7%9A%84%E6%98%AF%E7%9B%AE%E5%BD%95%E7%9A%84%E5%A4%A7%E5%B0%8F%E3%80%82,%E8%BF%99%E4%B8%80%E7%82%B9%E5%92%8CWindows%E5%B9%B6%E4%B8%8D%E4%B8%80%E6%A0%B7%E3%80%82%20%E8%AF%B7%E6%B3%A8%E6%84%8F%E4%B8%80%E7%82%B9%EF%BC%8C%E5%85%B6%E5%AE%9ELinux%E4%B8%8B%E7%9B%AE%E5%BD%95%E7%9A%84%E5%A4%A7%E5%B0%8F%E5%B9%B6%E4%B8%8D%E9%83%BD%E6%98%AF4096%E7%9A%84%E3%80%82%20%E9%82%A3%E4%B9%88%E4%B8%BA%E4%BB%80%E4%B9%88%E5%A4%A7%E9%83%A8%E5%88%86%E7%9A%84%E7%9B%AE%E5%BD%95%E5%A4%A7%E5%B0%8F%E9%83%BD%E6%98%AF4096%E5%91%A2%EF%BC%9F%20%E8%BF%99%E9%9C%80%E8%A6%81%E4%BB%8ELinux%E6%96%87%E4%BB%B6%E7%9A%84%E5%AD%98%E5%82%A8%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E%E3%80%82%20%E6%96%87%E4%BB%B6%E5%82%A8%E5%AD%98%E5%9C%A8%E7%A1%AC%E7%9B%98%E4%B8%8A%EF%BC%8C%E7%A1%AC%E7%9B%98%E7%9A%84%E6%9C%80%E5%B0%8F%E5%AD%98%E5%82%A8%E5%8D%95%E4%BD%8D%E5%8F%AB%E5%81%9A%E2%80%9C%E6%89%87%E5%8C%BA%E2%80%9D%EF%BC%88Sector%EF%BC%89%E3%80%82%20%E6%AF%8F%E4%B8%AA%E6%89%87%E5%8C%BA%E5%82%A8%E5%AD%98512%E5%AD%97%E8%8A%82%EF%BC%88%E7%9B%B8%E5%BD%93%E4%BA%8E0.5KB%EF%BC%89%E3%80%82)

## 3.1. 概念

> [!warning|style:flat]
> **在`Linux`系统中，一切皆是文件。**

## 3.2. 文件属性

<p style="text-align:center;"><img src="../../image/linux/file.png" align="middle" /></p>

```term
triangle@LEARN_FUCK:~$  ls -ila
total 0
3377699720545409 drwxrwxrwx 1 triangle triangle 4096 Sep 10 19:54 .
1970324836981980 drwxrwxrwx 1 triangle triangle 4096 Sep  1 19:34 ..
 281474976816981 lrwxrwxrwx 1 triangle triangle   10 Sep 10 19:52 link1 -> salary.txt
1407374883659532 -rwxrwxrwx 3 triangle triangle   55 Sep 10 12:59 linkd1
1407374883659532 -rwxrwxrwx 3 triangle triangle   55 Sep 10 12:59 linkd2
1407374883659532 -rwxrwxrwx 3 triangle triangle   55 Sep 10 12:59 salary.txt
 844424930238223 drwxrwxrwx 1 triangle triangle 4096 Sep  9 22:26 test
```

## 3.3. 七种文件类型

- **普通文件类型:`-`** 
    
   - `Linux`中最多的一种文件类型, 包括 纯文本文件`(ASCII)`；二进制文件`(binary)`；数据格式的文件`(data)`;各种压缩文件

- **目录文件:`d`**

   - 就是文件夹

- **块设备文件:`b`**

    - 就是存储数据以供系统存取的接口设备，简单而言就是「硬盘」。例如一号硬盘的代码是 `/dev/hda1` 等文件。

- **字符设备:`c`**

    - 串行端口的接口设备，例如键盘、鼠标等等。

- **套接字文件:`s`**

    - 这类文件通常用在网络数据连接。可以启动一个程序来监听客户端的要求，客户端就可以通过套接字来进行数据通信。最常在` /var/run`目录中看到这种文件类型

- **管道文件:`p`**

    - `FIFO`也是一种特殊的文件类型，它主要的目的是进程间通讯。

- **链接文件:`l`**

    - 类似`Windows`下面的快捷方式。

## 3.4. 文件权限
- 文件的访问对象分为: **u用户，g组，o其他** ;
- 文件的访问权限分为: **r，w，x 对应二进制 111** 

```term
triangle@LEARN_FUCK:~$ ls -laF
drwxrwxrwx 1 triangle triangle 4096 Sep 10 14:18 ./
drwxrwxrwx 1 triangle triangle 4096 Sep  1 19:34 ../
-rwxrwxrwx 1 triangle triangle   55 Sep 10 12:59 salary.txt*
drwxrwxrwx 1 triangle triangle 4096 Sep  9 22:26 test/
-rwxrwxrwx 1 triangle triangle   75 Sep 10 12:19 test.txt*
```

## 3.5. 文件时间戳

> [!note]
> - 访问时间 `(acces)` （`-atime` 天，`-amin` 分钟）：文件被查看的时间，用户最近一次访问时间。
> - 修改时间 `(modify)`（`-mtime` 天，`-mmin` 分钟）：「内容数据」被修改的最后一次修改时间。
> - 变化时间 `(change)`（`-ctime` 天，`-cmin` 分钟）：状态时间，当文件的状态即文件的属性被改变是就会更改这个时间，例如文件系统中的`links`(链接数)，`size`(文件的大小)、文件的权限、`blocks`(文件的`block`数)；

```term
triangle@LEARN_FUCK:~$ stat command.md

File: command.md
Size: 1258            Blocks: 8          IO Block: 4096   regular file
Device: 11h/17d Inode: 562949953511263  Links: 1
Access: (0777/-rwxrwxrwx)  Uid: ( 1000/triangle)   Gid: ( 1000/triangle)
Access: 2021-09-08 10:21:03.394365400 +0800
Modify: 2021-09-08 10:11:44.128382200 +0800
Change: 2021-09-08 10:11:44.128382200 +0800
 Birth: -
```

## 3.6. 目录的结构

**硬盘内存的划分：**
1. **导引块**: 加载硬盘数据用的程序
1. **专用块**: 磁盘相关信息，例如，磁盘大小。
1. **`i`节点表块**: 存储所有的`i`节点
1. **数据存储块**: 文件数据

**目录**
- **目录: 包含「一组目录项」的「文件」**
- **目录项: 由「文件名」与「i节点索引」**
- **i节点**: 指向该文件在硬盘上的「数据存储块」，还包含了很多信息，文件的创建者、文件的创建日期、文件的大小等等，**唯独不记录文件名**。
- **文件：每一个文件都对应着一个「i节点」** 

<p style="text-align:center;"><img src="../../image/linux/contentItem.png" align="middle" /></p>

> [!note|style:flat]
> <span style="color:red;font-weight:bold"> 对于`linux`而言默认的一个`block`为`4096`个字节，对应硬盘`8`个扇区。由于「文件夹」其实就是「目录」，即也是存储在硬盘上的一个「文件」，默认分配大小就是一个`block`，所以一个「文件夹」会显示大小为`4096` </span>

```term
triangle@LEARN_FUCK:~$ ll | grep '^d'
drwxrwxrwx 1 triangle triangle 4096 Sep 10 18:43 ./
drwxrwxrwx 1 triangle triangle 4096 Sep  1 19:34 ../
drwxrwxrwx 1 triangle triangle 4096 Sep  9 22:26 test/
drwxrwxrwx 1 triangle triangle 4096 Sep 10 14:16 testTar/
```


<span style="font-size:24px;font-weight:bold" class="section2">链接</span>

<p style="text-align:center;"><img src="../../image/linux/ln.png" align="middle" /></p>

> [!tip]
> - **硬链接**: 多个「目录项」绑定到了同一片「数据储存块」（也就是同一文件）；「硬链接」会使得「链接计数器」增加，计数器表示了当前文件被多少个文件绑定，当计数器为`0`时，该文件才能真正被删除。
> - **符号链接**: 是一个包含「i结点」路径的一个索引。

```term
triangle@LEARN_FUCK:~$ ln -s salary.txt  link1
triangle@LEARN_FUCK:~$ ll | grep '^l' # 后面跟着符号链接指向文件的路径
lrwxrwxrwx 1 triangle triangle   10 Sep 10 19:52 link1 -> salary.txt*
triangle@LEARN_FUCK:~$
triangle@LEARN_FUCK:~$ ln -d salary.txt linkd1
triangle@LEARN_FUCK:~$ ln -d salary.txt linkd2
triangle@LEARN_FUCK:~$ stat salary.txt # links 链接数为 3 
  File: salary.txt
  Size: 55              Blocks: 0          IO Block: 4096   regular file
Device: 11h/17d Inode: 1407374883659532  Links: 3
Access: (0777/-rwxrwxrwx)  Uid: ( 1000/triangle)   Gid: ( 1000/triangle)
Access: 2021-09-10 14:25:20.283459400 +0800
Modify: 2021-09-10 12:59:27.000000000 +0800
Change: 2021-09-10 19:54:34.610528800 +0800
 Birth: -
triangle@LEARN_FUCK:~$ ll | grep -E  'linkd|salary'
lrwxrwxrwx 1 triangle triangle   10 Sep 10 19:52 link1 -> salary.txt*
-rwxrwxrwx 3 triangle triangle   55 Sep 10 12:59 linkd1*
-rwxrwxrwx 3 triangle triangle   55 Sep 10 12:59 linkd2*
-rwxrwxrwx 3 triangle triangle   55 Sep 10 12:59 salary.txt*
```

# 4. 环境变量

参考博客：
- [超详干货！Linux 环境变量配置全攻略](https://zhuanlan.zhihu.com/p/317282094)

## 4.1. 定义

> [!tip]
> **在 `Linux` 系统中，「环境变量」是用来定义系统运行环境的一些参数，比如每个用户不同的家目录`（HOME）`、邮件存放位置`（MAIL）`等。**

| 变量         | 描述                                   |
| ------------ | -------------------------------------- |
| HOME         | 用户的主目录（也称家目录）             |
| SHELL        | 用户使用的 Shell 解释器名称            |
| PATH         | 定义命令行解释器搜索用户执行命令的路径 |
| EDITOR       | 用户默认的文本解释器                   |
| RANDOM       | 生成一个随机数字                       |
| LANG         | 系统语言、语系名称                     |
| HISTSIZE     | 输出的历史命令记录条数                 |
| HISTFILESIZE | 保存的历史命令记录条数                 |
| PS1          | Bash解释器的提示符                     |
| MAIL         | 邮件保存路径                           |

## 4.2. 查看


> [!warning|style:flat]
> <span style="color:red;font-weight:bold"> `¥` 是 `dollor`英文符号 </span>

```term
triangle@LEARN_FUCK:~$ env # 查看全部
...
HOSTTYPE=x86_64
LESSCLOSE=/usr/bin/lesspipe %s %s
WT_SESSION=d4b9b3a0-7112-4e08-a3ac-5062b7740ec5
LANG=C.UTF-8
WSL_DISTRO_NAME=Ubuntu-18.04
USER=triangle
PWD=/mnt/f/workPlace/linux
HOME=/home/triangle
NAME=DESKTOP-RDTVBUO
XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
SHELL=/bin/bash
TERM=xterm-256color
SHLVL=1
LOGNAME=triangle
...
triangle@LEARN_FUCK:~$ export # 查看全部
....
declare -x PWD="/mnt/f/workPlace/linux"
declare -x SHELL="/bin/bash"
declare -x SHLVL="1"
declare -x TERM="xterm-256color"
declare -x USER="triangle"
declare -x WSLENV="WT_SESSION::WT_PROFILE_ID"
declare -x WSL_DISTRO_NAME="Ubuntu-18.04"
declare -x WT_PROFILE_ID="{c6eaf9f4-32a7-5fdc-b5cf-066e8a4b1e40}"
declare -x WT_SESSION="d4b9b3a0-7112-4e08-a3ac-5062b7740ec5"
....
triangle@LEARN_FUCK:~$ echo ¥USER # 查看指定
triangle
```

## 4.3. 创建

<span style="font-size:24px;font-weight:bold" class="section2">终端直接定义变量</span>

> [!warning|style:flat]
> <span style="color:red;font-weight:bold"> `¥` 是 `dollor`英语符号 </span>


```term
triangle@LEARN_FUCK:~$ FUCK='hellow world'
triangle@LEARN_FUCK:~$ echo ¥FUCK
hellow world
```

> [!tip]
> - **生效时间**: 立即生效
> - **生效期限**: 当前终端用户，**切换用户后失效**
> - **生效范围**：仅对当前用户有效

<span style="font-size:24px;font-weight:bold" class="section2">终端`export`定义变量</span>

> [!warning|style:flat]
> <span style="color:red;font-weight:bold"> `¥` 是 `dollor`英文符号 </span>


```term
triangle@LEARN_FUCK:~$ export FUCK='hellow world'
triangle@LEARN_FUCK:~$ echo ¥FUCK
hellow world
triangle@LEARN_FUCK:~$ su
root@LEARN_FUCK:~$ echo ¥FUCK
hellow world
```

> [!tip]
> - **生效时间**: 立即生效
> - **生效期限**: 当前终端，**重启终端失效**
> - **生效范围**：**所有用户**


<span style="font-size:24px;font-weight:bold" class="section2"> 在`~/.bashrc` 添加 </span>


> [!tip]
> - **生效时间**: 重启终端，或者`source ~/.bashrc`
> - **生效期限**: 永久有效
> - **生效范围：仅对当前用户有效**

<span style="font-size:24px;font-weight:bold" class="section2"> 在`/etc/environment` 添加 </span>

```term
triangle@LEARN_FUCK:~$ cat /etc/environment
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
```

> [!tip]
> - **生效时间**: 重启终端，或者`source ~/.bashrc`
> - **生效期限**: 永久有效
> - **生效范围：对所有用户有效**



# 5. `crontab`定时

## 5.1. 简介


**作用：可以用来让系统定时调用某个指令。**
**原理：Linux下的任务调度分为两类：系统任务调度和用户任务调度。`Linux`系统任务是由 `cron (crond)` 这个系统服务来控制的，这个系统服务是默认启动的。**
**注意：`crondtab`配置会每分钟刷新一次。**

<p style="text-align:center;"><img src="../../image/linux/crontab_struction.jpg" align="middle" /></p>

## 5.2. 配置

<span style="font-size:24px;font-weight:bold" class="section2">配置文件</span>

```term
triangle@LEARN_FUCK:~$  cat /etc/crontab

# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

# crond任务运行的环境变量
SHELL=/bin/sh # 系统要使用哪个shell
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin # 系统执行命令的路径

# 定时命令配置
# m h dom mon dow user  command
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
```

<span style="font-size:24px;font-weight:bold" class="section2">配置设置</span>

<p style="text-align:center;"><img src="../../image/linux/crontab.png" align="middle" /></p>

> [!tip|style:flat]
> - `*`：取值范围内的所有值
> - `/`：一定时间间隔，如分钟字段为`*/10`，表示每`10`分钟执行`1`次
> - `-`：某个区间范围，如`a - b`表示`[a,b]`
> - `,`：分散的时间安排，如`1,3,4`

> [!tip|style:flat]
> **指令配置时，最好写成绝对路径。**

**参考博客：[crontab用法与实例](https://www.linuxprobe.com/how-to-crontab.html)**

<span style="font-size:24px;font-weight:bold" class="section2">配置文件编辑</span>

```term
triangle@LEARN_FUCK:~$ vim /etc/crontab
triangle@LEARN_FUCK:~$ crontab -e
```

# 6. 挂载

> [!tip]
> **`fs`表示`file system`**

```term
triangle@LEARN_FUCK:~$  cat /etc/fstab

# This file is edited by fstab-sync - see 'man fstab-sync' for details

# Device                Mount point        filesystem   parameters  dump fsck

LABEL=/                 /                       ext3    defaults        1 1

LABEL=/boot             /boot                   ext3    defaults        1 2

none                    /dev/pts                devpts  gid=5,mode=620  0 0

none                    /dev/shm                tmpfs   defaults        0 0

none                    /proc                   proc    defaults        0 0

none                    /sys                    sysfs   defaults        0 0

LABEL=SWAP-sda3         swap                    swap    defaults        0 0

/dev/sdb1               /u01                    ext3    defaults        1 2

UUID=18823fc1-2958-49a0-9f1e-e1316bd5c2c5       /u02    ext3    defaults        1 2

/dev/hdc                /media/cdrom1           auto    pamconsole,exec,noauto,managed 0 0

/dev/fd0                /media/floppy           auto    pamconsole,exec,noauto,managed 0 0
```


**当系统启动的时候，会自动将此文件中指定的文件系统挂载到指定的目录。**
- `Device` 要挂载的分区或存储设备
- `Mount point` 挂载点
- `filesystem` 要挂载设备或是分区的文件系统类型;`auto`类型自动搜索，用于cd，DVD
- `parameters` 挂载参数
- `dump dump` （0表示不进行dump备份，1代表每天进行dump备份，2代表不定日期的进行dump备份）
- `pass fsck`检测顺序 （其实是一个检查顺序，0代表不检查，1代表第一个检查，2后续.一般根目录是1，数字相同则同时检查）