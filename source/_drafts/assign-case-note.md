---
title: 分案业务学习
date: 2018-03-04 21:35:55
tags: assign case
categories:
  - business
typora-root-url: ..
password: 3723402
abstract: 请输入密码
message: 请输入密码
---

## 案件大致流程

```flow
st_sa=>start: 收案
sub_la=>subroutine: 立案
sub_fa=>subroutine: 分案
op_sl=>operation: 审理
sub_ja=>subroutine: 结案
sub_gd=>subroutine: 归档
op8=>operation: 立案庭结案
cond_la=>condition: 同意立案?
end_gd=>end: 已归档
st_sa->sub_la->cond_la
cond_la(yes)->sub_fa->op_sl->sub_ja->sub_gd
cond_la(no)->sub_gd
sub_gd->end_gd
```

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

## 分案流程

```flow
st=>start: 分案入口
io_cl=>inputoutput: 读取策略
e=>end: 分案完成
con_cl=>condition: 策略存在？
op_mr=>operation: 默认手动分案到庭室
con_fa=>condition: 自动分案？
sub_sd=>subroutine: 手动分案
sub_zd=>subroutine: 自动分案
st->io_cl->con_cl
con_cl(no)->op_mr->e
con_cl(yes)->con_fa
con_fa(yes)->sub_zd->e
con_fa(no)->sub_sd->e
```



## 自动分案流程

```flow
st=>start: 分案入口
con_cbts=>condition: 是否可选择承办庭室？
io_cbts=>inputoutput: 输入承办庭室
con_tsnl=>condition: 可分案人有特殊能力？
io_tsnl=>inputoutput: 读取特殊能力
io_ajlb=>inputoutput: 读取可选列表已承办案件列表
op_ccc=>operation: 计算出ccc
op_zb=>operation: 对ccc折比
op_banl=>operation: 得出办案能力和虚拟结案数
op_gzl=>operation: 计算出工作量
op_px=>operation: 以工作量和最后分案时间排序
op_dy=>operation: 得出第一个人
e=>end: 分案完成
st->con_cbts
con_cbts(yes)->io_cbts->con_tsnl
con_cbts(no)->con_tsnl->io_tsnl
con_tsnl(yse)->io_tsnl->io_ajlb
con_tsnl(no)->io_ajlb
io_ajlb->op_ccc->op_zb->op_banl->op_gzl->op_px->op_dy->e

```




## 什么是繁简分流？

繁简分流是应用分案策略的一种选项和指定分案分案类似

## 自动分案是自动流转还是手工移送？

自动分案可以选择在待立案里还是已分案里，在待立案里的话还需要确认

## 那在自动分案时还可以手动分派么？

不能，这是两个步骤，在第二个步骤里还可以修改,第二个步骤是对第一个步骤可以更改,

## 策略不生效的原因

1. 分案策略需要刷新缓存
2. 分案策略中如果配置的案由是一个父节点，那么在匹配案件时会匹配这个节点和他的所有子节点！

