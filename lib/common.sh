#!/usr/bin/env bash

########################################
# Colors
########################################

if [[ -t 1 ]]; then
	RED="\033[0;31m"
	GREEN="\033[0;32m"
	YELLOW="\033[1;33m"
	BLUE="\033[0;34m"
	BOLD="\033[1m"
	NC="\033[0m"
else
	RED=""
	GREEN=""
	YELLOW=""
	BLUE=""
	BOLD=""
	NC=""
fi

########################################
# Logging
########################################

log() {
	mkdir -p "$(dirname "$LOG_FILE")"
	echo "$(date '+%F %T') $*" >>"$LOG_FILE"
}

info() {
	echo -e "${BLUE}➜${NC} $*"
	log "[INFO] $*"
}

success() {
	echo -e "${GREEN}✓${NC} $*"
	log "[ OK ] $*"
}

warning() {
	echo -e "${YELLOW}⚠${NC} $*"
	log "[WARN] $*"
}

error() {
	echo -e "${RED}✗${NC} $*" >&2
	log "[FAIL] $*"
}

die() {
	error "$*"
	log "[EXIT] Installation aborted."
	exit 1
}

print_banner() {

	cat <<'EOF'

============================================================
            WordPress Site Installer
============================================================

Create and manage multiple WordPress sites with:

 • Caddy
 • Nginx
 • Apache

============================================================

EOF

}

# DOMAIN=$(prompt "Domain")

prompt() {
	local message="$1"
	local default_value="${2:-}"
	local value

	# Display the default value in brackets if it exists
	if [[ -n "$default_value" ]]; then
		read -rp "$message [$default_value]: " value
	else
		read -rp "$message: " value
	fi

	# Trim leading and trailing whitespace from the user's input
	value=$(echo "$value" | xargs)

	# If the user pressed enter without typing, use the default value
	if [[ -z "$value" ]]; then
		value="$default_value"
	fi

	echo "$value"
}

#
# Uses
#
# WP_ADMIN_PASSWORD=$(prompt_password "Admin Password")
prompt_password() {

	local message="$1"
	local value1
	local value2

	while true; do

		printf "%s: " "$message"
		read -rs value1
		echo

		[[ -n "$value1" ]] || continue

		printf "Confirm %s: " "$message"
		read -rs value2
		echo

		if [[ "$value1" == "$value2" ]]; then
			echo "$value1"
			return 0
		else
			error "Passwords do not match. Please try again."
			echo
		fi

	done
}

# if ask_yes_no "Continue?"
# then
#     ...
# fi
ask_yes_no() {

	local question="$1"
	local default="${2:-Y}"

	local answer

	while true; do

		read -rp "$question [$default/n]: " answer

		answer="${answer:-$default}"

		case "${answer,,}" in

		y | yes)
			return 0
			;;

		n | no)
			return 1
			;;

		esac

	done

}

separator() {
	printf '%*s\n' "${COLUMNS:-60}" '' | tr ' ' '-'
}

trim() {
	local s="$1"
	s="${s#"${s%%[![:space:]]*}"}"
	s="${s%"${s##*[![:space:]]}"}"
	printf '%s' "$s"
}
