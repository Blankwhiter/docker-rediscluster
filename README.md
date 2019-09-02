写在前面:为什么要用Redis？高速缓存利用内存保存数据，读写速度远超硬盘。高速缓存可以减少I/O操作，降低I/O压力。最大10万次/秒读写。例如抢红包案例：请求热数据 可以存在高速缓存，请求普通信息存在MySQL。

*注：由于Redis集群对数据是分片存储，即会将数据进行切分，存储在不同的节点上，一旦节点丢失，就会损失这部分数据，故也需要采用主从同步的方式。
Redis集群中应包含奇数个Master，至少应该含有3个Master。当节点挂了很多，能保证能从中进行选举。*
# 第一种 使用belonghuang/rediscluster镜像
镜像地址：https://hub.docker.com/r/belonghuang/rediscluster
<font color='red'>1.适用于redis 5.0以下版本</font>
### 第一步 创建内部网段
  在centos窗口中，运行如下命令:
```bash
docker  network create --subnet=172.19.0.0/16 net2
```

### 第二步 运行Redis容器集群，并启动对应redis
```bash
 docker run -it  --name redis02  -p 6380:6379   --net=net2  --ip 172.19.0.2  -d  belonghuang/redis:4.0.14 bash
 docker exec -it  --name redis02 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis03  -p 6381:6379   --net=net2  --ip 172.19.0.3  -d  belonghuang/redis:4.0.14 bash
 docker exec -it  --name redis03 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis04  -p 6382:6379   --net=net2  --ip 172.19.0.4  -d  belonghuang/redis:4.0.14 bash
 docker exec -it  --name redis04 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis05  -p 6383:6379   --net=net2  --ip 172.19.0.5  -d  belonghuang/redis:4.0.14 bash
 docker exec -it  --name redis05 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis06  -p 6384:6379   --net=net2  --ip 172.19.0.6  -d  belonghuang/redis:4.0.14 bash
 docker exec -it  --name redis06 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis07  -p 6385:6379   --net=net2  --ip 172.19.0.7   -d  belonghuang/redis:4.0.14 bash
 docker exec -it  --name redis07 bash
 redis-server /usr/local/etc/redis/redis.conf
```
*注： 读者可以使用该参数 -v   redis.conf:/usr/local/etc/redis/redis.conf自定义redis配置文件,并且确保六个节点. 该redis版本再5.0以下使用*

### 第三步 创建redis集群
在redis1容器中，执行如下命令
```bash
cd /usr/local/etc/redis/
./redis-trib.rb create --replicas 1 172.19.0.2:6379 172.19.0.3:6379  172.19.0.4:6379   172.19.0.5:6379 172.19.0.6:6379  172.19.0.7:6379 
```
*注 : 该命令可在任一容器执行。  --replicas 1 表示为每个主节点创建从节点。在执行./redis-trib.rb create命令时中间过程需要输入 yes* 

<font color='red'>2.适用于redis 5.0以上版本</font>

### 第一步 创建内部网段
  在centos窗口中，运行如下命令:
```bash
docker  network create --subnet=172.19.0.0/16 net2
```

### 第二步 运行Redis容器集群，并启动对应redis
```bash
 docker run -it  --name redis02  -p 6380:6379   --net=net2  --ip 172.19.0.2  -d  belonghuang/redis bash
 docker exec -it  --name redis02 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis03  -p 6381:6379   --net=net2  --ip 172.19.0.3  -d  belonghuang/redisbash
 docker exec -it  --name redis03 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis04  -p 6382:6379   --net=net2  --ip 172.19.0.4  -d  belonghuang/redisbash
 docker exec -it  --name redis04 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis05  -p 6383:6379   --net=net2  --ip 172.19.0.5  -d  belonghuang/redis bash
 docker exec -it  --name redis05 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis06  -p 6384:6379   --net=net2  --ip 172.19.0.6  -d  belonghuang/redis bash
 docker exec -it  --name redis06 bash
 redis-server /usr/local/etc/redis/redis.conf
```
```bash
 docker run -it  --name redis07  -p 6385:6379   --net=net2  --ip 172.19.0.7   -d  belonghuang/redis bash
 docker exec -it  --name redis07 bash
 redis-server /usr/local/etc/redis/redis.conf
```
*注： 读者可以使用该参数 -v   redis.conf:/usr/local/etc/redis/redis.conf自定义redis配置文件,并且确保六个节点. 该redis版本在5.0以上使用*

### 第三步 创建redis集群
在redis1容器中，执行如下命令
```bash
redis-cli --cluster create  172.19.0.2:6379 172.19.0.3:6379  172.19.0.4:6379   172.19.0.5:6379 172.19.0.6:6379  172.19.0.7:6379  --cluster-replicas 1
```
*注 : 该命令可在任一容器执行。  --replicas 1 表示为每个主节点创建从节点。在执行./redis-trib.rb create命令时中间过程需要输入 yes* 

# 第二种 使用yyyyttttwwww/redis镜像

### 第一步 安装Redis镜像，并重命名
  在centos窗口中，运行如下命令:
```bash
docker pull yyyyttttwwww/redis
docker tag yyyyttttwwww/redis redis
```
### 第二步 创建内部网段
 在centos窗口中，运行如下命令:
```bash
docker  network create --subnet=172.19.0.0/16 net2
```
### 第三步 运行Redis容器
 在centos窗口中，运行如下命令:
```bash
docker  run -it -d --name redis1 -v /usr/local/src/redis/redis.conf:/usr/redis/redis.conf -p 5001:6379 --net=net2 --ip 172.19.0.2 redis bash
```
### 第四步 进入容器并配置启动redis节点
1.进入Redis容器，在centos窗口中，运行如下命令:
```bash
docker exec -it  redis1 bash
```
2.配置Redis节点
redis默认集群是不开启的。修改如下/usr/redis/redis.conf配置文件:
```xml
daemonize yes #以后台进程运行
cluster-enabled yes #开启集群
cluster-config-file nodes.conf #集群配置文件
cluster-node-timeout 15000 #超时时间
appendonly yes #开启AOF模式

```
修改配置完成后，进入到/usr/redis/src目录，启动redis，在centos窗口中执行如下命令:
```bash
cd /usr/redis/src
./redis-server ../redis.conf
```
其他节点请按照上面操作（步骤：1启动容器，2进入容器，3启动redis），启动容器命令如下：
```bash
docker  run -it -d --name redis2 -v /usr/local/src/redis/redis.conf:/usr/redis/redis.conf -p 5002:6379 --net=net2 --ip 172.19.0.3 redis bash
```
```bash
docker  run -it -d --name redis3 -v /usr/local/src/redis/redis.conf:/usr/redis/redis.conf -p 5003:6379 --net=net2 --ip 172.19.0.4 redis bash
```
```bash
docker  run -it -d --name redis4 -v /usr/local/src/redis/redis.conf:/usr/redis/redis.conf -p 5004:6379 --net=net2 --ip 172.19.0.5 redis bash
```
```bash
docker  run -it -d --name redis5 -v /usr/local/src/redis/redis.conf:/usr/redis/redis.conf -p 5005:6379 --net=net2 --ip 172.19.0.6 redis bash
```
```bash
docker  run -it -d --name redis6 -v /usr/local/src/redis/redis.conf:/usr/redis/redis.conf -p 5006:6379 --net=net2 --ip 172.19.0.7 redis bash
```
### 第五步 创建redis集群
在redis1容器中，执行如下命令
```bash
mkdir /usr/redis/cluster
cp /usr/redis/src/redis-trib.rb /usr/redis/cluster/
cd /usr/redis/cluster
./redis-trib.rb create --replicas 1 172.19.0.2:6379 172.19.0.3:6379  172.19.0.4:6379 172.19.0.5:6379 172.19.0.6:6379 172.19.0.7:6379

```
*注 --replicas 1 表示为每个主节点创建从节点。在执行./redis-trib.rb create命令时中间过程需要输入 yes *
### 第六步 验证查看redis集群
在node1容器中，进入/usr/redis/src目录中，执行如下命令，进行连接集群，也可通过cluster nodes 命令查看集群信息：
```bash
root@f1404c1c5b75:/usr/redis/src# ./redis-cli -c
127.0.0.1:6379> set a 123
-> Redirected to slot [15495] located at 172.19.0.4:6379
OK
172.19.0.4:6379> get a
"123"
172.19.0.4:6379> cluster nodes
bb790ba1472498084520057dea49cf626c4b6cab 172.19.0.5:6379 slave 07fac3f635c8e3d83956cb01dc84528588160721 0 1530673095732 4 connected
c80db7aade99d68559d6270ee086bb75b07be4f6 172.19.0.4:6379 myself,master - 0 0 3 connected 10923-16383
b1d17d23130f4f21256ab35393dc05448b0756c0 172.19.0.6:6379 slave c31032354c6a26c0886a0b6968a290ae162ec547 0 1530673101276 5 connected
055be83647f422da460d2da69257b0c0f2b83861 172.19.0.7:6379 slave c80db7aade99d68559d6270ee086bb75b07be4f6 0 1530673098757 6 connected
c31032354c6a26c0886a0b6968a290ae162ec547 172.19.0.3:6379 master - 0 1530673100772 2 connected 5461-10922
07fac3f635c8e3d83956cb01dc84528588160721 172.19.0.2:6379 master - 0 1530673101778 1 connected 0-5460

```
读者也可进入其他redis容器，进行验证，例如进入redis5容器：
```bash
[root@localhost ~]# docker exec -it redis5 bash
root@dddc7476d1da:/# cd /usr/redis/src/
root@dddc7476d1da:/usr/redis/src# ./redis-cli -c
127.0.0.1:6379> cluster nodes
bb790ba1472498084520057dea49cf626c4b6cab 172.19.0.5:6379 slave 07fac3f635c8e3d83956cb01dc84528588160721 0 1530673917656 4 connected
b1d17d23130f4f21256ab35393dc05448b0756c0 172.19.0.6:6379 myself,slave c31032354c6a26c0886a0b6968a290ae162ec547 0 0 5 connected
07fac3f635c8e3d83956cb01dc84528588160721 172.19.0.2:6379 master - 0 1530673916647 1 connected 0-5460
c80db7aade99d68559d6270ee086bb75b07be4f6 172.19.0.4:6379 master - 0 1530673912617 3 connected 10923-16383
055be83647f422da460d2da69257b0c0f2b83861 172.19.0.7:6379 slave c80db7aade99d68559d6270ee086bb75b07be4f6 0 1530673914628 6 connected
c31032354c6a26c0886a0b6968a290ae162ec547 172.19.0.3:6379 master - 0 1530673911610 2 connected 5461-10922
127.0.0.1:6379> get a
-> Redirected to slot [15495] located at 172.19.0.4:6379
"123"

```
最后读者可以停止某个节点，看它对应的节点是否变成了主节点（读者请自行验证）。



### 附录：
redis集群基于redis-trib实现，但不方便创建管理集群，网上已有人基于ruby编写了redis-trib.rb，简易的实现方便管理reids集群。由于 yyyyttttwwww/redis 已经集成该redis-trib.rb环境，教程上面就不涉及安装教程。
如有兴趣对redis-trib.rb感兴趣，可通过下方链接了解源码。redis集成redis-trib.rb环境读者请自行实现。
在某个redis容器中 执行如下几条命令，集成ruby环境:
```bash
apt-get install ruby-full 
apt-get install rubygems
gem install redis
```

*注：1 $  sudo yum install ruby    # CentOS, Fedora, 或 RHEL 系统 2. sudo apt-get install ruby-full # Debian 或 Ubuntu 系统*
redis-trib.rb 文件地址：[https://fossies.org/linux/redis/src/redis-trib.rb](https://fossies.org/linux/redis/src/redis-trib.rb)
本人已上传到百度网盘中，读者可自行下载。网盘地址：[https://pan.baidu.com/s/1DuNrBv7jdUflVkNYGgRe-w](https://pan.baidu.com/s/1DuNrBv7jdUflVkNYGgRe-w)

redis图形工具（redisDesktop）：[https://redisdesktop.com/download](https://redisdesktop.com/download)



 




 
