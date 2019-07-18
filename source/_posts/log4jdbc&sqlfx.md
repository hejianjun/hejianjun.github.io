---
title: log4jdbc 和 sqlfx
date: 2019-07-16 20:09:00
tags: sql
categories:
  - technology
  - sql
typora-root-url: ..
---
log4jdbc是我们公司sqlfx的基础构件，下面我来介绍一下他们之间的联系和作用
## 实现原理
`net.sf.log4jdbc.DriverSpy`这个类实现了JDBC的`Driver`接口,代理了原来数据库的驱动
而实现了`SpyLogDelegator`接口的策略通过配置文件`log4jdbc.log4j2.properties`打印日志，下面简述一下jdbc4log的配置

## 配置

```
# 原来数据库的实际驱动名
log4jdbc.drivers=net.sourceforge.jtds.jdbc.Driver
# 将所有堆栈打出，这个会输出大量信息
log4jdbc.dump.fulldebugstacktrace=false
# 显示实际调用类的包前缀，jdbc4log会打印堆栈中第一个符合这个正则的调用类
log4jdbc.debug.stack.prefix=^com\.thunisoft\.np\.fy.*
# sql分割的最大行数
log4jdbc.dump.sql.maxlinelength=150
# 调用的日志策略，如果要使用sqlfx3.0需要使用蔡海滨编写的类
log4jdbc.spylogdelegator.name=net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator
# 执行时间超过这个级别的日志将被输出为warn级别
log4jdbc.sqltiming.warn.threshold=100
# 执行时间超过这个级别的日志将被输出为error级别
log4jdbc.sqltiming.error.threshold=100
```

## SQLFX

SQLFX是我们公司为了DBA方便的分析项目中不规范的sql而编写的软件，主要由两部分组成client和server

client的作用类似于ELK中的Filebeat，每天晚上定时（可在服务端配置）将log4jdbc日志压缩后发送到服务端

server则定时解析client发送上来的log4jdbc日志生成报告并发邮箱给DBA


