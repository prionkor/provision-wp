#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Core
source "$SCRIPT_DIR/lib/context.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/cleanup.sh"

# Validation
source "$SCRIPT_DIR/lib/validation.sh"

# Platform
source "$SCRIPT_DIR/lib/php.sh"
source "$SCRIPT_DIR/lib/webserver.sh"
source "$SCRIPT_DIR/lib/mysql.sh"

# WordPress
source "$SCRIPT_DIR/lib/wordpress.sh"
source "$SCRIPT_DIR/lib/wp-plugins.sh"
source "$SCRIPT_DIR/lib/wp-themes.sh"

trap cleanup ERR

# install_site() {

# 	initialize_webserver

# 	create_site_directory

# 	create_database
# 	create_database_user
# 	grant_database_permissions

# 	download_wordpress
# 	create_wp_config

# 	create_site
# 	reload_webserver

# 	install_wordpress

# 	install_default_plugins
# 	install_default_themes

# 	set_permissions
# }

install_site() {

	info "Validation successful."

}

main() {
	print_banner

	require_root

	validate_system

	detect_php

	detect_webservers
	choose_webserver

	collect_site_information
	collect_database_information
	validate_configuration

	confirm_installation

	install_site

	cleanup_success
}

main "$@"
