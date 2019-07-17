FROM redis:5.0.5
# copy redis.conf :config cluster
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
