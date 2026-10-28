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

Use the `-direct` captures below for the command evidence. These are unedited captures of the actual IDE terminal, with the REGNO prompt and commands visible. Earlier captures that display saved logs remain as supporting evidence. Browser captures show the actual application and public Docker Hub pages.

- S1-2: `screenshots/S1-2-direct.png` shows the original Python 3.9 build and image listing with size.
- S1-3: `screenshots/S1-3-direct.png` shows the standalone container, assigned port, REGNO health response and logs. Its subsequent removal is also recorded in `reports/stage1-standalone-final.txt`.
- S2-2: `screenshots/S2-2-direct.png` shows database DNS resolution failing inside the frontend.
- S2-3: `screenshots/S2-3_S2-4.png` shows the original page and registrations.
- S2-4: `screenshots/S2-4-direct.png` shows down/up commands, registrations before and after, and the named volume. An initial HTTP 502 during startup is retried successfully in the same capture.
- S3-1: `screenshots/S3-1-direct.png` shows the direct before scan and per-target severity totals.
- S3-3: `screenshots/S3-3-after-direct.png` shows the fixed scan and saved report; `screenshots/S3-3-gate-direct.png` shows the required CRITICAL gate with exit code 0. JSON output formatting keeps the entire command and result visible.
- S4-1: `screenshots/S4-1-direct.png` shows both public version tags being pushed with the unchanged signed digest. The initial Docker push output is preserved in `reports/push-1.0.0.txt` and `reports/push-1.0.txt`. For this capture, Docker Buildx copies the existing published OCI index exactly, as documented at https://docs.docker.com/reference/cli/docker/buildx/imagetools/create/.
- S4-2: `screenshots/S4-2.png` shows Docker Hub's Tags page and username. The digest printed on the per-platform Docker Hub row is the linux/arm64 child manifest; the release digest recorded above is the enclosing OCI index printed by Docker push.
- S4-3: `screenshots/S4-3.png` shows version 1.0.0 with the persisted registrations. Image removal and fresh pull are recorded in `reports/final-registry-redeploy.txt`.
- S5-1: `screenshots/S5-1-direct.png` shows the encrypted private-key header, private file permissions, Git ignore result and tracked public key, together with the original generation log.
- S5-2: `screenshots/S5-2-direct.png` shows signing by the full release digest and exit code 0.
- S5-3 / S5-4: `screenshots/S5-3_S5-4-digest-direct.png` shows direct verification of the signed digest and rejection of unsigned 1.0.1.

All technical stages were executed on this Mac. No technical stage remains unperformed. The student must still personally review and run commands as required by the assessment's execution rule; assistant execution and screenshots do not establish personal execution by the student. AI assistance is declared above.

The existing GitHub repository was renamed to the required REGNO-based name. Repository identity and the original HEAD were verified unchanged (`reports/repository-rename.json`); no commits or timestamps were rewritten. Additional evidence commits retain their actual later timestamps. The previous submitted URL redirects to the renamed repository.

The Mac ran out of disk space during the initial attempt. Rebuildable Gradle cache files were removed and Docker was recovered; earlier failure logs are retained alongside successful retry results. No project files or database volumes were removed for storage cleanup.

Private `.env`, `*.key` files and `.cosign-password` are ignored by Git. The signing password is stored only in the ignored local `.cosign-password` file. Only the public key is committed.
