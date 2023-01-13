---
title: Kettle入门
date: 2018-03-04 11:56:54
tags: kettle
categories:
  - technology
  - kettel
typora-root-url: ..
---
## Spoon编辑篇

这篇主要说一下Spoon图形工具的使用，多图预警

<!--more-->
## 创建一个转换

1. 文件->新建转换

![create_transformation](/images/create_transformation.gif)

设置转换的属性
---

1.在右侧的转换空白区域右击->转换设置

2.这里可以设置转换名称，参数和日志

![set_name_transformation](/images/set_name_transformation.gif)

## 创建数据库连接

1.在lib下或libswt\win64（64位）下加入jdbc驱动

2.在左边的主对象树中建立DB连接用以连接数据库

![create_database_connection](/images/create_database_connection.gif)

创建输入步骤
---

1.在左边的主核心对象树中添加输入步骤，这里我们选择导入cvs文件

![create_step](/images/create_step.gif)

## 写入数据库

1.在左边的主核心对象树中添加输出步骤，这里我们导入刚刚创建的数据库

![write_database_table](/images/write_database_table.gif)

## 执行这个转换

1.kettle保存了才能运行，文件->保存,选择文件路径和名字就可以了

2.点击右侧的run图标或者按F9弹出运行选项，这里可以选择日志输出级别，运行参数和变量

![execute_transformation](/images/execute_transformation.gif)

## 修改这个转换

1. 上面我们看到表输出报错了，我们查看一下日志发现有个

    ```java
    2018/03/04 16:08:23 - 表输出.0 - ERROR (version 7.1.0.0-12, build 1 from 2017-05-16 17.18.02 by buildguy) : Because of an error, this step can't continue:
    2018/03/04 16:08:23 - 表输出.0 - ERROR (version 7.1.0.0-12, build 1 from 2017-05-16 17.18.02 by buildguy) : org.pentaho.di.core.exception.KettleValueException: 
    2018/03/04 16:08:23 - 表输出.0 - Unexpected conversion error while converting value [QQ String] to an Integer
    2018/03/04 16:08:23 - 表输出.0 - 
    2018/03/04 16:08:23 - 表输出.0 - QQ String : couldn't convert String to Integer
    2018/03/04 16:08:23 - 表输出.0 - 
    2018/03/04 16:08:23 - 表输出.0 - QQ String : couldn't convert String to number : non-numeric character found at position 1 for value [小鱼呼叫转移]
    ```

2. 我们需要修改下QQ这个字段的类型为`String`，然后run一下转换

   ![debug_transformation1](/images/debug_transformation1.gif)

   报错信息发生了变化，输出了下面的错误

   ```java
   2018/03/04 16:13:43 - 表输出.0 - ERROR (version 7.1.0.0-12, build 1 from 2017-05-16 17.18.02 by buildguy) : Unexpected batch update error committing the database connection.
   2018/03/04 16:13:43 - 表输出.0 - ERROR (version 7.1.0.0-12, build 1 from 2017-05-16 17.18.02 by buildguy) : org.pentaho.di.core.exception.KettleDatabaseBatchException: 
   2018/03/04 16:13:43 - 表输出.0 - Error updating batch
   2018/03/04 16:13:43 - 表输出.0 - 批次处理 29 INSERT INTO t_users (username, screen_name, email, home_url, group_name) VALUES ( '何',  NULL,  '942156265',  NULL,  NULL) 被中止，呼叫 getNextException 以取得原因。

   ```

3. 显然是sql错误，我们需要查看异常的具体原因，于是我们需要取消表输出的`使用批量插入`功能

   ![debug_transformation2](/images/debug_transformation2.gif)

   输出的错误如下

   ```java
   2018/03/04 16:39:06 - 表输出.0 - ERROR (version 7.1.0.0-12, build 1 from 2017-05-16 17.18.02 by buildguy) : Because of an error, this step can't continue:
   2018/03/04 16:39:06 - 表输出.0 - ERROR (version 7.1.0.0-12, build 1 from 2017-05-16 17.18.02 by buildguy) : org.pentaho.di.core.exception.KettleException: 
   2018/03/04 16:39:06 - 表输出.0 - Error inserting row into table [t_users] with values: [张], [三], [null], [null], [null], [988888888], [null], [null], [null], [null], [null], [null], [null], [null], [null], [null], [null], [null], [	17655555555], [null], [null], [	13558888888], [null], [null], [null], [null], [null], [null], [null]
   2018/03/04 16:39:06 - 表输出.0 - 
   2018/03/04 16:39:06 - 表输出.0 - Error inserting/updating row
   2018/03/04 16:39:06 - 表输出.0 - ERROR: duplicate key value violates unique constraint "users_name_unique"  详细：Key (username)=(何) already exists.
   ```

4. 显然是我们的映射关系有问题，我们添加一个Concat Fields转换步骤把姓名映射到username中（这里我勾选了`裁剪表`，不是全量导入千万不要勾选，这个会清除表中原有的所有数据）

   ![debug_transformation3](/images/debug_transformation3.gif)

   我们可以看到转换可以正常run了

5. 现在我们把`使用批量插入`功能打开保存之后自己试一试吧！

## 调试这个转换

有时我们需要断点调试，这时需要使用debug的功能

1. 点击debug图标，弹出的debug窗口左边可以选择需要断点的step，右边可以选择断点类型，有`获得前几行`（按行数断点）和`满足条件时暂停转换`（条件断点），这里我们选择Concat Fields姓名为null时断点

   ![debug_transformation4](/images/debug_transformation4.gif)

   断点命中后可以选择`关闭`查看其他step的preview data和日志，`停止`来停止这个转换，`获取更多行`来继续调试

