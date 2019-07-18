FROM redis:5.0.5
COPY redis.conf /usr/local/etc/redis/redis.conf
RUN chmod 777 /usr/local/etc/redis/redis.conf 
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
