FROM redis:5.0.5
RUN apt-get -y install ruby  && apt-get -y install rubygems && gem install redis
COPY redis.conf /usr/local/etc/redis/redis.conf
COPY redis-trib.rb  /usr/local/etc/redis/redis-trib.rb
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]