# Inception

![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=flat-square&logo=nginx&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=flat-square&logo=mariadb&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-21759B?style=flat-square&logo=wordpress&logoColor=white)
![42 Barcelona](https://img.shields.io/badge/42_Barcelona-000000?style=flat-square&logo=42&logoColor=white)

> 42 Barcelona — System Administration project. Multi-container production infrastructure built from scratch with Docker Compose, custom Dockerfiles, and TLS-secured services.

---

## Overview

Inception is a 42 Barcelona project that requires building a small, functional infrastructure entirely from custom Docker images — no pre-built images from Docker Hub allowed.

The result is a self-contained, production-grade environment with three services communicating over an isolated Docker network, persistent storage via named volumes, and HTTPS enforced via TLS 1.2/1.3.

---

## Architecture

```
                  ┌─────────────────────────────────┐
                  │         Docker Network           │
                  │                                  │
  HTTPS ──────▶  │  NGINX (TLS 1.2/1.3)            │
  :443           │      │                            │
                  │      ▼                            │
                  │  WordPress + PHP-FPM  ──────▶  MariaDB │
                  │                                  │
                  └─────────────────────────────────┘
                        │               │
                   [wp-data]       [db-data]
                   (volume)        (volume)
```

---

## Services

### NGINX
- Custom Dockerfile based on Debian
- Configured to serve only HTTPS (TLS 1.2 and 1.3 enforced)
- Acts as reverse proxy to WordPress/PHP-FPM via FastCGI
- Self-signed certificate generated at build time

### WordPress + PHP-FPM
- Custom Dockerfile, no official WordPress image used
- PHP-FPM configured to communicate with NGINX via Unix socket
- Automated setup: database connection, admin user and additional user created at container startup via `wp-cli`

### MariaDB
- Custom Dockerfile based on Debian
- Database and users provisioned via init scripts
- Credentials injected via environment variables (`.env` file, never hardcoded)

---

## Security considerations

- Zero exposed ports except NGINX on 443
- All inter-service communication inside an isolated Docker bridge network
- No root processes inside containers (where possible)
- Secrets managed via `.env` — not committed to the repository
- TLS enforced — HTTP not served

---

## Project structure

```
Inception/
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env.example
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/
        └── mariadb/
            ├── Dockerfile
            └── tools/
```

---

## Setup & Usage

### Prerequisites
- Docker Engine ≥ 20.x
- Docker Compose ≥ 2.x
- `make`

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/MaxMaltas/Inception.git
cd Inception

# 2. Copy and configure environment variables
cp srcs/.env.example srcs/.env
# Edit srcs/.env with your credentials

# 3. Add local domain to /etc/hosts
echo "127.0.0.1  login.42.fr" | sudo tee -a /etc/hosts

# 4. Build and start all containers
make

# 5. Access the site
# https://login.42.fr
```

### Makefile targets

| Target | Description |
|---|---|
| `make` | Build images and start all containers |
| `make down` | Stop and remove containers |
| `make clean` | Remove containers, volumes and networks |
| `make re` | Full rebuild from scratch |
| `make logs` | Tail logs for all services |

---

## What this project demonstrates

- Building production Docker images from scratch (no pre-built images)
- Container orchestration with Docker Compose
- Secure service communication within isolated Docker networks
- TLS configuration with NGINX
- Secrets management via environment variables
- Persistent data management with named volumes
- Service initialisation scripting (MariaDB, WordPress via wp-cli)

---

## Skills

`Docker` `Docker Compose` `NGINX` `TLS/SSL` `MariaDB` `WordPress` `PHP-FPM` `Linux` `Bash` `System Administration`

---

*Project developed as part of the 42 Barcelona curriculum.*
