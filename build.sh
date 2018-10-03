set -e 

: "${COMPOSER_VERSION:=1.7.2}"
: "${NODE_MAJOR:=6}"

for V in 5.6 7.0 7.1 7.2; do
	TAG="flaviovs/php-tools:$V"

	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg no_proxy \
		--build-arg "PHP_VERSION=$V" \
		--build-arg "COMPOSER_VERSION=$COMPOSER_VERSION" \
		--build-arg "NODE_MAJOR=$NODE_MAJOR" \
			-t "$TAG" tools/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi
done
docker tag "$TAG" flaviovs/php-tools:latest

# NB: Build only on PHP <= 7.1, because PHP 7.2 is not well
# supported as of Dec 2017
for V in 5.6 7.0 7.1; do
	TAG="flaviovs/drupal-tools:$V"
	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg no_proxy \
		--build-arg "PHP_VERSION=$V" \
			-t "$TAG" drupal/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi
done
docker tag "$TAG" flaviovs/drupal-tools:latest

for V in 5.6 7.0 7.1 7.2; do
	TAG="flaviovs/wordpress-tools:$V"
	echo "Building $TAG"
	if ! docker build \
		--build-arg http_proxy \
		--build-arg no_proxy \
		--build-arg "PHP_VERSION=$V" \
			-t "$TAG" wordpress/; then
		echo "Failed building $TAG" 1>&2
		exit 1
	fi
done
docker tag "$TAG" flaviovs/wordpress-tools:latest
