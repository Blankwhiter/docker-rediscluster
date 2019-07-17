FROM redis:4.0.14
# install ruby env
RUN apt-get update && apt-get -y install ruby-full  && apt-get -y install rubygems && gem install redis
# copy redis.conf :config cluster
COPY redis.conf /usr/local/etc/redis/redis.conf
# copy ruby script
COPY redis-trib.rb  /usr/local/etc/redis/redis-trib.rb
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
