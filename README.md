# 202401100200004-docker-assessment

FestPass Docker and Container Security Assessment

- Name: Aastha Sudan
- REGNO: 202401100200004
- PORT: 8004
- Docker Hub username: aasthasudan
- Docker Hub repository: https://hub.docker.com/r/aasthasudan/fest-backend
- GitHub repository: https://github.com/AasthaSudan/202401100200004-docker-assessment
- AI tools: Antigravity (Gemini) for initial files/tool setup; OpenAI Codex for review, Docker configuration, dependency upgrades, execution and troubleshooting.

## Architecture

The nginx frontend proxies `/api/` to the Python backend. Only the backend shares `backend-net` with PostgreSQL. The frontend and backend share `frontend-net`. PostgreSQL data uses the named `db_data` volume. Database credentials and REGNO are read from the untracked `.env` file; `.env.example` documents the variables.

## Security changes

The initial Python 3.9 Dockerfile and original library versions are retained in the first Git commit. The hardened Dockerfile uses a digest-pinned Python 3.12 Alpine base, installs dependencies before copying the application, and runs as a non-root user. Flask, Werkzeug and psycopg2-binary were upgraded. APP_VERSION is a build argument.

Dependency references: [Flask](https://pypi.org/project/Flask/3.1.3/), [Werkzeug](https://pypi.org/project/Werkzeug/), [psycopg2-binary](https://pypi.org/project/psycopg2-binary/).

## Run the signed release

Copy `.env.example` to `.env`, enter matching database passwords and set REGNO and PORT. Run `docker compose up -d`, then open http://localhost:8004. Compose deploys `aasthasudan/fest-backend:1.0.0` from Docker Hub. The release contains APP_VERSION=1.0.0.

## Verified results

- Original `fest-backend:0.1` built from the first Git commit after disk recovery.
- All three services run; the database is connected and REGNO is correct.
- Two registrations survived `docker compose down` followed by `up -d`.
- The frontend cannot resolve the database service; `ping -c 1 db` fails.
- The hardened backend runs as uid 100 (`app`).
- Trivy 0.76.1 scanned both images; the fixed image passed the CRITICAL/ignore-unfixed gate with exit code 0.
- Public Docker Hub tags 1.0.0 and 1.0 were pushed with the same digest.
- Version 1.0.0 was signed by digest with a password-protected cosign key; verification with `cosign.pub` exited 0.
- Version 1.0.1 was built and pushed without signing; cosign rejected it with `no signatures found` and exit code 10.
- Actual command output is retained in `reports/`.

## Vulnerability comparison

| Image | CRITICAL | HIGH | Docker disk usage | Image content size |
| --- | --- | --- | --- | --- |
| fest-backend:0.1 | 234 | 2249 | 1.61 GB | 401,285,537 bytes |
| fest-backend:0.2 | 0 | 5 | 118 MB | 27,781,768 bytes |

Counts include all findings across targets in each report. Five HIGH findings remain; the assessment gate specifically requires no fixable CRITICAL findings. Full reports: `reports/trivy-before.txt` and `reports/trivy-after.txt`.

## Published digests

- Signed 1.0.0 and 1.0: `sha256:ea6b003525490643cfd8ddb02d4680a868f69faf6899521edfda444a917acace`
- Unsigned 1.0.1: `sha256:fba9acf3b1079042ca866aac962069c66518e23ebfff02076d6140967633ba56`

## Evidence and limitations

Browser and terminal screenshots are saved in `screenshots/`, named with the assessment evidence codes. The terminal uses the REGNO prompt. Terminal captures review the genuine saved command output with cat/tail, except the isolation/volume/registration and signed/unsigned verification commands which are rerun directly. The original execution logs are retained in reports/. This distinction is recorded transparently because a marker may require screenshots of the original commands themselves.

The Mac ran out of disk space during the initial attempt. Rebuildable Gradle cache files were removed and Docker was recovered; earlier failure logs are retained alongside successful retry results. No project files or database volumes were removed for storage cleanup.

Private `.env`, `*.key` files and `.cosign-password` are ignored by Git. The signing password is stored only in the ignored local `.cosign-password` file. Only the public key is committed.
