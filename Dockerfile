FROM redis:5.0.5
# install ruby env
RUN apt-get -y install ruby  && apt-get -y install rubygems && gem install redis
# copy redis.conf :config cluster
COPY redis.conf /usr/local/etc/redis/redis.conf
# copy ruby script
COPY redis-trib.rb  /usr/local/etc/redis/redis-trib.rb
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]