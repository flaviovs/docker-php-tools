FROM debian:bookworm-slim

ARG TAG_VERSION

ENV DOCUMENT_ROOT=/srv/www
ENV COMPOSER_HOME=/usr/lib/composer

RUN export DEBIAN_FRONTEND=noninteractive \
	\
	# Install packages \
	&& apt-get update \
	&& apt-get -y install --no-install-recommends \
		acl \
		ansible \
		bzip2 \
		ca-certificates \
		closure-compiler \
		codespell \
		curl \
		geoip-database \
		git \
		git-ftp \
		gnupg \
		gulp \
		host \
		iputils-ping \
		less \
		libmemcached-tools \
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
		sasl2-bin \
		sassc \
		ssh-client \
		sudo \
		telnet \
		vim \
		vim-addon-manager \
		vim-editorconfig \
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
	# Setup vim \
	&& vim-addon-manager --system-wide install editorconfig \
	\
	# Create www-data home & data directory \
	&& install -d -o www-data -g www-data /var/www $DOCUMENT_ROOT \
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
	8.2) \
                # Use native PHP version \
                APT_VERSION="" \
		;; \
	*) \
		# Install sury.org repository \
		echo "deb https://packages.sury.org/php/ bookworm main" \
			>> /etc/apt/sources.list \
		&& wget -O /etc/apt/trusted.gpg.d/php.gpg \
			https://packages.sury.org/php/apt.gpg \
		\
		&& apt-get update \
                && APT_VERSION="$PHP_VERSION" \
		;; \
	esac \
	\
	&& apt-get -y install --no-install-recommends \
		php${APT_VERSION}-bcmath \
		php${APT_VERSION}-cli \
		php${APT_VERSION}-curl \
		php${APT_VERSION}-gd \
		php${APT_VERSION}-igbinary \
		php${APT_VERSION}-intl \
		php${APT_VERSION}-imap \
		php${APT_VERSION}-json \
		php${APT_VERSION}-mailparse \
		php${APT_VERSION}-mbstring \
		php${APT_VERSION}-memcached \
		php${APT_VERSION}-mysql \
		php${APT_VERSION}-pgsql \
		php${APT_VERSION}-pspell \
		php${APT_VERSION}-readline \
		php${APT_VERSION}-redis \
		php${APT_VERSION}-soap \
		php${APT_VERSION}-xmlrpc \
		php${APT_VERSION}-xml \
		php${APT_VERSION}-zip \
	\
	# Version specific packages \
	&& case "${PHP_VERSION}" in \
        7.4) \
		apt-get -y install --no-install-recommends \
			php${APT_VERSION}-geoip \
                        php${APT_VERSION}-sqlite \
		;; \
        8.2) \
		apt-get -y install --no-install-recommends \
			php${APT_VERSION}-maxminddb \
                        php${APT_VERSION}-sqlite3 \
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
	&& rm -rf /var/lib/apt/lists/*

ARG COMPOSER_VERSION
RUN \
	# Install composer \
	wget -q -O /usr/bin/composer \
		https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar \
	&& chmod 755 /usr/bin/composer \
	\
	# Setup composer \
	&& sudo install -d -o www-data -g www-data $COMPOSER_HOME \
	&& sudo -u www-data env COMPOSER_HOME=$COMPOSER_HOME \
		composer global require --no-update \
			dealerdirect/phpcodesniffer-composer-installer \
			jakub-onderka/php-parallel-lint \
			jakub-onderka/php-console-highlighter \
	&& sudo -u www-data env COMPOSER_HOME=$COMPOSER_HOME \
		composer global update --no-dev --classmap-authoritative \
	&& sudo ln -nsf $COMPOSER_HOME/vendor/bin/* /usr/bin \
	&& rm -rf $COMPOSER_HOME/cache \
	&& echo 'COMPOSER_CACHE_DIR=$HOME/.composer/cache' >> /etc/skel/.profile \
	&& echo 'export COMPOSER_CACHE_DIR' >> /etc/skel/.profile

COPY bin/* /usr/bin/
COPY sbin/* /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-shell"]
CMD ["/bin/bash", "--login"]
