#!/bin/sh

set -e

until mariadb -h mariadb -u"${SQL_USER}" -p"${SQL_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1; do
	echo "Waiting for MariaDB..." >&2
	sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Generating custom wp-config.php..."
	wp config create --allow-root \
		--dbname="${SQL_DATABASE}" \
		--dbuser="${SQL_USER}" \
		--dbpass="${SQL_PASSWORD}" \
		--dbhost="mariadb:3306" \
		--path='/var/www/html'
	echo "Done"
fi

if ! wp core is-installed --allow-root --path='/var/www/html'; then
	echo "Running initial WordPress installation..."
	wp core install --allow-root \
		--url="${WP_URL}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--path='/var/www/html'

	if ! wp user get "${WP_USER}" --allow-root --path='/var/www/html' >/dev/null 2>&1; then
		wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
			--user_pass="${WP_USER_PASSWORD}" \
			--role=author \
			--allow-root \
			--path='/var/www/html'
	fi
fi
