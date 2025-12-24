#!/bin/sh
set -e

: "${DOMAIN:=lferro.42.fr}"

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
		-subj "/CN=${DOMAIN}" \
		-addext "subjectAltName=DNS:${DOMAIN}" \
		-keyout /etc/nginx/ssl/inception.key \
		-out /etc/nginx/ssl/inception.crt
fi

envsubst '$DOMAIN' </etc/nginx/nginx.conf.template >/etc/nginx/nginx.conf

exec nginx -g "daemon off;"
