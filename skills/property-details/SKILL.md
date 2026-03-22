---
name: airbnb-guest-manager
description: Manage Airbnb guest communications, monitor messages, draft responses, and handle inquiries. Use when receiving Airbnb guest messages, setting up guest monitoring, drafting responses to inquiries about check-ins, amenities, local recommendations, or handling booking modifications. Includes property details, messaging templates, and automated monitoring workflow.
---

# Airbnb Guest Manager

Manage Airbnb guest communications end-to-end.

## Quick Start

### Monitor for New Guest Messages

The cron job scans Gmail every 3 minutes for:
- Airbnb notifications (@airbnb.com)
- Test messages from the property owner

```bash
# Check cron status
cron list

# The monitor runs automatically, but to manually trigger:
cron run <job-id>
```

### Draft a Guest Response

When a guest asks a question, check [references/property-details.md](references/property-details.md) for facts, then:

1. Identify urgency (emergency vs normal inquiry)
2. Draft concise, helpful response
3. Send Pushover notification if urgent

## Communication Style

**Default approach:**
- Heart react emoji for simple "thanks" messages (no text reply needed)
- Brief text replies for actual questions
- Never promise to follow up later — give definitive answers now
- Professional but warm tone

**Response templates in:** [references/message-templates.md](references/message-templates.md)

## Property Quick Reference

- **Property:** 1905 Craftsman duplex, top floor, 2BR/1BA
- **Location:** Westlake, Seattle (between Fremont, South Lake Union, Queen Anne)
- **Check-in:** Self check-in with smart lock, standard 4pm
- **Parking:** Free street parking, easy to find
- **WiFi:** 581 Mbps verified
- **House Rules:** No smoking, no pets
- **Not Included:** No TV, no washer/dryer

**Full details in:** [references/property-details.md](references/property-details.md)

## Emergency vs Normal Priority

**Priority 2 (Emergency):**
- Guest locked out / can't access property
- Safety issues
- Broken appliances affecting stay
- Keywords: EMERGENCY, URGENT, LOCKED OUT, BROKEN, HELP

**Priority 1 (Normal):**
- Check-in questions
- Parking, WiFi, amenities
- Pre-arrival questions
- Booking modifications

## Pushover Notifications

For urgent messages, send Pushover alert:

```bash
curl -X POST https://api.pushover.net/1/messages.json \
  -d "token=<APP_TOKEN>" \
  -d "user=<USER_TOKEN>" \
  -d "title=[Guest Name] - [Issue]" \
  -d "message=[Summary + Draft Reply]" \
  -d "priority=<1 or 2>"
```

## Automating Guest Monitoring

Set up a cron job to scan for messages:

```javascript
// Example cron payload for isolated agentTurn
{
  "kind": "agentTurn",
  "message": "Scan Gmail for new Airbnb messages from last 15 minutes. For each message requiring response: categorize urgency, draft reply, send Pushover notification if urgent."
}
```

See [references/monitoring-setup.md](references/monitoring-setup.md) for full configuration.
