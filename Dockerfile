FROM redis:5.0.5
# install ruby env
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
