# FestPass Docker and Container Security Assessment

- Name: Aastha Sudan
- REGNO: 202401100200004
- PORT: 8004
- Docker Hub username: aasthasudan
- Docker Hub repository: https://hub.docker.com/r/aasthasudan/fest-backend
- GitHub repository: https://github.com/AasthaSudan/devops-CA2
- AI tools: Antigravity (Gemini) for initial files/tool setup; OpenAI Codex for review, Docker configuration, dependency upgrades, execution and troubleshooting.

## Architecture

The nginx frontend proxies `/api/` to the Python backend. Only the backend shares `backend-net` with PostgreSQL. The frontend and backend share `frontend-net`. PostgreSQL data uses the named `db_data` volume. Database credentials and REGNO are read from the untracked `.env` file; `.env.example` documents the variables.

## Security changes

The initial Python 3.9 Dockerfile and original library versions are retained in the first Git commit. The hardened Dockerfile uses a digest-pinned Python 3.12 Alpine base, installs dependencies before copying the application, and runs as a non-root user. Flask, Werkzeug and psycopg2-binary were upgraded. APP_VERSION is a build argument.

Dependency references: [Flask](https://pypi.org/project/Flask/3.1.3/), [Werkzeug](https://pypi.org/project/Werkzeug/), [psycopg2-binary](https://pypi.org/project/psycopg2-binary/).

## Run locally

Copy `.env.example` to `.env`, enter matching database passwords and set REGNO and PORT. Run `docker compose up -d --build`, then open http://localhost:8004.

## Verification and limitations

The hardened image built successfully. After freeing approximately 3.5 GB of rebuildable Gradle caches and recovering Docker, the app reported the correct REGNO and database connectivity true. Two registrations were added and survived docker compose down/up with the named volume intact. The frontend cannot resolve db (ping fails), and the backend runs as uid 100/app. Genuine command outputs are in reports/.

### Vulnerability comparison

| Image | CRITICAL | HIGH | Image size |
| --- | --- | --- | --- |
| fest-backend:0.1 | Not measured: initial build failed | Not measured | Not available |
| fest-backend:0.2 | 0 | 5 | 27,781,360 bytes (26.5 MiB) |

Trivy 0.76.1 scan completed successfully. The required CRITICAL/ignore-unfixed gate exited 0; see reports/critical-gate.txt. Five HIGH findings remain and are reported honestly in reports/trivy-after.txt.

### Release digest

1.0.0: upload in progress; see reports/push-1.0.0.txt for its final outcome. No registry digest claimed yet.

### Steps not yet completed

- Initial Python 3.9 build/run evidence: blocked by full disk during image extraction.
- Before scan: initial Python 3.9 image build failed during disk exhaustion. The after scan and CRITICAL gate completed successfully.
- Docker Hub release: upload in progress. Registry-only deployment remains incomplete.
- Password-protected key, signing, verification and unsigned-release rejection: not yet completed.
- Required terminal/browser screenshots: not captured. Terminal automation is unavailable; screenshots must be taken manually from the actual windows with the REGNO prompt and command visible.

Private `.env`, `*.key` files and `.cosign-password` are ignored by Git. Do not publish those files.
