ARG PHP_VERSION
FROM flaviovs/php-tools:${PHP_VERSION}

USER root

COPY install-drupal.sh /usr/bin/install-drupal

USER www-data

WORKDIR /var/www

RUN \
	# Install support files using composer \
	export COMPOSER_BIN_DIR=$HOME/bin \
	&& composer global require --no-update \
		dealerdirect/phpcodesniffer-composer-installer \
	&& composer global update --no-dev \
	&& composer global require --no-update \
		drupal/coder \
		drush/drush \
	&& composer global update --no-dev \
	&& rm -rf $HOME/.composer/cache \
	\
	# Install DrupalSecure \
	# See https://www.drupal.org/sandbox/coltrane/1921926 \
	&& git clone --branch master \
		https://git.drupal.org/sandbox/coltrane/1921926.git \
		/tmp/drupal_secure \
	&& mv /tmp/drupal_secure/DrupalSecure \
                $HOME/.composer/vendor/squizlabs/php_codesniffer/src/Standards \
	&& mkdir $HOME/.drush \
	&& mv /tmp/drupal_secure/secure_cs.drush.inc $HOME/.drush \
	\
	# Install PAReview.sh \
	# See https://www.drupal.org/project/pareviewsh \
	&& wget -q -O /tmp/pareviewsh.tgz \
		https://ftp.drupal.org/files/projects/pareviewsh-7.x-1.9.tar.gz\
	&& tar xzf /tmp/pareviewsh.tgz -C /tmp \
	&& mv /tmp/pareviewsh $HOME/.pareviewsh \
	&& ln -s ../.pareviewsh/pareview.sh $HOME/bin \
	\
	# Clean up \
	&& rm -rf /tmp/*

VOLUME /var/www
