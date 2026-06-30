#!/usr/bin/env bash

collect_site_information() {

	info "WordPress Site Configuration"

	DOMAIN="$(prompt "Domain Name")"
	SSL_ADMIN_EMAIL="$(prompt "SSL Admin Email")"

	WP_TITLE="$(prompt "Site Title")"

	WP_ADMIN_USER="$(prompt "Admin Username")"
	WP_ADMIN_PASSWORD="$(prompt_password "Admin Password")"
	WP_ADMIN_EMAIL="$(prompt "Admin Email")"

	SITE_ROOT="/var/www/${DOMAIN}"
	SITE_PATH="${SITE_ROOT}/html"

}

create_site_directory() {

	info "Creating site directory..."

	[[ ! -d "$SITE_ROOT" ]] \
		|| die "Site directory already exists: $SITE_ROOT"

	mkdir -p "$SITE_PATH"

    register_cleanup "rm -rf '$SITE_ROOT'"

	chown -R "$SUDO_USER":"$SUDO_USER" "$SITE_ROOT"

	SITE_DIRECTORY_CREATED="true"

	success "Created site directory."

}

download_wordpress() {

	info "Downloading WordPress..."

	wp core download \
		--path="$SITE_PATH" \
		--allow-root

	success "WordPress downloaded."

}

create_wp_config() {

	info "Creating wp-config.php..."

	wp config create \
		--path="$SITE_PATH" \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_PASSWORD" \
		--dbhost="${DB_HOST}:${DB_PORT}" \
		--allow-root

	success "Created wp-config.php."

}

install_wordpress() {

	info "Installing WordPress..."

	wp core install \
		--path="$SITE_PATH" \
		--url="https://${DOMAIN}" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root

	success "WordPress installed."

}

set_permissions() {

	info "Setting permissions..."

	chown -R www-data:www-data "$SITE_ROOT"

	find "$SITE_ROOT" -type d -exec chmod 755 {} \;

	find "$SITE_ROOT" -type f -exec chmod 644 {} \;

	success "Permissions updated."

}

