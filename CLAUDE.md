# Hudson PM — Claude Code Context

AI property manager for Airbnb hosts. OpenClaw project: skills + scripts that Claude Code uses to monitor guests and send alerts.

## Project layout

- `skills/` — Claude Code skills (auto-discovered `SKILL.md` files)
  - `airbnb/` — guest communication & monitoring
  - `pushover/` — push notifications
- `scripts/` — bash scripts invoked by skills
  - `monitor.sh` — full scan + classify + notify loop
  - `scan-gmail.sh` — Gmail API scanner for Airbnb messages
  - `send-pushover.sh` — Pushover API notification sender
- `docs/setup.md` — setup & configuration guide

## Required env vars

```bash
PUSHOVER_APP_TOKEN   # Pushover app token
PUSHOVER_USER_TOKEN  # Pushover user token
GMAIL_ACCESS_TOKEN   # Gmail OAuth2 token
```

## Conventions

- All bash scripts use `set -euo pipefail`
- Scripts use `#!/usr/bin/env bash` shebang
- Arg parsing via `while [[ $# -gt 0 ]]; case` pattern
- Required env vars validated with `: "${VAR:?msg}"`
- Run `make check` to lint scripts before committing
