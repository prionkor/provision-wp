# Project Structure

wp-site-installer/
│
├── install.sh # Entry point
│
├── lib/
│ ├── common.sh # Logging, colors, prompts
│ ├── validation.sh # System validation
│ ├── cleanup.sh # Rollback
│ ├── webserver.sh # Detection & selection
│ ├── wordpress.sh # WP installation
│ ├── mysql.sh # Database operations
│ └── php.sh # PHP detection
│
├── webservers/
│ ├── caddy.sh
│ ├── nginx.sh
│ └── apache.sh
│
├── templates/
│ ├── caddy.conf
│ ├── nginx.conf
│ └── apache.conf
│
├── logs/
│
└── README.md
