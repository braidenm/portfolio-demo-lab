# Browser Runtime Boundary For Learning-Era Applications

Date: 2026-08-29
Status: Accepted for implementation

## Question And Context

How can public visitors run learning-era Java CLI and legacy Spring applications in a browser while preserving
the original code and progression story without extending the Platform Demo backend's trust, data, or release
boundary?

The demos are low-volume, anonymous, disposable, and educational. Correct isolation, low operating cost,
reproducible source provenance, mobile usability, and easy rollback matter more than shared identity or durable
demo data. The legacy applications must be assumed vulnerable because their framework line is unsupported.

## Current Evidence

- Four repositories are interactive Java console programs using `Scanner(System.in)`.
- Film Query additionally uses JDBC and a classroom film schema.
- Workout CRUD and VolunteerUp use Spring Boot 2.1.1, JSP, JPA, and MySQL-style schemas.
- MVC Film Site currently contains only a README and cannot be built.
- The homelab already uses Docker Compose, Caddy, Cloudflare Tunnel, GHCR, health checks, and immutable image tags.

## Sources Consulted

Accessed 2026-08-29:

- [ttyd README](https://github.com/tsl0922/ttyd), version 1.7.7: fixed-command browser terminal,
  origin checking, writable mode, base paths, and bounded client options.
- [Caddy reverse proxy](https://caddyserver.com/docs/caddyfile/directives/reverse_proxy), Caddy 2 current
  documentation: WebSocket upgrades are proxied as bidirectional tunnels and stream lifetime can be bounded.
- [Docker resource constraints](https://docs.docker.com/engine/containers/resource_constraints/), current Docker
  Engine documentation: containers have no resource limits unless limits are explicitly configured.
- [Docker Compose services](https://docs.docker.com/reference/compose-file/services/), current Compose
  specification: `read_only`, `cap_drop`, `security_opt`, `pids_limit`, CPU, memory, health, and network controls.
- [Spring Boot 2.1 end-of-life notice](https://spring.io/blog/2019/12/10/spring-boot-2-1-x-eol-november-1st-2020/):
  maintenance ended on 2020-11-01.
- [CheerpJ overview](https://cheerpj.com/docs/overview.html) and
  [licensing](https://cheerpj.com/docs/licensing), version 4.3: a browser JVM is viable for Java 8/11/17, but
  self-hosting is commercial and console-input compatibility still requires a prototype.

## Alternatives

| Option | Cost | Isolation | Fidelity | Decision |
| --- | --- | --- | --- | --- |
| Run legacy code inside Platform Demo | No new service | Poor; shares the sensitive app boundary | High | Rejected |
| Reimplement every app in React | Free | Strong | Low; hides the original progression | Rejected |
| CheerpJ browser JVM | Free for eligible personal CDN use | Strong client sandbox | Unknown for these console flows; self-hosting is paid | Deferred compatibility experiment |
| Fixed-command ttyd containers plus isolated legacy web containers | Free/open source | Strong when network and container controls are applied | High | Selected |
| Keep screenshots and source links only | Free | Strong | Not interactive | Recovery fallback only |

## Decision

Use a separate repository and runtime stack. CLI images contain one fixed Java entrypoint behind ttyd and never
provide a shell or Docker API. Legacy web images retain original sources and dependencies but run on a separate
demo network with disposable MariaDB schemas. Caddy is the only ingress. Each app receives a separate hostname
and browser origin. Platform Demo renders only the catalog and cross-origin frame.

The build adapters may change runtime configuration and packaging but do not edit the pinned upstream source.
All dependencies used by the selected runtime are free/open source. No CheerpJ dependency is introduced.

## Pitfalls And Controls

- A ttyd writeable terminal is not a shell: URL arguments are disabled and the command is fixed in the image.
- Container defaults are insufficient: CPU, memory, PID, connection, capability, filesystem, and network limits
  are explicit deployment acceptance criteria.
- Same-origin legacy apps can expose each other through stored script injection, so each gets a different host.
- Platform cookies must remain host-only. A parent-domain cookie blocks public launch until a separate
  registrable demo domain is used.
- Legacy database data is not durable. Resets are expected and disclosed to visitors.
- Terminal input/output is visitor-controlled and must not be persisted in application logs.

## Proof And Operation

- Golden terminal journeys prove prompts, input, exit, reconnect, resize, and two-client isolation.
- Browser tests prove catalog progression copy, unavailable-source state, iframe titles, restart, and mobile picker.
- Runtime tests prove non-root UID, read-only root, no added capabilities, bounded memory/PIDs, no Docker socket,
  no platform database route, origin checking, and Caddy frame policy.
- Metrics cover container health/restarts and Caddy response/WebSocket failures without recording terminal data.
- Images are tagged by the demo-lab commit. Rollback restores the previous bundle tag; demo databases are rebuilt
  from seeds and require no migration or production-data compensation.

## Owner Decisions

- The demos are public and anonymous.
- Mutations in the two web demos are disposable and may be reset without notice.
- MVC Film Site remains a documented unavailable item until attributable source is recovered.
- Group-project contributor attribution remains visible; repackaged source is not claimed as solo work.

