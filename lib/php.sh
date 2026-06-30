#!/usr/bin/env bash

########################################
# PHP Detection
########################################

detect_php() {

    info "Detecting PHP..."

    PHP_VERSION="$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')"
    PHP_SOCKET="unix//run/php/php${PHP_VERSION}-fpm.sock"

    [[ -S "$PHP_SOCKET" ]] || die "PHP-FPM socket not found: $PHP_SOCKET"

    PHP_BIN="$(command -v php)"
    success "Detected PHP $PHP_VERSION"

}