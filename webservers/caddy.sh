#!/usr/bin/env bash

is_webserver_installed() {
	command -v caddy >/dev/null 2>&1
}

install_webserver() {

	if is_webserver_installed; then
		success "Caddy is already installed."
		return
	fi

	info "Installing Caddy..."

	apt update

	apt install -y \
		debian-keyring \
		debian-archive-keyring \
		apt-transport-https \
		curl

	curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/gpg.key \
		| gpg --dearmor \
		-o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

	curl -fsSL https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt \
		-o /etc/apt/sources.list.d/caddy-stable.list

	apt update

	apt install -y caddy

	systemctl enable caddy
	systemctl start caddy

	success "Caddy installed."
}

initialize_webserver() {

	info "Initializing Caddy..."

	local caddyfile="/etc/caddy/Caddyfile"
	local tmpfile

	# Ensure the shared sites directory exists.
	if [[ ! -d /etc/caddy/sites ]]; then
		info "Creating Caddy sites directory..."
		mkdir -p /etc/caddy/sites
	fi

	# Refuse to overwrite an existing site configuration.
	[[ ! -f "/etc/caddy/sites/${DOMAIN}.conf" ]] \
		|| die "Caddy site configuration already exists for '${DOMAIN}'."

	# Create an empty Caddyfile if necessary.
	[[ -f "$caddyfile" ]] || touch "$caddyfile"

	# Ensure a global options block exists.
	if ! awk '
		/^[[:space:]]*#/ { next }
		/^[[:space:]]*$/ { next }
		{ exit ($0 ~ /^[[:space:]]*{/) }
	' "$caddyfile"; then

		info "Adding global options block..."

		tmpfile="$(mktemp)"

		{
			printf "{\n"
			printf "\temail %s\n" "$SSL_ADMIN_EMAIL"
			printf "}\n\n"
			cat "$caddyfile"
		} > "$tmpfile"

		mv "$tmpfile" "$caddyfile"
	fi

	# Ensure the sites import exists.
	if ! grep -Eq '^[[:space:]]*import[[:space:]]+sites/\*[[:space:]]*$' "$caddyfile"; then
		info "Adding 'import sites/*' to Caddyfile..."
		printf "\nimport sites/*\n" >> "$caddyfile"
	fi

	success "Caddy initialized."

}

create_site() {

	info "Creating Caddy site..."
	mkdir -p /etc/caddy/sites

	sed \
		-e "s|{{DOMAIN}}|${DOMAIN}|g" \
		-e "s|{{SITE_PATH}}|${SITE_PATH}|g" \
		-e "s|{{PHP_SOCKET}}|${PHP_SOCKET}|g" \
		"$SCRIPT_DIR/templates/caddy.conf" \
		> "/etc/caddy/sites/${DOMAIN}.conf"

    register_cleanup \
        "rm -f '/etc/caddy/sites/${DOMAIN}.conf'"

	WEBSERVER_CONFIG_CREATED="true"

	success "Created Caddy configuration."
}

reload_webserver() {
	info "Validating Caddy configuration..."

	caddy validate --config /etc/caddy/Caddyfile \
		|| die "Caddy configuration validation failed."

	systemctl reload caddy

	success "Reloaded Caddy."
}

remove_site() {
	local config="/etc/caddy/sites/${DOMAIN}.conf"

	[[ -f "$config" ]] || return

	info "Removing Caddy site..."

	rm -f "$config"

	systemctl reload caddy

	success "Removed Caddy site."
}

site_exists() {
	[[ -f "/etc/caddy/sites/${DOMAIN}.conf" ]]
}