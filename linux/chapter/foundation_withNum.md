# 1. 文件时间戳

> [!note]
> - 访问时间 (acces) （`-atime` 天，`-amin` 分钟）：文件被查看的时间，用户最近一次访问时间。
> - 修改时间 (modify)（`-mtime` 天，`-mmin` 分钟）：「内容数据」被修改的最后一次修改时间。
> - 变化时间 (change)（`-ctime` 天，`-cmin` 分钟）：状态时间，当文件的状态即文件的属性被改变是就会更改这个时间，例如文件系统中的links(链接数)，size(文件的大小)、文件的权限、blocks(文件的block数)；

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
# 2. `crontab`定时

## 2.1. 简介

> [!note]
> **作用：可以用来让系统定时调用某个指令。**
> **原理：Linux下的任务调度分为两类：系统任务调度和用户任务调度。`Linux`系统任务是由 `cron (crond)` 这个系统服务来控制的，这个系统服务是默认启动的。**
> **注意：`crondtab`配置会每分钟刷新一次。**

<p style="text-align:center;"><img src="../../image/linux/crontab_struction.jpg" align="middle" /></p>

## 2.2. 配置

<span style="font-size:24px;font-weight:bold" class="section2">配置文件</span>

```term
triangle@LEARN_FUCK:~$  cat /etc/crontab
/*
* /etc/crontab: system-wide crontab
* Unlike any other crontab you don't have to run the `crontab'
* command to install the new version when you edit this file
* and files in /etc/cron.d. These files also have username fields,
* that none of the other crontabs do.
*/

// crond任务运行的环境变量
SHELL=/bin/sh # 系统要使用哪个shell
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin # 系统执行命令的路径

// 定时命令配置
// m h dom mon dow user  command
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

**参考博客：[crontab用法与实例](https://www.linuxprobe.com/how-to-crontab.html)**

<span style="font-size:24px;font-weight:bold" class="section2">配置文件编辑</span>

```term
triangle@LEARN_FUCK:~$ vim /etc/crontab
triangle@LEARN_FUCK:~$ crontab -e
```

# 3. 挂载

> [!tip]
> **`fs`表示`file system`**

```term
triangle@LEARN_FUCK:~$  cat /etc/fstab

// This file is edited by fstab-sync - see 'man fstab-sync' for details

// Device                Mount point        filesystem   parameters  dump fsck

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

> [!tip]
> **当系统启动的时候，会自动将此文件中指定的文件系统挂载到指定的目录。**
> - `Device` 要挂载的分区或存储设备
> - `Mount point` 挂载点
> - `filesystem` 要挂载设备或是分区的文件系统类型;`auto`类型自动搜索，用于cd，DVD
> - `parameters` 挂载参数
> - `dump dump` （0表示不进行dump备份，1代表每天进行dump备份，2代表不定日期的进行dump备份）
> - `pass fsck`检测顺序 （其实是一个检查顺序，0代表不检查，1代表第一个检查，2后续.一般根目录是1，数字相同则同时检查）