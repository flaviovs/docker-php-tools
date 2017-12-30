ARG PHP_VERSION

FROM php-tools:${PHP_VERSION}

USER root

RUN \
	# Install WP-CLI \
	wget -q -O /usr/bin/wp \
		https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod 755 /usr/bin/wp

USER www-data
WORKDIR /var/www

RUN \
	# Install WPCS \
	composer \
		create-project wp-coding-standards/wpcs \
		--no-dev \
			.wpcs \
	&& (cd bin; ln -s ../.wpcs/vendor/bin/* .) \
	&& rm -rf $HOME/.composer/cache

VOLUME /var/www
