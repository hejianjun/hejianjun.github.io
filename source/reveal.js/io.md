# Java中的IO


## File（文件特征与管理）

Java IO API中的FIle类可以让你访问底层文件系统，通过File类，你可以做到以下几点：

- 检测文件是否存在
- 读取文件长度
- 重命名或移动文件
- 删除文件
- 检测某个路径是文件还是目录
- 读取目录中的文件列表

请注意：File只能访问文件以及文件系统的元数据。如果你想读写文件内容，需要使用FileInputStream、FileOutputStream或者RandomAccessFile。如果你正在使用Java NIO，并且想使用完整的NIO解决方案，你会使用到java.nio.FileChannel(否则你也可以使用File)。


### 实例化一个java.io.File对象

在使用File之前，必须拥有一个File对象，这是实例化的代码例子：
```java
File file = new File("c:\\data\\input-file.txt");
```
很简单，对吗？File类同样拥有多种不同实例化方式的构造函数。


### 检测文件是否存在

当你获得一个File对象之后，可以检测相应的文件是否存在。当文件不存在的时候，构造函数并不会执行失败。你已经准备好创建一个File了，对吧？

通过调用exists()方法，可以检测文件是否存在，代码如下：
```java
File file = new File("c:\\data\\input-file.txt");
boolean fileExists = file.exists();
```


### 文件长度

通过调用length()可以获得文件的字节长度，代码如下：
```java
File file = new File("c:\\data\\input-file.txt");
long length = file.length();
```


### 重命名或移动文件

通过调用File类中的renameTo()方法可以重命名(或者移动)文件，代码如下：
```java
File file = new File("c:\\data\\input-file.txt");
boolean success = file.renameTo(new File("c:\\data\\new-file.txt"));
```


### 删除文件

通过调用delete()方法可以删除文件，代码如下：
```java
File file = new File("c:\\data\\input-file.txt");
boolean success = file.delete();
```
delete()方法与rename()方法一样，返回布尔值表明是否成功删除文件，同样也会有相同的操作失败原因。


### 检测某个路径是文件还是目录

File对象既可以指向一个文件，也可以指向一个目录。可以通过调用isDirectory()方法，可以判断当前File对象指向的是文件还是目录。当方法返回值是true时，File指向的是目录，否则指向的是文件，代码如下：
```java
File file = new File("c:\\data");
boolean isDirectory = file.isDirectory();
```


### 读取目录中的文件列表

你可以通过调用list()或者listFiles()方法获取一个目录中的所有文件列表。list()方法返回当前File对象指向的目录中所有文件与子目录的字符串名称(译者注：不会返回子目录下的文件及其子目录名称)。listFiles()方法返回当前File对象指向的目录中所有文件与子目录相关联的File对象(译者注：与list()方法类似，不会返回子目录下的文件及其子目录)。代码如下：
```java
File file = new File("c:\\data");
String[] fileNames = file.list();
File[] files = file.listFiles();
```


## InputStream And OutputStream(基于字节的io)


**InputStream**（输入流）
---

java.io.InputStream类是所有Java IO输入流的基类。如果你正在开发一个从流中读取数据的组件，请尝试用InputStream替代任何它的子类(比如FileInputStream)进行开发。这么做能够让你的代码兼容任何类型而非某种确定类型的输入流。

然而仅仅依靠InputStream并不总是可行。如果你需要将读过的数据推回到流中，你必须使用PushbackInputStream，这意味着你的流变量只能是这个类型，否则在代码中就不能调用PushbackInputStream的unread()方法。

通常使用输入流中的read()方法读取数据。read()方法返回一个整数，代表了读取到的字节的内容(译者注：0 ~ 255)。当达到流末尾没有更多数据可以读取的时候，read()方法返回-1。

这是一个简单的示例：
```java
InputStream input = new FileInputStream("c:\\data\\input-file.txt");
int data = input.read(); 
while(data != -1){
    data = input.read();
}
```


**OutputStream**（输出流）
---

java.io.OutputStream是Java IO中所有输出流的基类。如果你正在开发一个能够将数据写入流中的组件，请尝试使用OutputStream替代它的所有子类。

这是一个简单的示例：
```java
OutputStream output = new FileOutputStream("c:\\data\\output-file.txt");
output.write("Hello World".getBytes());
output.close();
```


**组合流**
---

你可以将流整合起来以便实现更高级的输入和输出操作。比如，一次读取一个字节是很慢的，所以可以从磁盘中一次读取一大块数据，然后从读到的数据块中获取字节。为了实现缓冲，可以把InputStream包装到BufferedInputStream中。代码示例：
```java
InputStream input = new BufferedInputStream(new FileInputStream("c:\\data\\input-file.txt"));
```
缓冲同样可以应用到OutputStream中。你可以实现将大块数据批量地写入到磁盘(或者相应的流)中，这个功能由BufferedOutputStream实现。

缓冲只是通过流整合实现的其中一个效果。你可以把InputStream包装到PushbackInputStream中，之后可以将读取过的数据推回到流中重新读取，在解析过程中有时候这样做很方便。或者，你可以将两个InputStream整合成一个SequenceInputStream。

将不同的流整合到一个链中，可以实现更多种高级操作。通过编写包装了标准流的类，可以实现你想要的效果和过滤器。


## Reader And Writer(基于字符的io)


**Reader**
---

Reader类是Java IO中所有Reader的基类。子类包括BufferedReader，PushbackReader，InputStreamReader，StringReader和其他Reader。

这是一个简单的Java IO Reader的例子：
```java
Reader reader = new FileReader("c:\\data\\myfile.txt");
int data = reader.read();
while(data != -1){
    char dataChar = (char) data;
    data = reader.read();
}
```

请注意，InputStream的read()方法返回一个字节，意味着这个返回值的范围在0到255之间(当达到流末尾时，返回-1)，Reader的read()方法返回一个字符，意味着这个返回值的范围在0到65535之间(当达到流末尾时，同样返回-1)。这并不意味着Reade只会从数据源中一次读取2个字节，Reader会根据文本的编码，一次读取一个或者多个字节。

你通常会使用Reader的子类，而不会直接使用Reader。Reader的子类包括InputStreamReader，CharArrayReader，FileReader等等。


**整合Reader与InputStream**
---

一个Reader可以和一个InputStream相结合。如果你有一个InputStream输入流，并且想从其中读取字符，可以把这个InputStream包装到InputStreamReader中。把InputStream传递到InputStreamReader的构造函数中：
```java
Reader reader = new InputStreamReader(inputStream);
```
在构造函数中可以指定解码方式。


**Writer**
---

Writer类是Java IO中所有Writer的基类。子类包括BufferedWriter和PrintWriter等等。这是一个Java IO Writer的例子：
```java
Writer writer = new FileWriter("c:\\data\\file-output.txt"); 
writer.write("Hello World Writer"); 
writer.close();
```
同样，你最好使用Writer的子类，不需要直接使用Writer，因为子类的实现更加明确，更能表现你的意图。常用子类包括OutputStreamWriter，CharArrayWriter，FileWriter等。Writer的write(int c)方法，会将传入参数的低16位写入到Writer中，忽略高16位的数据。


**整合Writer和OutputStream**
---

与Reader和InputStream类似，一个Writer可以和一个OutputStream相结合。把OutputStream包装到OutputStreamWriter中，所有写入到OutputStreamWriter的字符都将会传递给OutputStream。这是一个OutputStreamWriter的例子：
```java
Writer writer = new OutputStreamWriter(outputStream);
```


**整合Reader和Writer**
---

和字节流一样，Reader和Writer可以相互结合实现更多更有趣的IO，工作原理和把Reader与InputStream或者Writer与OutputStream相结合类似。举个栗子，可以通过将Reader包装到BufferedReader、Writer包装到BufferedWriter中实现缓冲。以下是例子：
```java
Reader reader = new BufferedReader(new FileReader(...));
Writer writer = new BufferedWriter(new FileWriter(...));
```