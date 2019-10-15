FROM debian:buster-slim

ARG COMPOSER_VERSION

ENV DOCUMENT_ROOT=/srv/www
ENV COMPOSER_HOME=/usr/lib/composer

RUN export DEBIAN_FRONTEND=noninteractive \
	\
	# Install packages \
	&& apt-get update \
	&& apt-get -y install --no-install-recommends \
		acl \
		bzip2 \
		ca-certificates \
		closure-compiler \
		codespell \
		curl \
		geoip-database \
		geoip-database-extra \
		git \
		git-ftp \
		gnupg \
		gulp \
		host \
		iputils-ping \
		less \
		mariadb-client \
		msmtp \
		nodejs \
		npm \
		patch \
		postgresql-client \
		procps \
		redis-tools \
		rename \
		rsync \
		sassc \
		ssh-client \
		sudo \
		telnet \
		vim \
		wget \
		yui-compressor \
	&& rm -rf /usr/share/man/* \
	\
	# Setup sudo \
	&& echo "www-data ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/local \
	&& chmod 440 /etc/sudoers.d/local \
	\
	# Setup msmtp \
	&& echo 'host mail' > /etc/msmtprc \
	\
	# Install composer \
	&& wget -q -O /usr/bin/composer \
		https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
	&& chmod 755 /usr/bin/composer \
	\
	# Create www-data home & data directory \
	&& install -d -o www-data -g www-data /var/www $DOCUMENT_ROOT \
	\
	# Install node utilities \
	&& npm install -g \
		eslint \
		uncss \
	\
	# Final setup & clean up \
	&& rm -rf /tmp/* \
	\
	# Remove sendmail -- will be replaced by our script \
	&& rm -f /usr/sbin/sendmail \
	\
	# Allow history back/forward just by up/down arrow \
	&& echo '"\\e[A": history-search-backward' >> /etc/inputrc \
	&& echo '"\\e[B": history-search-forward' >> /etc/inputrc

ARG PHP_VERSION
RUN \
	export DEBIAN_FRONTEND=noninteractive \
	&& case "$PHP_VERSION" in \
	7.3) \
		# Use busters's PHP 7.3 \
		;; \
	*) \
		# Install sury.org repository \
		echo "deb https://packages.sury.org/php/ buster main" \
			>> /etc/apt/sources.list \
		&& wget -O /etc/apt/trusted.gpg.d/php.gpg \
			https://packages.sury.org/php/apt.gpg \
		\
		&& apt-get update \
		;; \
	esac \
	\
	&& apt-get -y install --no-install-recommends \
		php${PHP_VERSION}-bcmath \
		php${PHP_VERSION}-cli \
		php${PHP_VERSION}-curl \
		php${PHP_VERSION}-gd \
		php${PHP_VERSION}-geoip \
		php${PHP_VERSION}-intl \
		php${PHP_VERSION}-json \
		php${PHP_VERSION}-mbstring \
		php${PHP_VERSION}-mysql \
		php${PHP_VERSION}-pgsql \
		php${PHP_VERSION}-pspell \
		php${PHP_VERSION}-readline \
		php${PHP_VERSION}-redis \
		php${PHP_VERSION}-soap \
		php${PHP_VERSION}-sqlite \
		php${PHP_VERSION}-xmlrpc \
		php${PHP_VERSION}-xml \
		php${PHP_VERSION}-zip \
	\
	# Version specific packages \
	&& case "${PHP_VERSION}" in \
	5.6|7.0|7.1) \
		apt-get -y install --no-install-recommends \
			php${PHP_VERSION}-mcrypt \
		;; \
	esac \
	\
	# Enable assertion control \
	&& sed -i -e 's/^zend.assertions\b.*/zend.assertions = 0/' \
		/etc/php/*/cli/php.ini \
	\
	# Install default shell files and directories \
	&& cp /etc/skel/.??* /var/www \
	&& mkdir /var/www/bin \
	&& chown www-data:www-data -R /var/www \
	\
	# Clean up \
	&& rm -rf /var/lib/apt/lists/* \
	\
	# Setup composer \
	&& sudo install -d -o www-data -g www-data $COMPOSER_HOME \
	&& sudo -u www-data env COMPOSER_HOME=$COMPOSER_HOME \
		composer global require --no-update \
			dealerdirect/phpcodesniffer-composer-installer \
	&& sudo -u www-data env COMPOSER_HOME=$COMPOSER_HOME \
		composer global update --no-dev --classmap-authoritative \
	&& sudo ln -nsf $COMPOSER_HOME/vendor/bin/* /usr/bin \
	&& rm -rf $HOME/.composer/cache

COPY bin/* /usr/bin/
COPY sbin/* /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-shell"]
CMD ["/bin/bash", "--login"]
