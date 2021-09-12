# 模型

<p style="text-align:center;"><img src="../../image/tcp_ip/tcp_protocol.jpg" align="middle" /></p>


**为什么分层：** <span style="color:red;font-weight:bold"> 解耦，不同层就能替换不同内容，而不影响其他流程。 </span>

- **应用层：** 具有`http,smtp,ssh`协议，提供协议内容

- **传输控制层：** `tcp ，udp`协议，创建传输数据包。

- **网络层：** `ip,arp`协议。网络层负责对子网间的数据包进行「路由选择」。

- **链路层：** 将源自网络层来的数据可靠地传输到相邻节点的目标机网络层。物理地址寻址（`mac`）、数据的成帧、流量控制、数据的检错、重发等。

- **物理层：**确保原始的数据可在各种物理媒体上传输

# TCP/UDP

**`UDP`**

「无连接」的，尽最大可能交付，没有拥塞控制，面向报文（对于应用程序传下来的报文不合并也不拆分，只是添加 `UDP` 首部），支持一对一、一对多、多对一和多对多的交互通信。

**`TCP`**

面向「连接」的，提供可靠交付，有流量控制，拥塞控制，提供全双工通信，面向字节流（把应用层传下来的报文看成字节流，把字节流组织成大小不等的数据块），每一条 `TCP` 连接只能是点对点的（一对一）。


# TCP

## 三次握手

<p style="text-align:center;"><img src="../../image/tcp_ip/link.png" align="middle" /></p>

> [!note]
> **三次握手：只是传输层测试用，和用户层没关系**
> 1. C 发送一个 `syn` 给 S
> 1. S 收到后，发送`syn`和`ack`给 C
> 1. C 收到后，发送一个`ack`给 S
> - `syn`: 用作建立连接时的同步信号
> - `ack`: 用于对收到的数据进行确认
>

## 为啥要三次？

**数据传输是双向的，三次握手就能证明双方的收发都是正常的。**
- 1 和 2 ： C 确认的收发通道的正常
- 2 和 3 ： S 确认了收发通道的正常

# 四次分手

<p style="text-align:center;"><img src="../../image/tcp_ip/break.png" align="middle" /></p>


>[!note]
> **四次分手：**
> 1. C 发一个 `fin` 给 S：通知要断开
> 1. S 发 `ack` 给 C：回应一下，不代表同意断开
> 1. 然后 S 开始收尾工作， 可能还有数据没有传输完，C 还是可以接收数据。
> 1. 收尾完毕，S 正式回应一个`fin`：表示可以断开了
> 1. C 回复一个`ack`
> 1. 最后双方开始`close`回收资源。
> - `fin`: 表示后面没有数据需要发送，通常意昧着所建立的连接需要关闭了。

# 为什么四次？

**C 没有数据要发送，请求断开。但这不代表 S 没有数据要发送了，所以 S 先回复一下 C，然后开始首尾工作，把没有传输完的数据传输掉，C 不想发送了，但是还可以接收数据。**
