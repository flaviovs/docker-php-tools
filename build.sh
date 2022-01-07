set -e 

. ./vars.sh

: "${COMPOSER_VERSION:=2.1.3}"

for V in 5.6 7.3 7.4; do
	TAG="flaviovs/php-tools:$V-$TAG_VERSION"

	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg no_proxy \
		--build-arg "TAG_VERSION=$TAG_VERSION" \
		--build-arg "PHP_VERSION=$V" \
		--build-arg "COMPOSER_VERSION=$COMPOSER_VERSION" \
			-t "$TAG" tools/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi
done
docker tag "$TAG" flaviovs/php-tools:latest-$TAG_VERSION

for V in 5.6 7.3 7.4; do
	TAG="flaviovs/drupal-tools:$V-$TAG_VERSION"
	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg no_proxy \
		--build-arg "TAG_VERSION=$TAG_VERSION" \
		--build-arg "PHP_VERSION=$V" \
			-t "$TAG" drupal/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi
done
docker tag "$TAG" flaviovs/drupal-tools:latest-$TAG_VERSION

for V in 5.6 7.3 7.4; do
	TAG="flaviovs/wordpress-tools:$V-$TAG_VERSION"
	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg no_proxy \
		--build-arg "TAG_VERSION=$TAG_VERSION" \
		--build-arg "PHP_VERSION=$V" \
			-t "$TAG" wordpress/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi
done
docker tag "$TAG" flaviovs/wordpress-tools:latest-$TAG_VERSION
