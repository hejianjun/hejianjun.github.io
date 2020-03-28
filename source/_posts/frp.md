---
title: frp
date: 2020-03-27 10:08:39
tags:内网穿透,远程桌面
typora-root-url: ..
---

​	公司使用NAT协议，所以远程一直靠TeamViewer，然后TeamViewer给我们公司发了律师函，有天逛github无意间发现frp这个“神器”，本着互联网精神，给大家共享一下（被公司网管或者ZF的BM部门抓到可不关我的事）。

# 通过 RDP 访问公司内网机器

### 准备工作

1. 你有一个外网服务器（腾讯云啊，阿里云啊，搞活动的时候99一年，一人购买多人收益）

2. win10专业版或者企业版（实测家庭版不行）

### 操作步骤

1. 设置个开机密码（不要设置简单密码，不然电脑中毒别怪我没警告你）

   ![win10设置开机密码](/images/win10setpassword.png)

2. 右击“此电脑”，点击“属性”，选择“远程设置”，勾选“允许远程协助连接这台计算机”和“允许远程连接到此计算机”

![rdp1](/images/rdp1.png)

![rdp2](/images/rdp2.png)

3. 右键网络图标，选择“打开网络和Internet设置”，选择“windows防火墙”,“允许应用通过防火墙”，勾选“远程桌面“

![firewall1](/images/firewall1.png)

![firewall2](/images/firewall2.png)

4. 在github下载frp并上传到外网服务器，https://github.com/fatedier/frp/releases
5. 修改 frps.ini 文件，这里使用了最简化的配置：

```
# frps.ini
[common]
bind_port = 7000
```

5. 在外网服务器上启动frps

   ./frps -c ./frps.ini

6. 修改需要远程电脑的 frpc.ini 文件，假设 frps 所在服务器的公网 IP 为 x.x.x.x；

```
# frpc.ini
[common]
server_addr = x.x.x.x
server_port = 7000

[rdp]
type = tcp
local_ip = 127.0.0.1
local_port = 3389
remote_port = 6556
```

7. 在被远程的机器上启动 frpc：

```
./frpc -c ./frpc.ini
```

8. 现在你可以使用x.x.x.x:6556来远程你的机器了

   

![image-20200328130645691](/images/rdp3.png)