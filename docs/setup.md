# Hudson PM Setup Guide

## What Is This?

Hudson PM is an **OpenClaw** project — a repository of Claude Code custom skills and scripts that turn Claude into an AI property manager.

**OpenClaw pattern:** a `skills/` directory containing `SKILL.md` files that Claude Code loads as callable skills, plus `scripts/` with shell scripts those skills invoke.

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- A Pushover account (app token + user token)
- Gmail API access (OAuth2 token) for monitoring

## Environment Variables

Set these in your shell profile or `.env`:

```bash
export PUSHOVER_APP_TOKEN="your-pushover-app-token"
export PUSHOVER_USER_TOKEN="your-pushover-user-token"
export GMAIL_ACCESS_TOKEN="your-gmail-oauth2-token"
```

## Installation

1. Clone this repo
2. Open Claude Code in the repo directory
3. Skills are auto-discovered from `skills/*/SKILL.md`

```bash
cd hudson-pm
claude
```

## Skills

| Skill | Description |
|-------|-------------|
| `airbnb` | Monitor & respond to Airbnb guest messages |
| `pushover` | Send push notifications to property owner |

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/send-pushover.sh` | Send Pushover notification (called by pushover skill) |
| `scripts/scan-gmail.sh` | Scan Gmail for recent Airbnb messages |
| `scripts/monitor.sh` | Full monitoring loop: scan + classify + notify |

## Running the Monitor

### One-shot scan

```bash
bash scripts/monitor.sh 15  # scan last 15 minutes
```

### Via Claude Code cron

Inside Claude Code, set up recurring monitoring:

```
/loop 3m Scan Gmail for new Airbnb messages from last 15 minutes. For each message: categorize urgency, draft reply, send Pushover if urgent.
```

### Via system cron

```cron
*/3 * * * * cd /path/to/hudson-pm && bash scripts/monitor.sh 5
```

## Creating Your Own OpenClaw Skills

1. Create `skills/<name>/SKILL.md` with YAML frontmatter:

```markdown
---
name: my-skill
description: What the skill does and when Claude should use it.
---

# Skill Title

Instructions for Claude when this skill is invoked.
```

2. Reference scripts from `scripts/` for repeatable operations
3. Claude Code auto-discovers skills on startup
