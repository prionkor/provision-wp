#!/usr/bin/env bash

########################################
# Cleanup Stack
########################################

CLEANUP_ACTIONS=()

########################################
# Register Cleanup
########################################

register_cleanup() {

	CLEANUP_ACTIONS+=("$1")

}

########################################
# Execute Cleanup
########################################

cleanup() {

	if (( ${#CLEANUP_ACTIONS[@]} == 0 )); then
		return
	fi

	warning "Cleaning up..."

	for (( i=${#CLEANUP_ACTIONS[@]}-1; i>=0; i-- )); do

        info "Rollback: ${CLEANUP_ACTIONS[$i]}"

        eval "${CLEANUP_ACTIONS[$i]}" \
            || warning "Rollback failed."

    done

}

########################################
# Success
########################################

cleanup_success() {
	CLEANUP_ACTIONS=()
}