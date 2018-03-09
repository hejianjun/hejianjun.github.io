---
title: court-flow
date: 2018-03-09 16:04:22
categories:
  - business
  - court
tags: court,flow
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
op_gzl=>operation: 计算出工作量
op_dy=>operation: 得出第一个人
e=>end: 分案完成
st->con_cbts
con_cbts(yes)->io_cbts->con_tsnl
con_cbts(no)->con_tsnl->io_tsnl
con_tsnl(yse)->io_tsnl->io_ajlb
con_tsnl(no)->io_ajlb->
io_ajlb->op_gzl->op_dy->e
```

