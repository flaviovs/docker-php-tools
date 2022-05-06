set -e

sh build.sh

. ./vars.sh

for V in latest 5.6 7.3 7.4; do
	TAG="flaviovs/php-tools:$V-$TAG_VERSION"
	DRUPAL_TAG="flaviovs/drupal-tools:$V-$TAG_VERSION"
	WORDPRESS_TAG="flaviovs/wordpress-tools:$V-$TAG_VERSION"

	docker push "$TAG"
	docker push "$DRUPAL_TAG"
	docker push "$WORDPRESS_TAG"
done

