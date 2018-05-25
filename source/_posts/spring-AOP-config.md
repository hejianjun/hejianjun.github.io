---
title: Spring AOP的配置
date: 2018-05-25 00:00:00
tags: [ AOP , spring ]
categories:
  - technology
  - AOP
  - spring
typora-root-url: ..
---

# 基于XML配置的Spring AOP

基于XML配置的Spring AOP需要引入AOP配置的Schema，然后我们就可以使用AOP Schema下定义的config、aspect、pointcut等标签进行Spring AOP配置了。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:p="http://www.springframework.org/schema/p" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
     http://www.springframework.org/schema/beans/spring-beans-4.1.xsd
     http://www.springframework.org/schema/context
     http://www.springframework.org/schema/context/spring-context-4.1.xsd
     http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-4.1.xsd">
</beans>
```
<!--more-->
基于XML配置的Spring AOP的核心配置是config元素，其它的诸如切面配置、切入点配置等都是配置在它的下面的，所以我们需要先定义一个config元素。

## 配置切面

切面的配置是通过aspect元素配置的，我们需要通过其ref属性指定切面类对应的Spring bean的id或name，还可以通过其order属性指定切面类的在拦截的时候的优先级。需要说明的是在使用Spring时基于XML的配置和基于注解的配置往往是可以混用的，所以在下面示例中我们使用的切面类引用不一定非得在Spring的bean配置文件中进行配置。

```xml
<bean id="schemaBasedAspect" class="com.elim.spring.aop.aspect.SchemaBasedAspect"/>

<!-- 基于XML的AOP配置是基于config元素开始的 -->
<aop:config>
    <!-- 定义切面 -->
    <aop:aspect id="aspect1" ref="schemaBasedAspect" order="1">
    </aop:aspect>
</aop:config>
```

## 配置切入点

切入点可以是直接配置在config元素下的，意为顶级切入点，也可以是配置在指定的aspect下面的。切入点的配置是通过pointcut元素来配置的，在配置的时候我们需要指定id和expression属性，expression属性就对应的是切入点的表达式，其配置规则跟基于Aspectj注解配置时的规则是一样的。如下示例中就定义了两个pointcut，一个是顶级的，一个是在aspectj1中定义的。需要注意的是顶级的Pointcut必须定义在aspect之前。

```xml
<aop:config>
    <aop:pointcut expression="bean(userService)" id="userServicePointCut2"/>
    <!-- 定义切面 -->
    <aop:aspect id="aspect1" ref="schemaBasedAspect" order="1">
        <aop:pointcut expression="bean(userService)" id="userServicePointCut"/>
    </aop:aspect>
</aop:config>
```

如果我们的切入点是以Aspectj注解的形式定义在类里面的，我们也可以像在前面介绍的基于Aspectj注解配置那样进行引用，如在下面这个配置就是使用的在SchemaBasedAspect类的pointcut方法上通过@Pointcut指定的表达式。

```xml
<aop:pointcut expression="com.elim.spring.aop.aspect.SchemaBasedAspect.pointcut()" id="pointcut"/>
```

## 配置Advice

切面的最终目的是为了拦截指定切入点的方法执行，然后加入自己特定逻辑的，有了切面定义和切入点的定义后，我们需要定义在哪些切入点上需要使用切面的哪些Advice，即执行切面类的哪些方法。我们知道Advice有before、after、after returning、after throwing和around五种，对应的分别是before、after、after-returning、after-throwing和around标签，它们都是定义在aspect标签下的。这五类Advice在定义时的用法基本上是类似的，通过method方法指定Advice对应的是aspect类的哪个方法，然后通过pointcut指定切入点的表达式，或者通过pointcut-ref指定需要引用的是哪个切入点。如下示例中我们就定义了两个Advice，before Advice指定了对应的是切面类的doBefore方法，然后通过pointcut-ref指定需要使用的切入点是id为userServicePointCut的切入点；around Advice指定了对应的是切面类的doAround方法，然后通过pointcut直接指定了需要作用的切入点表达式。

```xml
<aop:aspect id="aspect1" ref="schemaBasedAspect" order="1">
    <!-- 定义一个Around Advice -->
    <aop:before method="doBefore" pointcut-ref="userServicePointCut" />
    <aop:around method="doAround" pointcut="bean(userService)"/>
    <aop:pointcut expression="bean(userService)" id="userServicePointCut"/>
</aop:aspect>
```

和基于注解的配置类似，如果我们需要在afterReturning Advice中访问返回值，我们也可以给对应的处理方法一个返回值对应类型（或Object类型）的参数，然后通过after-returning元素的returning属性指定返回值需要赋予给Advice处理方法的哪个参数，参数名需要一致。同样afterThrowing类型的Advice需要在处理方法中接收抛出的异常时，也可以给定对应的处理方法一个Exception类型的参数，然后通过after-throwing元素的throwing属性指定抛出的异常需要赋值给Advice处理方法的哪个参数。

```xml
<aop:after-returning method="doAfterReturning" pointcut-ref="pointcut" returning="returnValue"/>
<aop:after-throwing method="doAfterThrowing" pointcut-ref="pointcut" throwing="ex"/>
```

参数传递也是类似的，在Advice处理方法上给定指定的参数，然后在定义Pointcut表达式的时候加上对应的参数传递限制，如“args(id)”、“this(userService)”等，在需要指定参数的绑定顺序时，可以通过before、around等Advice标签的arg-names属性指定。如下示例中我们就要求id为userServicePointCut的Pointcut需要接收一个参数，这个参数是需要跟对应的Advice处理方法绑定的，而before Advice是使用该Pointcut的，所以就要求id与对应的处理方法参数绑定，而且对应的方法参数名需要是id。

```xml
<aop:aspect id="aspect1" ref="schemaBasedAspect" order="1">
    <aop:before method="doBefore" pointcut-ref="userServicePointCut"/>
    <aop:around method="doAround" pointcut="bean(userService)" />
    <aop:pointcut expression="bean(userService) &amp;&amp; args(id)" id="userServicePointCut"/>
</aop:aspect>
```

我们对应的doBefore处理方法是这样的。

```java
public void doBefore(int id) {
    System.out.println("======================doBefore======================" + id);
}
```

在上面的示例中在定义id为userServicePointcut的表达式的时候用到了“&&”，这是因为在XML中&是特殊字符，我们必须对它进行转义。其实在XML中配置Pointcut表达式时我们可以使用“and”、“or”和“not”替代“&&”、“||”和“!”。

## declare-parents

在基于注解的形式定义AOP时，我们有一个@DeclareParents注解可以给所有匹配的bean生成的代理默认加上指定的接口实现，并使用默认的实现。如果是基于XML配置时如果想达到对应的效果我们可以通过declare-parents元素来达到对应的效果。示例如下，切面类SchemaBasedAspect有一个doBefore方法接收一个CommonParent参数，我们在配置切面时配置了一个before Advice将调用切面类的doBefore方法；通过declare-parents元素指定service包下面所有的类都实现CommonParent接口，底层在调用的时候将会调用CommonParentImpl的实现。CommonParent接口的源码没有提供，其只定义了一个返回类型为void的doSomething()方法。然后我们的before Advice将拦截id为userService的bean的所有方法调用，注意因为我们声明了所有的Service都将实现CommonParent接口，所以生成的id为userService的bean其实也是实现了CommonParent接口的，在调用的doBefore方法时传递的就是id为userService的bean，我们在doBefore方法中又继续调用CommonParent的doSomething方法就相当于重新调用了id为userService的bean的方法，会造成before Advice循环拦截和调用。很显然此种情况下，我们是不希望CommonParent的方法调用还被拦截的，所以我们在对应的Pointcut表达式上把CommonParent的doSomething方法排除了。在应用注解的时候不用排除也不会循环调用，但是使用XML配置时必须排除。

```java
public void doBefore(CommonParent commonParent) {
    System.out.println("======================doBefore======================");
    commonParent.doSomething();
}
```

```xml
<bean id="schemaBasedAspect" class="com.elim.spring.aop.aspect.SchemaBasedAspect" />
<bean id="commonParent" class="com.elim.spring.aop.service.CommonParentImpl" />
<!-- 基于XML的AOP配置是基于config元素开始的 -->
<aop:config>
    <aop:aspect id="aspect1" ref="schemaBasedAspect" order="1">
        <aop:before method="doBefore" pointcut-ref="userServicePointCut" />
        <aop:pointcut expression="bean(userService) and this(commonParent) and !execution(void com.elim.spring.aop.service.CommonParent.doSomething())"
            id="userServicePointCut" />
        <!-- 加上通用的父类 -->
        <aop:declare-parents types-matching="com.elim.spring.aop.service..*"
            implement-interface="com.elim.spring.aop.service.CommonParent"
            delegate-ref="commonParent"/>
    </aop:aspect>
</aop:config>
```

## 启用CGLIB代理类

默认情况下当bean实现了接口时Spring AOP是基于JDK的动态代理的，也就是说我们生成的bean只能调用接口中定义的方法，如果我们的bean是没有实现接口的，则会采用CGLIB代理。如果我们希望不管bean是否实现了接口都采用CGLIB代理，则在基于Aspectj注解进行AOP配置时，我们可以通过aspectj-autoproxy元素的proxy-target-class=”true”启用CGLIB代理。

```xml
<aop:aspectj-autoproxy proxy-target-class="true" />
```

如果是基于XML的配置时，我们也希望强制使用CGLIB代理时怎么办呢？我们可以在config元素上配置proxy-target-class=”true”。

```xml
<aop:config proxy-target-class="true">
</aop:config>
```