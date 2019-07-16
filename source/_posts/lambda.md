---
title: Lambda
date: 2019-01-01 21:35:55
tags: OCJP
categories:
  - technology
  - OCJP
typora-root-url: ..
---
# Lambda表达式



## Java为何需要Lambda



## 代码简洁，开发快速
减少了代码的重复，因此程序比较短，开发速度较快。


```java
//Before Java 8:
new Thread(new Runnable() {
    @Override
    public void run() {
        System.out.println("Before Java8 ");
    }
}).start();

//Java 8 way:
new Thread(() -> System.out.println("In Java8!"));
```



## 接近自然语言，易于理解
编程的自由度很高，可以写出很接近自然语言的代码。


```java
//Prior Java 8 :
List features = Arrays.asList("Lambdas", "Default Method", 
"Stream API", "Date and Time API");
for (String feature : features) {
   System.out.println(feature);
}

//In Java 8:
List features = Arrays.asList("Lambdas", "Default Method", "Stream API",
 "Date and Time API");
features.forEach(n -> System.out.println(n));
```



## 易于"并发编程"
函数式编程不需要考虑"死锁"（deadlock），因为它不修改变量，所以根本不存在"锁"线程的问题。不必担心一个线程的数据，被另一个线程修改，所以可以很放心地把工作分摊到多个线程，部署"并发编程"（concurrency）。


假设一个业务场景：对于20元以上的商品，进行9折处理，最后得到这些商品的折后价格。
```java
final BigDecimal totalOfDiscountedPrices = prices.stream()
.filter(price -> price.compareTo(BigDecimal.valueOf(20)) > 0)
.map(price -> price.multiply(BigDecimal.valueOf(0.9)))
.reduce(BigDecimal.ZERO,BigDecimal::add);

System.out.println("Total of discounted prices: " + totalOfDiscountedPrices);
```


```java
final BigDecimal totalOfDiscountedPrices = prices.parallelStream()
.filter(price -> price.compareTo(BigDecimal.valueOf(20)) > 0)
.map(price -> price.multiply(BigDecimal.valueOf(0.9)))
.reduce(BigDecimal.ZERO,BigDecimal::add);

System.out.println("Total of discounted prices: " + totalOfDiscountedPrices);
```



# Lambda的阴暗面



前面都是讲Lambda如何改变Java程序员的思维习惯，但Lambda确实也带来了困惑

JVM可以执行任何语言编写的代码，只要它们能编译成字节码，字节码自身是充分OO的，被设计成接近于Java语言，这意味着Java被编译成的字节码非常容易被重新组装。

但是如果不是Java语言，差距将越来越大，Scala源码和被编译成的字节码之间巨大差距是一个证明，编译器加入了大量合成类 方法和变量，以便让JVM按照语言自身特定语法和流程控制执行。


我们首先看看Java 6/7中的一个传统方法案例：
```java
// simple check against empty strings
public static int check(String s) {
    if (s.equals("")) {
        throw new IllegalArgumentException();
    }
    return s.length();
}
 
//map names to lengths
 
List lengths = new ArrayList();
 
for (String name : Arrays.asList(args)) {
    lengths.add(check(name));
}
```


如果一个空的字符串传入，这段代码将抛出错误，堆栈跟踪如下：
```java
at LmbdaMain.check(LmbdaMain.java:19)
at LmbdaMain.main(LmbdaMain.java:34)
```


再看看Lambda的例子
```java
Stream lengths = names.stream().map(name -> check(name));
 
at LmbdaMain.check(LmbdaMain.java:19)
at LmbdaMain.lambda$0(LmbdaMain.java:37)
at LmbdaMain$$Lambda$1/821270929.apply(Unknown Source)
at java.util.stream.ReferencePipeline$3$1.accept(ReferencePipeline.java:193)
at java.util.Spliterators$ArraySpliterator.forEachRemaining(Spliterators.java:948)
at java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:512)
at java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:502)
at java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:708)
at java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
at java.util.stream.LongPipeline.reduce(LongPipeline.java:438)
at java.util.stream.LongPipeline.sum(LongPipeline.java:396)
at java.util.stream.ReferencePipeline.count(ReferencePipeline.java:526)
at LmbdaMain.main(LmbdaMain.java:39)
```


这非常类似Scala，出错栈信息太长，我们为代码的精简付出力代价，更精确的代码意味着更复杂的调试。



# 函数式接口


函数式接口（functional interface 也叫功能性接口，其实是同一个东西）。简单来说，函数式接口是只包含一个方法的接口。 @FunctionalInterface作为注解,这个注解是非必须的。



## Lambda语法
包含三个部分
1. 一个括号内用逗号分隔的形式参数，参数是函数式接口里面方法的参数
2. 一个箭头符号：->
3. 方法体，可以是表达式和代码块，方法体函数式接口里面方法的实现，如果是代码块，则必须用{}来包裹起来，且需要一个return 返回值，但有个例外，若函数式接口里面方法返回值是void，则无需{}


总体看起来像这样
```java
(parameters) -> expression 或者 (parameters) -> { statements; }
```


看一个完整的例子，方便理解
```java
/**
 * 测试lambda表达式
 *
 * @author benhail
 */
public class TestLambda {

    public static void runThreadUseLambda() {
        //Runnable是一个函数接口，只包含了有个无参数的，返回void的run方法；
        //所以lambda表达式左边没有参数，右边也没有return，只是单纯的打印一句话
        new Thread(() ->System.out.println("lambda实现的线程")).start(); 
    }

    public static void runThreadUseInnerClass() {
        //这种方式就不多讲了，以前旧版本比较常见的做法
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("内部类实现的线程");
            }
        }).start();
    }

    public static void main(String[] args) {
        TestLambda.runThreadUseLambda();
        TestLambda.runThreadUseInnerClass();
    }
}
```


可以看出，使用lambda表达式设计的代码会更加简洁，而且还可读。



##  方法引用
其实是lambda表达式的一个简化写法，所引用的方法其实是lambda表达式的方法体实现，语法也很简单，左边是容器（可以是类名，实例名），中间是"::"，右边是相应的方法名。如下所示：


```java
ObjectReference::methodName
```


一般方法的引用格式是

1. 如果是静态方法，则是ClassName::methodName。如 Object ::equals
2. 如果是实例方法，则是Instance::methodName。如Object obj=new Object();obj::equals;
3. 构造函数.则是ClassName::new


再来看一个完整的例子，方便理解
```java
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import javax.swing.JButton;
import javax.swing.JFrame;

/**
 *
 * @author benhail
 */
public class TestMethodReference {

    public static void main(String[] args) {

        JFrame frame = new JFrame();
        frame.setLayout(new FlowLayout());
        frame.setVisible(true);
		
        JButton button1 = new JButton("点我!");
        JButton button2 = new JButton("也点我!");
		
        frame.getContentPane().add(button1);
        frame.getContentPane().add(button2);
        //这里addActionListener方法的参数是ActionListener，是一个函数式接口
        //使用lambda表达式方式
        button1.addActionListener(e -> { System.out.println("这里是Lambda实现方式"); });
        //使用方法引用方式
        button2.addActionListener(TestMethodReference::doSomething);
        
    }
    /**
     * 这里是函数式接口ActionListener的实现方法
     * @param e 
     */
    public static void doSomething(ActionEvent e) {
		
        System.out.println("这里是方法引用实现方式");
        
    }
}
```


可以看出，doSomething方法就是lambda表达式的实现，这样的好处就是，如果你觉得lambda的方法体会很长，影响代码可读性，方法引用就是个解决办法