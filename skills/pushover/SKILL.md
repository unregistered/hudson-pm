---
name: pushover
description: Send push notifications via Pushover API. Use when you need to alert the property owner about urgent guest issues, emergencies, or any time-sensitive information that requires immediate attention.
---

# Pushover Notifications

Send push notifications to the property owner via the Pushover API.

## Usage

Run the send script from the project root:

```bash
bash scripts/send-pushover.sh --title "Title" --message "Body" --priority 0
```

Args: `--title`, `--message`, `--priority` (-1, 0, 1, 2), `--retry`, `--expire`.

Requires env vars: `PUSHOVER_APP_TOKEN`, `PUSHOVER_USER_TOKEN`.

## Priority Levels

| Priority | Value | Use Case |
|----------|-------|----------|
| Low | -1 | Informational, no alert sound |
| Normal | 0 | Standard notifications |
| High | 1 | Urgent — bypasses quiet hours |
| Emergency | 2 | Requires acknowledgment, retries every 30s |

**Emergency (priority=2)** requires additional params:
- `retry=30` — retry interval in seconds (min 30)
- `expire=3600` — stop retrying after N seconds (max 86400)

## When to Notify

**Emergency (priority 2):**
- Guest locked out / can't access property
- Safety issues (fire, flood, break-in)
- Broken appliances affecting habitability

**High (priority 1):**
- New guest message requiring host response
- Booking modification requests
- Check-in issues

**Normal (priority 0):**
- New booking confirmed
- Review received
- Routine status updates

**Low (priority -1):**
- Informational summaries
- Non-urgent reminders
