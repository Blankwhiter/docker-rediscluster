FROM redis:5.0.5
# install ruby env
RUN chmod 777 /usr/local/etc/redis/redis.conf && redis-server stop
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
