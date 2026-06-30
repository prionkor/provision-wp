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