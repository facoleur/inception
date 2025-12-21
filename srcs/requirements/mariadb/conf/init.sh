#!/bin/sh
set -e

DATADIR=/var/lib/mysql
SOCKET=/run/mysqld/mysqld.sock

mkdir -p /run/mysqld "$DATADIR"
chown -R mysql:mysql /run/mysqld "$DATADIR"

if [ ! -f "$DATADIR/.init_done" ]; then
	if [ ! -d "$DATADIR/mysql" ]; then
		mariadb-install-db \
			--user=mysql \
			--datadir="$DATADIR"
	fi

	mariadbd \
		--user=mysql \
		--datadir="$DATADIR" \
		--socket="$SOCKET" \
		--skip-networking &

	while ! mysqladmin --socket="$SOCKET" ping --silent; do
		sleep 1
	done

	mysql --socket="$SOCKET" -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	mysqladmin --socket="$SOCKET" -u root -p"${SQL_ROOT_PASSWORD}" shutdown
	touch "$DATADIR/.init_done"
fi

exec mariadbd \
	--user=mysql \
	--datadir="$DATADIR" \
	--socket="$SOCKET" \
	--bind-address=0.0.0.0
