#!/usr/bin/env bash

# Runtime Contexts

# Those are the variables holds the state of the current installation.
# They are populated during the execution of the script and shared 
# across all the modules.

########################################
# Site Information
########################################

DOMAIN=""
SITE_TITLE=""

SITE_ROOT=""
SITE_PATH=""

# FOR LETSENCRYPT SSL CERTIFICATES
SSL_ADMIN_EMAIL=""

########################################
# WordPress Administrator
########################################

WP_ADMIN_USER=""
WP_ADMIN_PASSWORD=""
WP_ADMIN_EMAIL=""

########################################
# Database
########################################

DB_HOST="localhost"
DB_PORT="3306"

DB_NAME=""
DB_USER=""
DB_PASSWORD=""

DB_SSL="false"

########################################
# Web Server
########################################

WEBSERVER=""
WEBSERVER_CONFIG=""
WEBSERVER_SERVICE=""

########################################
# PHP
########################################

PHP_BIN=""
PHP_VERSION=""
PHP_SOCKET=""

########################################
# Server
########################################

SERVER_IP=""
OS=""
OS_VERSION=""

########################################
# Installation State
########################################

SITE_DIRECTORY_CREATED="false"
DB_CREATED="false"
DB_USER_CREATED="false"
WEBSERVER_CONFIG_CREATED="false"
WORDPRESS_INSTALLED="false"

########################################
# Logging
########################################

LOG_FILE="/var/log/wp-site-installer.log"

