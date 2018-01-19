ARG PHP_VERSION

FROM flaviovs/php-tools:${PHP_VERSION}

USER www-data
WORKDIR /var/www

RUN \
	# Install WPCS \
	composer \
		create-project wp-coding-standards/wpcs \
		--no-dev \
			/tmp/wpcs \
	&& sudo mv /tmp/wpcs /usr/lib \
	&& sudo chown -R 0:0 /usr/lib/wpcs \
	&& sudo ln -s /usr/lib/wpcs/vendor/bin/* /usr/bin \
	&& rm -rf $HOME/.composer/cache

USER root

RUN \
	# Install WP-CLI \
	wget -q -O /usr/bin/wp \
		https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod 755 /usr/bin/wp

VOLUME /var/www
