FROM debian:buster-slim
RUN apt-get -y update  && apt-get -y install redis
RUN apt-get clean 
# install ruby env
RUN apt-get update && apt-get -y install ruby-full  && apt-get -y install rubygems && gem install redis
# copy redis.conf :config cluster
COPY redis.conf /usr/local/etc/redis/redis.conf
# copy ruby script
COPY redis-trib.rb  /usr/local/etc/redis/redis-trib.rb
RUN chmod 777  /usr/local/etc/redis/redis-trib.rb
ENTRYPOINT [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
EXPOSE 6379
CMD []
