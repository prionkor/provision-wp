#!/usr/bin/env bash

########################################
# Root Check
########################################

require_root() {
    [[ $EUID -eq 0 ]] || die "This script must be run as root."
}

########################################
# Operating System
########################################

validate_os() {

    [[ -f /etc/os-release ]] || die "Unable to determine operating system."

    . /etc/os-release

    OS="$NAME"
    OS_VERSION="$VERSION_ID"

    if [[ "$ID" != "ubuntu" ]]; then
        die "Unsupported operating system: $NAME. Only Ubuntu is currently supported."
    fi

    success "Detected $OS $OS_VERSION"
}

########################################
# Required Commands
########################################

validate_commands() {

    local commands=(
        curl
        openssl
        systemctl
        wp
        php
        mysql
        hostname
        dig
    )

    local missing=()

    for cmd in "${commands[@]}"; do
        require_command "$cmd"
    done

    success "Required commands found"

}

########################################
# System Validation
########################################

validate_system() {

	info "Validating system..."

	validate_os

	validate_commands

}

require_command() {
	local cmd="$1"
	command -v "$cmd" >/dev/null 2>&1 || die "Required command '$cmd' not found."
}

validate_configuration() {

	info "Validating configuration..."

	[[ -n "${DOMAIN:-}" ]] || die "DOMAIN is not set"
	[[ -n "${SITE_PATH:-}" ]] || die "SITE_PATH is not set"
	[[ -n "${DB_NAME:-}" ]] || die "DB_NAME is not set"
	[[ -n "${DB_USER:-}" ]] || die "DB_USER is not set"
	[[ -n "${DB_PASS:-}" ]] || die "DB_PASS is not set"
	[[ -n "${DB_HOST:-}" ]] || die "DB_HOST is not set"
	[[ -n "${PHP_SOCKET:-}" ]] || die "PHP_SOCKET is not set"
	[[ -n "${WEBSERVER:-}" ]] || die "WEBSERVER is not set"

	success "Configuration validated"

}

confirm_installation() {

	separator

	echo "Installation Summary"
	echo

	echo "Domain            : $DOMAIN"
	echo "Site Path         : $SITE_PATH"
	echo "Web Server        : $WEBSERVER"
	echo "PHP Version       : $PHP_VERSION"
	echo "PHP Socket        : $PHP_SOCKET"
	echo

	echo "Database Host     : $DB_HOST"
	echo "Database Port     : $DB_PORT"
	echo "Database Name     : $DB_NAME"
	echo "Database User     : $DB_USER"
	echo

	echo "WordPress Title   : $WP_SITE_TITLE"
	echo "Admin Username    : $WP_ADMIN_USER"
	echo "Admin Email       : $WP_ADMIN_EMAIL"
	echo "SSL Email         : $SSL_ADMIN_EMAIL"
	echo

	separator

	if ! ask_yes_no "Continue with installation?"; then
		die "Installation cancelled."
	fi
}
