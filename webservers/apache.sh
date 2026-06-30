#!/usr/bin/env bash

install_webserver() {
    die "Not implemented."
}

create_site() {
    die "Not implemented."
}

reload_webserver() {
    systemctl reload apache2
}

remove_site() {
    die "Not implemented."
}

site_exists() {
    return 1
}