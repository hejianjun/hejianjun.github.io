---
title: NoSuchMethodError
date: 2018-12-01 21:35:55
tags: JPDA
categories:
  - technology
  - JPDA
typora-root-url: ..
---
昨天答辩的时候考到`NoSuchMethodError`这个经常遇到的错误，居然没有回答上来，在此处记录一下
`NoSuchMethodError`按字面理解是方法找不到，这个一般不是真的没有这个方法，不然编译的时候就报错了，有可能是jar包的版本不对或者是冲突
下面是排查的思路
如果是在开发环境当然是用IDE调试，在生产环境一般是JDB调试，下面只说怎么在JDB调试
查看日志报错所在的行
使用 `stop in `断点
执行`eval 缺少方法的类.class.getProtectionDomain().getCodeSource()`查看类所属的位置