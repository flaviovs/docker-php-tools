ARG TAG_VERSION
ARG PHP_VERSION

FROM flaviovs/php-tools:${PHP_VERSION}-${TAG_VERSION}

USER www-data
WORKDIR /var/www

RUN \
	# Install WPCS \
	composer global require wp-coding-standards/wpcs --update-no-dev --no-progress \
	&& rm -rf $HOME/.composer/cache

USER root

RUN \
	# Install WP-CLI \
	wget -q -O /usr/bin/wp \
		https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod 755 /usr/bin/wp

VOLUME /var/www
