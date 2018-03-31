---
title: docker-note
date: 2018-03-26 22:48:43
tags: docker
categories:
  - technology
  - docker
typora-root-url: ..
---
最近在阿里搭了个blog用到了docker打包记录一下

docker有点像虚拟机不过比虚拟机性能要好一些
<!--more-->
## 登录私有仓库
```bash
docker login 仓库地址
```
例子:
```bash
docker login registry.cn-shenzhen.aliyuncs.com
```
出现
```bash
Username:
Password:
```
然后输入用户名密码，登录成功如下图
```bash
Login Succeeded
```
失败如下图
```bash
Error response from daemon: Get https://registry-1.docker.io/v2/: unauthorized: incorrect username or password
```
或者下图
```bash
Error response from daemon: Get https://registry.cn-shenzhen.aliyuncs.com/v2/: unauthorized: authentication required
```
## 运行镜像
```bash
docker run 镜像地址/镜像名:tag
```
这个指令如果本地有会运行本地的images，没有会从远程下载
下面是例子
```bash
docker run registry.cn-shenzhen.aliyuncs.com/thunisoft/gjr-hexo:latest
```
这个指令就是从registry.cn-shenzhen.aliyuncs.com/thunisoft的远程仓库下载镜像gjr-hexo，tag是latest
上面这个指令运行完就会执行这个镜像里的程序，后面接`-it /bin/bash`可以进入交互模式调试容器
```bash
docker run -it registry.cn-shenzhen.aliyuncs.com/thunisoft/gjr-hexo:latest /bin/bash
```
查看正在运行的容器
```bash
docker ps
```
查看所有容器
```bash
docker ps -a
```
