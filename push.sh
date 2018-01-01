set -e

sh build.sh

for V in 5.6 7.0 7.1 7.2; do
	TAG="flaviovs/php-tools:$V"
	DRUPAL_TAG="flaviovs/drupal-tools:$V"
	WORDPRESS_TAG="flaviovs/wordpress-tools:$V"

	docker push "$TAG"
	docker push "$DRUPAL_TAG"
	docker push "$WORDPRESS_TAG"
done

docker tag "$TAG" flaviovs/php-tools:latest
docker tag "$DRUPAL_TAG" flaviovs/drupal-tools:latest
docker tag "$WORDPRESS_TAG" flaviovs/wordpress-tools:latest
