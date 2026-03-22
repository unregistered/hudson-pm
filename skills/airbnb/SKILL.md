---
name: airbnb
description: Manage Airbnb guest communications, monitor messages, draft responses, and handle inquiries. Use when receiving Airbnb guest messages, setting up guest monitoring, drafting responses to inquiries about check-ins, amenities, local recommendations, or handling booking modifications.
---

# Airbnb Guest Manager

Manage Airbnb guest communications end-to-end.

## Monitoring

The cron job scans Gmail every 3 minutes for:
- Airbnb notifications (@airbnb.com)
- Test messages from the property owner

### Scripts

- `scripts/scan-gmail.sh` — scan Gmail for recent Airbnb messages
- `scripts/monitor.sh` — full loop: scan + classify urgency + send Pushover

```bash
# One-shot scan (last 15 min)
bash scripts/monitor.sh 15

# Or via Claude Code cron
/loop 3m Scan Gmail for new Airbnb messages from last 15 minutes. For each message: categorize urgency, draft reply, send Pushover if urgent.
```

## Communication Style

- Heart react emoji for simple "thanks" messages (no text reply needed)
- Brief text replies for actual questions
- Never promise to follow up later — give definitive answers now
- Professional but warm tone

## Property Quick Reference

- **Property:** 1905 Craftsman duplex, top floor, 2BR/1BA
- **Location:** Westlake, Seattle (between Fremont, South Lake Union, Queen Anne)
- **Check-in:** Self check-in with smart lock, standard 4pm
- **Parking:** Free street parking, easy to find
- **WiFi:** 581 Mbps verified
- **House Rules:** No smoking, no pets
- **Not Included:** No TV, no washer/dryer

## Urgency Classification

**Emergency:**
- Guest locked out / can't access property
- Safety issues
- Broken appliances affecting stay
- Keywords: EMERGENCY, URGENT, LOCKED OUT, BROKEN, HELP
- Action: Draft response + send Pushover (priority 2)

**Normal:**
- Check-in questions
- Parking, WiFi, amenities
- Pre-arrival questions
- Booking modifications
- Action: Draft response + send Pushover (priority 1)

## Response Workflow

1. Identify urgency level
2. Check property details for factual answers
3. Draft concise, helpful response
4. Send Pushover notification (use `pushover` skill) if host action needed
