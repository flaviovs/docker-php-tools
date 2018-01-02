set -e

sh build.sh

for V in latest 5.6 7.0 7.1 7.2; do
	TAG="flaviovs/php-tools:$V"
	DRUPAL_TAG="flaviovs/drupal-tools:$V"
	WORDPRESS_TAG="flaviovs/wordpress-tools:$V"

	docker push "$TAG"
	if [ "$V" != "7.2" ]; then
		docker push "$DRUPAL_TAG"
	fi
	docker push "$WORDPRESS_TAG"
done

