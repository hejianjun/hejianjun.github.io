---
title: MAVEN
date: 2020-07-30
tags: Java
categories:
  - technology
  - Java
typora-root-url: ..
---
# MAVEN

# 为何需要MAVEN

## 使用maven前

![印度挂票](images/印度挂票.png)

项目臃肿不堪，jar包从各种渠道引入

## 使用maven后

![中国高铁](images/中国高铁.png)

项目从统一的规范下载，升级管理jar版本只需要修改配置文件

# 安装
## 配置环境变量

| 系统变量名 | 说明                | 实例值                     |
| ---------- | ------------------- | -------------------------- |
| MAVEN_HOME | maven根目录         | C:\tool\apache-maven-3.3.9 |
| Path       | windows查找命令路径 | ;%MAVEN_HOME%\bin          |

# 约定配置

##常用Maven目录结构
```
src
  -main
      –java java源代码文件
      –resources 资源库，会自动复制到classes目录里
      –webapp web应用的目录。WEB-INF、css、js等
  –test
      –java 单元测试java源代码文件
      –resources 测试需要用的资源库
target 打包输出目录
pom.xml  maven的pom文件
LICENSE.txt Project’s license
README.txt Project’s readme
```

# Maven POM
## pom文件
```xml
<project xmlns = "http://maven.apache.org/POM/4.0.0"
    xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation = "http://maven.apache.org/POM/4.0.0
    http://maven.apache.org/xsd/maven-4.0.0.xsd">
 
    <!-- 模型版本 -->
    <modelVersion>4.0.0</modelVersion>
    <!-- 公司或者组织的唯一标志，并且配置时生成的路径也是由此生成， 如com.companyname.project-group，maven会将该项目打成的jar包放本地路径：/com/companyname/project-group -->
    <groupId>com.thunisoft.project-group</groupId>
    <!-- 项目的唯一ID，一个groupId下面可能多个项目，就是靠artifactId来区分的 -->
    <artifactId>project</artifactId>
    <!-- 版本号 -->
    <version>1.0</version>
</project>
```

## node说明

| 节点         | 描述                                                         |
| ----------- | ----------------------------------------------------------- |
| project      | 工程的根标签。                                               |
| modelVersion | 模型版本需要设置为 4.0。                                     |
| groupId      | 这是工程组的标识。它在一个组织或者项目中通常是唯一的 |
| artifactId   | 这是工程的标识。它通常是工程的名称。
| version      | 这是工程的版本号。在 artifact 的仓库中，它用来区分不同的版本。 |

# Maven有哪些常用命令？都是什么作用？


## Maven 构建生命周期

```flow
st=>start: Start
validate=>operation: validate
compile=>operation: compile
test=>operation: test
package=>operation: package
verify=>operation: verify
install=>operation: install
deploy=>operation: deploy
e=>end
st->validate->compile->test->package->verify->install->deploy->e
```

## Clean（清理）

移除所有上一次构建生成的文件

## Compile（编译）

编译项目的源代码。

## Package（打包）

将编译后的代码打包成可分发格式的文件，比如JAR、WAR或者EAR文件。

## Install（安装）

安装项目包到本地仓库，这样项目包可以用作其他本地项目的依赖。

## Deploy（部署）

将最终的项目包复制到远程仓库中与其他开发者和项目共享。



# 设置JDK版本

## 方法一

```xml
 <properties>
     <maven.compiler.source>${java.version}</maven.compiler.source>
     <maven.compiler.target>${java.version}</maven.compiler.target>
     <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
     <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
     <java.version>1.8</java.version>
 </properties>
```
## 方法二
```xml
 <plugin>
     <groupId>org.apache.maven.plugins</groupId>
     <artifactId>maven-compiler-plugin</artifactId>
     <configuration>
     <source>1.8</source>
     <target>1.8</target>
     </configuration>
 </plugin>
```


# Maven 快照(SNAPSHOT)

## 1、Snapshot 版本代表不稳定、尚处于开发中的版本。

## 2、Release 版本则代表稳定的版本。

## 什么情况下该用 SNAPSHOT?

协同开发时，如果 A 依赖构件 B，由于 B 会更新，B 应该使用 SNAPSHOT 来标识自己。这种做法的必要性可以反证如下：

a. 如果 B 不用 SNAPSHOT，而是每次更新后都使用一个稳定的版本，那版本号就会升得太快，每天一升甚至每个小时一升，这就是对版本号的滥用。
b.如果 B 不用 SNAPSHOT, 但一直使用一个单一的 Release 版本号，那当 B 更新后，A 可能并不会接受到更新。因为 A 所使用的 repository 一般不会频繁更新 release 版本的缓存（即本地 repository)，所以B以不换版本号的方式更新后，A在拿B时发现本地已有这个版本，就不会去远程Repository下载最新的 B

## 不用 Release 版本，在所有地方都用 SNAPSHOT 版本行不行？     

不行。正式环境中不得使用 snapshot 版本的库。 比如说，今天你依赖某个 snapshot 版本的第三方库成功构建了自己的应用，明天再构建时可能就会失败，因为今晚第三方可能已经更新了它的 snapshot 库。你再次构建时，Maven 会去远程 repository 下载 snapshot 的最新版本，你构建时用的库就是新的 jar 文件了，这时正确性就很难保证了。


