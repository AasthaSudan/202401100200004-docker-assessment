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

The hardened `fest-backend:0.2` image built successfully and all three containers started. Initial runtime verification returned the correct REGNO but database connectivity was false. The Mac then ran out of disk space, causing Docker storage I/O errors, failed initial/release builds and a failed image scan. Approximately 3.5 GB of rebuildable Gradle cache files were removed and Docker recovery was initiated. Reports contain genuine command output, including failures.

### Vulnerability comparison

| Image | CRITICAL | HIGH | Image size |
| --- | --- | --- | --- |
| fest-backend:0.1 | Not measured: initial build failed | Not measured | Not available |
| fest-backend:0.2 | Scan pending recovery | Scan pending recovery | Pending inspection |

No zero-vulnerability claim is made without a successful scan.

### Release digest

1.0.0: not yet published; no registry digest available.

### Steps not yet completed

- Initial Python 3.9 build/run evidence: blocked by full disk during image extraction.
- Database connectivity, two registrations, network isolation and persistence proof: awaiting Docker recovery.
- Successful before/after scans and CRITICAL gate: awaiting Docker recovery.
- Docker Hub release and registry-only deployment: not yet completed.
- Password-protected key, signing, verification and unsigned-release rejection: not yet completed.
- Required terminal/browser screenshots: not captured. Terminal automation is unavailable; screenshots must be taken manually from the actual windows with the REGNO prompt and command visible.

Private `.env`, `*.key` files and `.cosign-password` are ignored by Git. Do not publish those files.
