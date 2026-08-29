# Portfolio Progression Demo Lab

This repository packages Braiden Miller's learning-era Java projects as browser-accessible progression demos.
The preserved applications show earlier stages of Java, object-oriented design, JDBC, JPA, Spring MVC, and CRUD
development. They are intentionally presented beside the current
[Platform Demo](https://github.com/braidenm/platform-demo), where visitors can compare that foundation with a
modern product, architecture, testing, delivery, security, and operations practice.

The original repositories remain unchanged and are pinned as Git submodules under `upstream/`. This repository
owns only reproducible build adapters, browser-terminal packaging, disposable demo data, runtime constraints,
and deployment tests.

## Demo Inventory

| Demo | Experience | Runtime status |
| --- | --- | --- |
| Make Change | Browser terminal | Packaged |
| Jets | Browser terminal | Packaged |
| Blackjack | Browser terminal | Packaged |
| Film Query | Browser terminal with disposable MariaDB data | Packaged |
| Workout CRUD | Legacy Spring/JSP site with disposable MariaDB data | Packaged compatibility runtime |
| VolunteerUp | Legacy Spring/JSP site with disposable MariaDB data | Packaged compatibility runtime |
| MVC Film Site | Historical record | Source recovery required; the original repository contains only a README |

## Free Runtime Components

- [ttyd](https://github.com/tsl0922/ttyd) 1.7.7 (MIT) provides the browser terminal.
- Eclipse Temurin OpenJDK 21 runs the CLI applications.
- Eclipse Temurin OpenJDK 8 runs the Spring Boot 2.1 compatibility images on their original Java generation.
- MariaDB 10.11 provides isolated disposable demo databases.
- Docker Compose and Caddy remain the homelab runtime and edge.

No paid browser-JVM, terminal, database, or hosting library is required.

## Local Build

Initialize the pinned sources, validate the catalog, and build one CLI image:

```bash
git submodule update --init --recursive
node scripts/verify-catalog.mjs
docker build -f images/Dockerfile.cli \
  --build-arg SOURCE_DIR=upstream/make-change \
  --build-arg MAIN_CLASS=com.skilldistillery.makechange.MakeChangeApp \
  --build-arg APP_ID=make-change \
  -t portfolio-demo-lab:make-change .
```

The terminal listens on container port `7681`. The production homelab stack publishes no host ports; Caddy is
the only ingress. Each demo runs as a non-root user with a read-only root filesystem, dropped Linux
capabilities, bounded processes, memory, CPU, and connection counts, and no Docker socket or host data mount.

## Historical Compatibility Boundary

The legacy Spring projects remain on their original Spring Boot 2.1.1 build line to preserve the learning-era
code. That framework line is unsupported, so those images are isolated from Platform Demo, use only disposable
demo data, have no outbound network requirement, and must pass container and HTTP security checks before public
deployment. See [the architecture decision](docs/architecture-decision.md).
