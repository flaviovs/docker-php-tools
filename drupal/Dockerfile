ARG PHP_VERSION
FROM flaviovs/php-tools:${PHP_VERSION}-buster

USER www-data

WORKDIR /var/www

RUN \
	# Install support files using composer \
	export COMPOSER_HOME=/usr/lib/composer \
	&& sudo install -d -o www-data -g www-data $COMPOSER_HOME \
	&& composer global require --no-update \
		dealerdirect/phpcodesniffer-composer-installer \
	&& composer global update --no-dev \
	&& composer global require --no-update \
		"drupal/coder" \
		"drush/drush:8.*" \
	&& composer global update --no-dev \
	&& rm -rf $COMPOSER_HOME/cache \
	\
	# Install PAReview.sh \
	# See https://www.drupal.org/project/pareviewsh \
	&& wget -q -O /tmp/pareviewsh.tgz \
		https://ftp.drupal.org/files/projects/pareviewsh-7.x-1.9.tar.gz\
	&& tar xzf /tmp/pareviewsh.tgz -C /tmp \
	&& sudo mv /tmp/pareviewsh /usr/lib \
	&& sudo ln -s /usr/lib/pareviewsh/pareview.sh /usr/bin/pareview \
	\
	&& sudo ln -nsf /usr/lib/composer/vendor/bin/* /usr/bin \
	\
	# Clean up \
	&& sudo chown -R 0:0 /usr/lib/composer /usr/lib/pareviewsh \
	&& rm -rf /tmp/*

USER root

COPY install-drupal.sh /usr/bin/install-drupal

COPY vimrc.local /etc/vim/

VOLUME /var/www
