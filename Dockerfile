FROM centos:7.5.1804
RUN yum -y update && yum -y install epel-release && yum -y install redis
EXPOSE 6379
RUN yum clean all
# copy redis.conf :config cluster
COPY redis.conf /usr/local/etc/redis/redis.conf
ENTRYPOINT  [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
CMD []
