---
title: 分案业务学习
date: 2018-03-06 21:35:55
tags: assign case
categories:
  - business
  - court
typora-root-url: ..
password: 3723402
abstract: 请输入密码
message: 请输入密码
---



<!--more-->
## 分案涉及的表

| 表中文名        | 表名                | 存储空间 |
| ----------- | ----------------- | ---- |
| 分案策略        | T_FA_FACL         | JCSZ |
| 自动分案配置      | T_FA_ZDFA_PZ      | JCSZ |
| 自动分案配置折比系数  | T_FA_ZDFA_PZ_ZBXS | JCSZ |
| 自动分案折比条件配置  | T_FA_ZDFA_ZBTJ    | JCSZ |
| 自动分案办案能力    | T_FA_ZDFA_BANL    | JCSZ |
| 自动分案特殊能力配置  | T_FA_ZDFA_TSNL    | JCSZ |
| 审判小组(合议庭)   | T_YWGY_LA_SPXZ    | JCSZ |
| 审判人员(合议庭人员) | T_YWGY_LA_SPRY    | JCSZ |
| 人员请假信息      | T_YWGY_RYQJXX     | YWST |
| 分案虚拟庭室      | T_FA_XNTS         | JCSZ |
| 分案虚拟庭室关系表   | T_FA_XNTS_DEPT    | JCSZ |
| 分案虚拟小组      | T_FA_XNXZ         | JCSZ |
| 分案虚拟小组关系表   | T_FA_XNXZ_USER    | JCSZ |
| 循环分案策略      | T_XHFA_FACL       | JCSZ |
| 循环分案人员      | T_XHFA_ORGAN      | JCSZ |

## 什么是繁简分流？

繁简分流是应用分案策略的一种选项和指定分案分案类似

## 自动分案是自动流转还是手工移送？

自动分案可以选择在待立案里还是已分案里，在待立案里的话还需要确认

## 那在自动分案时还可以手动分派么？

不能，这是两个步骤，在第二个步骤里还可以修改,第二个步骤是对第一个步骤可以更改,

## 策略不生效的原因

1. 分案策略需要刷新缓存
2. 分案策略中如果配置的案由是一个父节点，那么在匹配案件时会匹配这个节点和他的所有子节点！

