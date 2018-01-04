set -e

DRUPAL_VERSION="${1:-8}"
DEST="${2-/srv/app}"

if [ $(whoami) = "root" ]; then
	echo "$0 must not be run as root" 1>&2
	exit 1
fi

if [ "$DRUPAL_VERSION" != "7" -a "$DRUPAL_VERSION" != "8" ]; then
	echo "$0: only Drupal 7 and 8 are supported, not $DRUPAL_VERSION" 1>&2
	exit 1
fi

echo "Installing Drupal $DRUPAL_VERSION on $DEST"

composer create-project --no-dev --no-install \
	"drupal-composer/drupal-project:$DRUPAL_VERSION.x-dev" \
	"$DEST" --stability dev --no-interaction

cd "$DEST"


composer config minimum-stability "rc"

# Install with --no-update so that composer does not update,
# which would bring in dev dependencies.
composer require --no-update drupal/admin_toolbar

# Now bring everything in.
composer update --no-dev

if [ "$ACCOUNT_EMAIL" != "" -a "$DB_USER" != "" \
	-a "$DB_PASS" != "" -a "$DB_NAME" != "" ]; then
	
	cd web

	nr_tables=$(mysqlshow -u "$DB_USER" -p"$DB_PASS" -h mysql "$DB_NAME" | sed -e '1,4d' -e '$d' | wc -l)
	if [ "$nr_tables" -ne 0 ]; then
		echo "Database $DB_NAME has data -- Drupal setup skipped" 1>&2
		exit 0
	fi

	PASSWORD=$(openssl rand -base64 6)
	drush site-install \
		--account-mail="$ACCOUNT_EMAIL" \
		--account-name="Admin" \
		--account-pass="$PASSWORD" \
		--db-url="mysql://$DB_USER:$DB_PASS@mysql/$DB_NAME" \
		--site-mail="$ACCOUNT_EMAIL"
	echo "Drupal admin account \"Admin\" created, password is \"$PASSWORD\""

	# Create an option file that connects straight to the database.
	if [ ! -f "$HOME/.my.cnf" ]; then
		echo "[client]" > "$HOME/.my.cnf"
		echo "user=$DB_USER" >> "$HOME/.my.cnf"
		echo "password=$PASSWORD" >> "$HOME/.my.cnf"
		echo "host=mysql" >> "$HOME/.my.cnf"
		echo "database=$DB_NAME" >> "$HOME/.my.cnf"
		chmod 600 "$HOME/.my.cnf"
	fi
fi
