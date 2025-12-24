FROM alpine:3.22.2

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils

RUN sed -i '/^skip-networking$/d' /etc/my.cnf.d/mariadb-server.cnf

RUN mkdir -p /run/mysqld /var/lib/mysql \
 && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/50-server.cnf /etc/my.cnf.d/50-server.cnf
COPY conf/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
