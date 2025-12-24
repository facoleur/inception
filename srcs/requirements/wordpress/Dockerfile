FROM debian:bookworm

RUN apt-get update
RUN apt-get -y install wget

ARG WP_ZIP=wordpress-6.9.tar.gz
ARG PHP_VERSION=8.2


RUN apt-get install -y \
php${PHP_VERSION} \
php${PHP_VERSION}-fpm \
php${PHP_VERSION}-mysql \
rsync \
mariadb-client

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/${WP_ZIP} -P /var/www/html

RUN cd /var/www/html \
	&& tar -xzf ${WP_ZIP} \
	&& mv wordpress /usr/src/wordpress \
	&& rm ${WP_ZIP}

RUN		chown -R root:root /var/www/html
COPY conf/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini


COPY conf/autoconfig.sh /usr/local/bin/autoconfig.sh
RUN chmod +x /usr/local/bin/autoconfig.sh


EXPOSE 9000

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# CMD ["sh", "-c", "/usr/local/bin/autoconfig.sh && php-fpm8.2 -F"]
CMD ["sh", "-c", "rsync -a /usr/src/wordpress/. /var/www/html/ && /usr/local/bin/autoconfig.sh && php-fpm8.2 -F"]
