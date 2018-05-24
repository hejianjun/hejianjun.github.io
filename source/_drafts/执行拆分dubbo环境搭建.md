# dubbo服务

- 首先应该搭建zookeeper
- 部署war包
- 修改配置
- 然后运行TAS

## 搭建zookeeper

这个就非常简单了
```bash
wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.5.2-alpha/zookeeper-3.5.2-alpha.tar.gz
tar zxvf zookeeper-3.5.2-alpha.tar.gz
cd zookeeper-3.5.2-alpha
cp conf/zoo_sample.cfg conf/zoo.cfg
bin/zkServer.sh start
```
## 停止 ZooKeeper 服务
```bash
bin/zkServer.sh stop
```

