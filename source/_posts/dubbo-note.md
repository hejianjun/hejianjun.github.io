---
title: dubbo-note
date: 2018-03-13 20:20:32
tags: dubbo
categories:
  - technology
  - dubbo
typora-root-url: ..
---
公司用到了dubbo拆分服务，开始补习dubbo的知识

Dubbo是Alibaba开源的分布式服务框架，它最大的特点是按照分层的方式来架构，使用这种方式可以使各个层之间解耦合（或者最大限度地松耦合）。从服务模型的角度来看，Dubbo采用的是一种非常简单的模型，要么是提供方提供服务，要么是消费方消费服务，所以基于这一点可以抽象出服务提供方（Provider）和服务消费方（Consumer）两个角色。

服务化首先需要把服务抽象为接口，然后使用dubbo把接口暴露出来

### 定义服务接口


DemoService.java ：
```java
package com.alibaba.dubbo.demo;

public interface DemoService {
    String sayHello(String name);
}
```

