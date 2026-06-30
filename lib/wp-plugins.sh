#!/usr/bin/env bash

DEFAULT_PLUGINS=(
	akismet
	wordpress-seo
	wordfence
	all-in-one-wp-migration
	wpvulnerability
	header-footer-code-manager
	ultimate-addons-for-gutenberg
	safe-svg
	duplicate-post
)

install_default_plugins() {

	info "Installing WordPress plugins..."

	for plugin in "${DEFAULT_PLUGINS[@]}"; do

		wp plugin install "$plugin" \
			--activate \
			--path="$SITE_PATH" \
			--allow-root

	done

	success "Plugins installed."
}