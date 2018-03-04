---
title: Kettle笔记
tags: kettle
categories:
  - technology
typora-root-url: ..
date: 2018-03-04 12:42:47
---


​	菜爸叫我整理一下kettle的笔记说是要培训，我一个小菜比什么都不懂，只能临时抱下佛脚，百度一下。

什么是Kettle
------------

​	Kettle是一款国外开源的ETL工具，纯java编写，可以在Window、Linux、Unix上运行，数据抽取高效稳定。这个是百度百科的原话，用我们的话说就是数据迁移的工具。

​	Kettle中有两种脚本文件，transformation和job，transformation完成针对数据的基础转换，job则完成整个工作流的控制。

Kettle的安装与运行
------------------

​	可以从 https://community.hds.com/docs/DOC-1009855 下载最新版的 Kettle软件 ，同时，Kettle 是绿色软件，下载后，解压到任意目录即可。 由于Kettle 是采用java 编写，因此需要在本地有JVM 的运行环境（JDK1.7以上），我们所使用的Kettle的最新版本是7.1 的。安装完成之后，点击目录下面的Spoon.bat或spoon.sh （linux）即可启动kettle的设计工具。

![spoon](/images/spoon.jpg)

## Kettle的基本概念

1. **作业（job）**，负责将[转换]组织在一起进而完成某一块工作，通常我们需要把一个大的任务分解成几个逻辑上隔离的作业，当这几个作业都完成了，也就说明这项任务完成了。

>* Job Entry：一个Job Entry 是一个任务的一部分，它执行某些内容。

>* Hop：一个Hop 代表两个步骤之间的一个或者多个数据流。一个Hop 总是代表着两个Job Entry 之间的连接，并且能够被原始的Job Entry 设置，无条件的执行下一个Job Entry，直到执行成功或者失败。

>* Note：一个Note 是一个任务附加的文本注释信息。

2. **转换（Transformation）**，定义对数据操作的容器，数据操作就是数据从输入到输出的一个过程，可以理解为比作业粒度更小一级的容器，我们将任务分解成作业，然后需要将作业分解成一个或多个转换，每个转换只完成一部分工作。

>* Value：Value 是行的一部分，并且是包含以下类型的的数据：Strings、floating point Numbers、unlimited precision BigNumbers、Integers、Dates、或者Boolean。

>* Row：一行包含0 个或者多个Values。

>* Output Stream：一个Output Stream 是离开一个步骤时的行的堆栈。

>* Input Stream：一个Input Stream 是进入一个步骤时的行的堆栈。

>* Step：转换的一个步骤，可以是一个Stream或是其他元素。

>* Hop：一个Hop 代表两个步骤之间的一个或者多个数据流。一个Hop 总是代表着一个步骤的输出流和一个步骤的输入流。

>* Note：一个Note 是一个转换附加的文本注释信息。

## Kettle 基本使用

1.  Kettle 的几个子程序

   > **Spoon**图形界面作业和转换设计器

   > **Pan**命令行方式执行转换

   > **Kitchen**命令行方式执行作业

2.  转换和作业

  Kettle 的 Spoon 设计器用来设计**转换（Transformation**）和 **作业（Job）**。

  * **转换**主要是针对数据的各种处理，一个转换里可以包含多个步骤（Step）。

    ![transformation](/images/transformation.jpg)

  * **作业**是比转换更高一级的处理流程，一个作业里包括多个作业项（Job Entry），一个作业项代表了一项工作，转换也是一个作业项。

    ![job](/images/job.jpg)


