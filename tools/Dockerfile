FROM debian:stretch-slim

ARG COMPOSER_VERSION
ARG NODE_MAJOR

ENV DOCUMENT_ROOT=/srv/www

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update \
	&& apt-get -y install \
		apt-transport-https \
		ca-certificates \
		gnupg \
		wget \
	&& apt-get update \
	\
	# Install nodejs DEB source \
	&& echo "deb https://deb.nodesource.com/node_${NODE_MAJOR}.x stretch main" \
		>> /etc/apt/sources.list \
	&& wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
		| apt-key add - \
	&& apt-get update \
	\
	# Create man directory to avoid error when installing some packages \
	&& mkdir -p /usr/share/man/man1/ /usr/share/man/man7/ \
	\
	# Install packages \
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
		host \
		iputils-ping \
		less \
		mariadb-client \
		nodejs \
		patch \
		postgresql-client \
		procps \
		rename \
		rsync \
		ssh-client \
		ssmtp \
		sudo \
		telnet \
		vim \
		yui-compressor \
	&& rm -rf /usr/share/man/* \
	\
	# Setup sudo \
	&& echo "www-data ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/local \
	&& chmod 440 /etc/sudoers.d/local \
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
	7.0) \
		# Use stretch's PHP 7.0 \
		;; \
	*) \
		# Install sury.org repository \
		echo "deb https://packages.sury.org/php/ stretch main" \
			>> /etc/apt/sources.list \
		&& wget -q -O - https://packages.sury.org/php/apt.gpg \
			| apt-key add - \
		\
		&& apt-get update \
		;; \
	esac \
	\
	&& apt-get -y install --no-install-recommends \
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
	# Install default shell files and directories \
	&& cp /etc/skel/.??* /var/www \
	&& mkdir /var/www/bin \
	&& chown www-data:www-data -R /var/www \
	\
	# Clean up \
	&& rm -rf /var/lib/apt/lists/*

COPY bin/* /usr/bin/
COPY sbin/* /usr/sbin/

ENTRYPOINT ["/usr/sbin/start-shell"]
CMD ["/bin/bash", "--login"]
