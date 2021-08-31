
 <h1 style="font-size:60px;text-align:center;">进程与线程</h1>

# 1 进程

## 1.1. 创建

&emsp;&emsp;创建的是原进程的子进程，子进程会复制父进程的PCB(进程控制块)，二者之间代码共享，数据独有，拥有各自的进程虚拟地址空间。

```cpp
#include <unistd.h>
pid_t fork(void);
```
- **写时拷贝技术** 
&emsp;子进程创建后，与父进程映射访问同一块物理内存，当父或子进程对值进行修改时，会给子进程重新在物理内存中开辟一块空间，并将数据拷贝过去。
- **pid_t**: 创建子进程失败，会返回-1; 创建子进程成功，父进程返回pid号，子进程返回0。

## 1.2. 终止

- **正常终止**
    - main函数返回
    - 调用exit函数:  `status` 可以通过 `wait（int *status）` 接收; **会刷新缓冲** 
    ```cpp
    #include <stdlib.h>
    void exit(int status);
    ```
    - 调用_exit函数:  `status` 可以通过 `wait（int *status）` 接收;  **不会刷新缓冲** 
    ```cpp
    #include <unistd.h>
    void _exit(int status);
    ```

- **异常退出**
    -  Ctrl+C
    - 被信号终止

## 1.3. 等待
&emsp;&emsp;如果**子进程先于父进程退出**，而父进程并没有关心子进程的退出状况，从而无法回收子进程的资源，就会导致**子进程变成僵尸进程**。<font color="#4c9df8">**进程等待的作用就是父进程对子进程收尸！父进程通过进程等待的方式，回收子进程的资源，获取子进程的退出状态。**</font>

- `wait `
    ```cpp
    #include <sys/types.h>
    #include <sys/wait.h>
    pid_t wait(int *status);
    ```
    - **利用阻塞，等待子进程退出。**
    - **一次只能等待一个**
    - pid: 成功，子进程的pid; 失败(**没有子进程**)，返回-1; 
    - status: 进程退出信息

- `waitpid`
    ```cpp
    //头文件同wait的头文件
    pid_t waitpid(pid_t pid, int *status, int options);
    ```
    - 返回值:          
         1. 等待成功，返回pid
         1. **options为WNOHANG时，没有等待到子进程，马上退出不阻塞，返回0**
         1. 出错则返回-1
    - pid:         
         1. -1: 随便等待一个进程
         1. pid号: 明确指定一个进程等待
    - options:
        1. 0: **阻塞等待**，等待到一个就退出
        1. WNOHANG: 没有等待到子进程，马上退出不阻塞，返回0

## 1.4. 进程退出信息status

-  **低16位存放信息，高16位不用** 
-  **高8位** : 退出码， `exit` 的传入值或者 `return` 值
    ```cpp
    (status >> 8) & 0xFF;
    ```
-  **低8位** : 异常退出信息
    - 第7位: core dump标志位;0，不产生;1，产生
    ```cpp
    (status >> 7) & 0x1;
    ```

    - 低7位: 子进程是否异常退出;0，正常;非0，终止的信号

    ```cpp
    status & 0x7F;
    ```

# 2 进程状态
- **R (running)**: PCB被放入CPU的可执行队列中;CPU上执行的RUNNING状态、而将可执行但是尚未被调度执行的READY状态
- **S (sleeping)**: 睡眠状态，PCB被放入等待队列，可以通过中断唤醒。
- **D (disk sleep)**:睡眠状态，不能中断被唤醒。**内核的某些处理流程是不能被打断的。用来保护进程。**
- **T (stopped)**: SIGSTOP信号让进程进入暂停，SIGCONT信号能将进程恢复。
- **t (tracing stop)**: 在被追踪时，进程暂停;典型应用就是 **gdb断点** 。调试进程退出，被调试的进程才能恢复TASK_RUNNING状态。
- **Z (zombie)**: 进程退出后，PCB没有被回收。<font color="#f44336">父进程没有对子进程收尸，就只能等父进程退出后，让爷进程来统一收尸。</font>
- **X (dead)**: 马上会被彻底销毁

# 3 进程状态变化

- <font color="#4c9df8"> `R`变非`R`状态。 </font>
- <font color="#4c9df8"> 非`R`变`R`状态 </font>
