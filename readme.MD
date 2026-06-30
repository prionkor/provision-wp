# ProvisionWP

A modular, open-source WordPress provisioning tool for Linux servers.

ProvisionWP automates the full lifecycle of WordPress site creation — from server setup to SSL, database provisioning, and WordPress configuration — using a clean, transparent Bash-based architecture.

It is designed for developers who want full control over their infrastructure without relying on hosting control panels.

---

## What ProvisionWP does

ProvisionWP handles the complete setup of a WordPress site:

- Creates site directory structure
- Installs and configures WordPress
- Sets up MySQL/MariaDB database and user
- Configures web servers (Caddy / Nginx / Apache)
- Installs SSL certificates via Let's Encrypt
- Installs WP-CLI-based plugins and themes
- Applies secure file permissions
- Supports rollback on failure

---

## Supported Web Servers

- Caddy (primary support)
- Nginx (planned)
- Apache (planned)

---

## Project Structure

```
.
├── install.sh
├── lib
│   ├── common.sh
│   ├── context.sh
│   ├── validation.sh
│   ├── php.sh
│   ├── mysql.sh
│   ├── wordpress.sh
│   ├── plugins.sh
│   ├── themes.sh
│   ├── webserver.sh
│   └── cleanup.sh
└── webservers
    ├── caddy.sh
    ├── nginx.sh
    └── apache.sh
```

---

## Requirements

ProvisionWP is designed for **Ubuntu-based Linux servers**.

### System requirements:

- Ubuntu 22.04 / 24.04 (recommended)
- Bash
- PHP-FPM
- MySQL or MariaDB
- WP-CLI
- Root access (sudo)

---

## Installation

Clone the repository:

```bash
git clone https://github.com/<your-username>/provision-wp.git
```

Enter the directory:

```bash
cd provision-wp
```

Make the installer executable:

```bash
chmod +x install.sh
```

Run the installer:

```bash
sudo ./install.sh
```

---

## CLI (Future Vision)

ProvisionWP is designed to evolve into a CLI tool:

```bash
provisionwp create site example.com
provisionwp delete site example.com
provisionwp list sites
provisionwp ssl renew
provisionwp doctor
```

---

## Current Status

### Implemented

- Modular Bash architecture
- PHP detection
- Web server detection
- Caddy integration
- MySQL provisioning
- WordPress installation flow
- Plugin and theme automation (basic)
- Rollback framework
- Clean logging and validation system

### In Progress

- Full CLI interface
- Nginx support
- Apache support
- Backup & restore system
- Plugin/theme profiles

---

## Design Philosophy

ProvisionWP is built around these principles:

- Transparency over magic
- Modular and hackable design
- No hidden automation
- Safe rollback on failure
- Easy to extend and audit
- Infrastructure-first thinking

---

## Development Tools

Recommended:

- VS Code
- ShellCheck
- shfmt

### Syntax check

```bash
find . -name "*.sh" -exec bash -n {} \;
```

### Linting

```bash
shellcheck -x install.sh
```

---

## Roadmap

- [ ] Full CLI implementation
- [ ] Multi-site management
- [ ] Backup/restore system
- [ ] Plugin profiles
- [ ] Theme marketplace support (local)
- [ ] Docker-based dev mode
- [ ] Terraform-style declarative provisioning (future)

---

## Contributing

Contributions are welcome.

If you find bugs, improvements, or ideas, feel free to open an issue or submit a pull request.

---

## License

This project is licensed under the MIT License.

See the LICENSE file for details.
