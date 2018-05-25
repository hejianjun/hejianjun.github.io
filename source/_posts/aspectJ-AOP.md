---
title: AOP之基于AspectJ注解
date: 2018-05-25 01:00:00
tags: [ AOP , aspectJ ]
categories:
  - technology
  - AOP
  - AspectJ
typora-root-url: ..
---

# 一、基本使用方法 

###  1.1、启用对@AspectJ的支持

Spring默认不支持@AspectJ风格的切面声明，为了支持需要使用如下配置：
```xml
<!-- 启动@AspectJ支持 -->  
<!-- proxy-target-class默认"false",更改为"ture"使用CGLib动态代理 -->    
<aop:aspectj-autoproxy proxy-target-class="false"/>  
```
这样Spring就能发现@AspectJ风格的切面并且将切面应用到目标对象。
<!--more-->
###  1.2、 声明切面

@AspectJ风格的声明切面非常简单，使用@Aspect注解进行声明：

```java
@Aspect  
public class AdivceMethod {
```

然后将该切面在配置文件中声明为Bean后，Spring就能自动识别并进行AOP方面的配置：

```xml
<bean id="aspect" class="……AdivceMethod"/>  
```
或者直接使用元注解的方法：

```java
@Component  
@Aspect  
public class AdivceMethod {  
```

###  1.3、 声明切入点

@AspectJ风格的命名切入点使用org.aspectj.lang.annotation包下的@Pointcut+方法（方法必须是返回void类型）实现。

```java
@Pointcut(value="切入点表达式", argNames = "参数名列表")  
public void pointcutName(……) {}   
```
- **value：**指定切入点表达式；

- **argNames：**指定命名切入点方法参数列表参数名字，可以有多个用`，`分隔，这些参数将传递给通知方法同名的参数，同时比如切入点表达式`args(param)`将匹配参数类型为命名切入点方法同名参数指定的参数类型。

- **pointcutName：**切入点名字，可以使用该名字进行引用该切入点表达式。

```java
@Pointcut(value="execution(* cn.javass..*.sayAdvisorBefore(..)) && args(param)", argNames = "param")    
public void beforePointcut(String param) {}    
```
定义了一个切入点，名字为`beforePointcut`，该切入点将匹配目标方法的第一个参数类型为通知方法实现中参数名为`param`的参数类型。

#  二、声明通知

@AspectJ风格的声明通知也支持5种通知类型：

**2.1、前置通知：**使用org.aspectj.lang.annotation 包下的@Before注解声明；

```java
@Before(value = "切入点表达式或命名切入点", argNames = "参数列表参数名")    
```
- **value：**指定切入点表达式或命名切入点；

- **argNames：**与Schema方式配置中的同义。

接下来示例一下吧：

1、定义接口和实现，在此我们就使用Schema风格时的定义；

2、定义切面：

3、定义切入点：

4、定义通知：

**2.2、后置返回通知：**使用org.aspectj.lang.annotation 包下的@AfterReturning注解声明；

```java
@AfterReturning(    
value="切入点表达式或命名切入点",    
pointcut="切入点表达式或命名切入点",    
argNames="参数列表参数名",    
returning="返回值对应参数名")    
```
- **value：**指定切入点表达式或命名切入点；

-  **pointcut：**同样是指定切入点表达式或命名切入点，如果指定了将覆盖value属性指定的，pointcut具有高优先级；

- **argNames：**与Schema方式配置中的同义；

-  **returning：**与Schema方式配置中的同义。

**2.3、后置异常通知：**使用org.aspectj.lang.annotation 包下的@AfterThrowing注解声明；

```java
@AfterThrowing (    
value="切入点表达式或命名切入点",    
pointcut="切入点表达式或命名切入点",    
argNames="参数列表参数名",    
throwing="异常对应参数名")    
```
- **value：**指定切入点表达式或命名切入点；

- **pointcut：**同样是指定切入点表达式或命名切入点，如果指定了将覆盖value属性指定的，pointcut具有高优先级；

- **argNames：**与Schema方式配置中的同义；

- **throwing：**与Schema方式配置中的同义。

 

其中测试代码与Schema方式几乎一样，在此就不演示了，如果需要请参考AopTest.java中的testAnnotationAfterThrowingAdvice测试方法。

**2.4、后置最终通知：**使用org.aspectj.lang.annotation 包下的@After注解声明；

 

```java
@After (    
value="切入点表达式或命名切入点",    
argNames="参数列表参数名")    
```



- **value：**指定切入点表达式或命名切入点；

- **argNames：**与Schema方式配置中的同义；

**2.5、环绕通知：**使用org.aspectj.lang.annotation 包下的@Around注解声明；

```java
@Around (    
value="切入点表达式或命名切入点",    
argNames="参数列表参数名")    
```


- **value：**指定切入点表达式或命名切入点；

- **argNames：**与Schema方式配置中的同义； 

### 2.6  引入

@AspectJ风格的引入声明在切面中使用org.aspectj.lang.annotation包下的@DeclareParents声明：

```java
@DeclareParents(    
value=" AspectJ语法类型表达式",    
defaultImpl=引入接口的默认实现类)    
private Interface interface;    
```
- **value：**匹配需要引入接口的目标对象的AspectJ语法类型表达式；与Schema方式中的types-matching属性同义；

- **private Interface interface：**指定需要引入的接口；

- **defaultImpl：**指定引入接口的默认实现类，没有与Schema方式中的delegate-ref属性同义的定义方式；

 
