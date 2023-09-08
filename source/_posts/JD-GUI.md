---
title: JD-GUI
date: 2023-09-08 21:35:55
tags: JD-GUI
categories:
  - technology
  - JD-GUI
typora-root-url: ..
---

最近接了一个项目需要反编译class，尝试了用`ChatGPT4` 尝试了一下，不允许，于是使用`JD-GUI`来操作

![image-20230908122922005](/images/image-20230908122922005.png)

## 1. 下载和安装

地址：http://java-decompiler.github.io/

下载链接：

[**jd-gui-1.6.6.jar**](https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6.jar) 

[**jd-gui-1.6.6-min.jar**](https://github.com/java-decompiler/jd-gui/releases/download/v1.6.6/jd-gui-1.6.6-min.jar)

绿色软件，用`jdk`就可以直接启动，运行不了的话打开命令行执行下面语句

```
java -jar jd-gui-1.6.6.jar
```

打开是这个样子的

![image-20230908142843084](/images/image-20230908142843084.png)

## 2. 设置一下导出格式

这边导出的java需要和源代码对比，所以需要设置一下不导出行号和反编译器信息

Help--Preferences

![image-20230908143045891](/images/image-20230908143045891.png)

把Sources saving中的两个框的√去掉（因为默认是选中的）

![image-20230908143113339](/images/image-20230908143113339.png)

## 3. 打开需要反编译的文件

这里可以选择war包或者jar包，如果是解压好的文件夹，随便找个class打开，jd-gui会自动查找根目录

![image-20230908143602171](/images/image-20230908143602171.png)

## 4. 导出源代码

在`File`选项找到`Save All Sources`这个是保存jar全部类。如果是单个就是`Save Sources`。

![image-20230908143657849](/images/image-20230908143657849.png)

![image-20230908143826827](/images/image-20230908143826827.png)

## 5. 现在可以把源码导入到ChatGTP来分析源码了

![image-20230908144111744](/images/image-20230908144111744.png)
