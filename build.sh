set -e 

: "${COMPOSER_VERSION:=1.5.6}"
: "${NODE_MAJOR:=6}"

for V in 5.6 7.0 7.1 7.2; do
	TAG="php-tools:$V"
	DRUPAL_TAG="drupal-tools:$V"
	WORDPRESS_TAG="wordpress-tools:$V"

	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg "PHP_VERSION=$V" \
		--build-arg "COMPOSER_VERSION=$COMPOSER_VERSION" \
		--build-arg "NODE_MAJOR=$NODE_MAJOR" \
			-t "$TAG" tools/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi

	echo "Building $DRUPAL_TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg "PHP_VERSION=$V" \
			-t "$DRUPAL_TAG" drupal/; then
		echo "Failed building $DRUPAL_TAG" 1>&2
		exit 1
	fi

	echo "Building $WORDPRESS_TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg "PHP_VERSION=$V" \
			-t "$WORDPRESS_TAG" wordpress/; then
		echo "Failed building $WORDPRESS_TAG" 1>&2
		exit 1
	fi
done

docker tag "$TAG" php-tools:latest
docker tag "$DRUPAL_TAG" drupal-tools:latest
docker tag "$WORDPRESS_TAG" wordpress-tools:latest
