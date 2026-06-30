#!/usr/bin/env bash

########################################
# Web Server Detection
########################################

detect_webservers() {

    info "Detecting web servers..."

    WEBSERVER_OPTIONS=()

    command -v caddy >/dev/null 2>&1 && WEBSERVER_OPTIONS+=("caddy")
    command -v nginx >/dev/null 2>&1 && WEBSERVER_OPTIONS+=("nginx")
    command -v apache2 >/dev/null 2>&1 && WEBSERVER_OPTIONS+=("apache")

    if (( ${#WEBSERVER_OPTIONS[@]} == 0 )); then
        warning "No supported web servers detected."
    else
        success "Detected: ${WEBSERVER_OPTIONS[*]}"
    fi
}

webserver_status() {

    local server="$1"

    for installed in "${WEBSERVER_OPTIONS[@]}"; do
        [[ "$installed" == "$server" ]] && {
            printf "available"
            return
        }
    done

    printf "install"
}

choose_webserver() {

    local choice

    separator
    printf "Select Web Server\n"
    separator

    printf "1) Caddy  (%s)\n"  "$(webserver_status caddy)"
    printf "2) Nginx  (%s)\n"  "$(webserver_status nginx)"
    printf "3) Apache (%s)\n"  "$(webserver_status apache)"
    printf "4) Cancel\n\n"

    while true; do

        read -rp "Choice: " choice

        case "$choice" in

            1)
                WEBSERVER="caddy"
                WEBSERVER_SERVICE="caddy"
                break
                ;;

            2)
                WEBSERVER="nginx"
                WEBSERVER_SERVICE="nginx"
                break
                ;;

            3)
                WEBSERVER="apache"
                WEBSERVER_SERVICE="apache2"
                break
                ;;

            4)
                die "Installation cancelled."
                ;;

            *)
                warning "Invalid selection."
                ;;

        esac

    done

    source "$SCRIPT_DIR/webservers/${WEBSERVER}.sh"

    success "Selected web server: ${WEBSERVER^}"

}