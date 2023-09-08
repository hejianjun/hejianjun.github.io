---
title: thingsboard
date: 2023-09-07 21:35:55
tags: thingsboard
categories:
  - technology
  - thingsboard
typora-root-url: ..
---

## **1 安装**

源码地址：https://github.com/thingsboard/thingsboard.git

编译需要`JDK11`和`MAVN`

### 1.1 在windows上安装docker：

docker下载地址：https://www.docker.com/products/docker-desktop/

安装方法看说明

需要把`docker`的`bin`目录添加到环境变量`Path`

### 1.2 创建数据卷

安装好之后需要创建`volume `

在`PowerShell`输入

```shell
docker volume create mytb-data
docker volume create mytb-logs
```

创建数据卷和日志卷

### 1.3 创建`docker-compose.yaml`

新建文件夹->thingsboard->创建文本文件，重命名为`docker-compose.yaml`

输入下面内容

```
version: '3.0'
services:
  mytb:
    restart: always
    image: "thingsboard/tb-postgres"
    ports:
      - "8080:9090"
      - "1883:1883"
      - "7070:7070"
      - "5683-5688:5683-5688/udp"
    environment:
      TB_QUEUE_TYPE: in-memory
    volumes:
      - mytb-data:/data
      - mytb-logs:/var/log/thingsboard
volumes:
  mytb-data:
    external: true
  mytb-logs:
    external: true
```

- `8080:9090` - 容器内部HTTP端口 9090 映射到外部 8080 

- `1883:1883` - 容器内部MQTT 端口 1883映射到外部 1883

- `7070:7070` - 容器内部Edge RPC 端口 7070映射到外部 7070

- `5683-5688:5683-5688/udp` - 将本地 UDP 端口 5683-5688 连接到公开的内部 COAP 和 LwM2M 端口

- `~/.mytb-data:/data` -  ThingsBoard DataBase 数据目录设置为mytb-data

- `~/.mytb-logs:/var/log/thingsboard` -  ThingsBoard 日志目录设置为mytb-logs

- `mytb` - 主机名

- `restart: always` - 设置ThingsBoard自启

- `image: thingsboard/tb-postgres` - docker镜像，也可以是`thingsboard/tb-cassandra`或者`thingsboard/tb`

  `powershell`中`cd`到你创建的目录输入

  ```
  docker compose up -d
  docker compose logs -f mytb
  ```

启动`thingsboard`

打开地址：[http://localhost:8080](http://localhost:8080/)

账号：**tenant@thingsboard.org**

密码：**tenant**

## **2 添加设备**

- 登录并打开设备页面

- 单击"+"图标

- 输入设备名称

  ![image-20230908122316888](/images/image-20230908122316888.png)

