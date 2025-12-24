FROM alpine:3.22.2

RUN apk add --no-cache nginx curl vim openssl gettext

RUN mkdir -p /etc/nginx/ssl /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf.template
COPY html/ /var/www/html/
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
