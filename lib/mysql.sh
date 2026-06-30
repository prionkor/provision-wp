#!/usr/bin/env bash

collect_database_information() {

	info "Database Configuration"

	DB_HOST="$(prompt "Database Host (localhost)")"
	DB_PORT="$(prompt "Database Port (3306)")"
	DB_ADMIN_USER="$(prompt "Database Admin User")"
	DB_ADMIN_PASSWORD="$(prompt_password "Database Admin Password")"

	DB_NAME="$(prompt "Database Name")"
	DB_USER="$(prompt "Database User")"
	DB_PASSWORD="$(prompt_password "Database User Password")"

}

mysql_exec() {

	mysql \
		-h "$DB_HOST" \
		-P "$DB_PORT" \
		-u "$DB_ADMIN_USER" \
		-p"$DB_ADMIN_PASSWORD" \
		"$@"

}

test_database_connection() {

	info "Testing database connection..."

	mysql_exec -e "SELECT 1;" >/dev/null \
		|| die "Unable to connect to MySQL."

	success "Database connection successful."

}

database_exists() {

	mysql_exec -N -B <<EOF
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME='${DB_NAME}';
EOF

}

database_user_exists() {

	mysql_exec -N -B <<EOF
SELECT User
FROM mysql.user
WHERE User='${DB_USER}';
EOF

}

create_database() {

if database_exists >/dev/null; then
		success "Database already exists."
		return
	fi

	info "Creating database..."

	mysql_exec <<EOF
CREATE DATABASE \`${DB_NAME}\`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
EOF

    register_cleanup \
        "mysql_exec -e \"DROP DATABASE IF EXISTS \\\`${DB_NAME}\\\`;\""

	DATABASE_CREATED="true"

	success "Database created."

}

create_database_user() {

	if database_user_exists >/dev/null; then
		success "Database user already exists."
		return
	fi

	info "Creating database user..."

	mysql_exec <<EOF
CREATE USER '${DB_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';
EOF

    register_cleanup \
        "mysql_exec -e \"DROP USER IF EXISTS '${DB_USER}'@'%';\""

	DATABASE_USER_CREATED="true"

	success "Database user created."

}

grant_database_permissions() {

	info "Granting database permissions..."

	mysql_exec <<EOF
GRANT ALL PRIVILEGES
ON \`${DB_NAME}\`.*
TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

	success "Database permissions granted."

}

