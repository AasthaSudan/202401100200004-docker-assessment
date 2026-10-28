# FestPass Docker Assessment

- **Name:** Aastha Sudan
- **REGNO:** 202401100200004
- **PORT:** 8004
- **Docker Hub:** [aasthasudan/fest-backend](https://hub.docker.com/r/aasthasudan/fest-backend)
- **GitHub:** [202401100200004-docker-assessment](https://github.com/AasthaSudan/202401100200004-docker-assessment)
- **AI tools used:** Antigravity (Gemini) and OpenAI Codex for code, configuration, command execution and documentation.

## Run

Copy `.env.example` to `.env`, set matching database passwords, then run `docker compose up -d`. Open http://localhost:8004. The frontend connects to the backend; only the backend shares the database network. PostgreSQL registrations persist in the named volume. Compose pulls release 1.0.0 from Docker Hub.

## Scan results

| Image | CRITICAL | HIGH | Docker disk usage | Image content size |
| --- | --- | --- | --- | --- |
| fest-backend:0.1 | 234 | 2249 | 1.61 GB | 401,285,537 bytes |
| fest-backend:0.2 | 0 | 5 | 118 MB | 27,781,768 bytes |

Full Trivy reports are in `reports/trivy-before.txt` and `reports/trivy-after.txt`. The required `--severity CRITICAL --ignore-unfixed --exit-code 1` gate passed with exit code 0. Five HIGH findings remain. The original Python 3.9 Dockerfile is preserved in the first commit; the final image uses pinned Python Alpine, upgraded libraries and a non-root user.

## Published images

- Signed **1.0.0** and **1.0**: `sha256:ea6b003525490643cfd8ddb02d4680a868f69faf6899521edfda444a917acace`
- Unsigned **1.0.1**: `sha256:fba9acf3b1079042ca866aac962069c66518e23ebfff02076d6140967633ba56`

Verification of 1.0.0 with `cosign.pub` passed; unsigned 1.0.1 was rejected. Only the public key is tracked. `.env`, private keys and the signing password are ignored.

## Evidence

Screenshots in `screenshots/` use the assessment evidence codes; S5-3 and S5-4 share one capture. Full Trivy reports are in `reports/`. All five technical stages were completed.

S4-1 shows republishing the existing OCI index with its signed digest unchanged. Docker Hub displays the platform manifest digest; the published digest above identifies the enclosing index.
