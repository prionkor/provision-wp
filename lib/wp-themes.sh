#!/usr/bin/env bash

DEFAULT_THEMES=(
	astra
)

install_default_themes() {

	info "Installing WordPress themes..."

	for theme in "${DEFAULT_THEMES[@]}"; do

		wp theme install "$theme" \
			--activate \
			--path="$SITE_PATH" \
			--allow-root

	done

	success "Themes installed."

}