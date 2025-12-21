#!/bin/sh
set -e

: "${DOMAIN:=localhost}"

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
		-keyout /etc/nginx/ssl/inception.key \
		-out /etc/nginx/ssl/inception.crt \
		-subj "/CN=${DOMAIN}" \
		-addext "subjectAltName=DNS:${DOMAIN}"
fi

envsubst '$DOMAIN' </etc/nginx/nginx.conf.template >/etc/nginx/nginx.conf

exec nginx -g "daemon off;"
