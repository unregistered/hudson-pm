# Hudson - AI Property Manager

An AI assistant designed to help Airbnb hosts manage their properties efficiently.

## What I Do

I handle the day-to-day operational tasks of property management so you don't have to. From guest communication to routine monitoring, I keep things running smoothly behind the scenes.

## Core Capabilities

### Guest Communication
- **Message Monitoring**: I check for new guest messages regularly and can respond to common inquiries about check-in, amenities, and local recommendations
- **Booking Inquiries**: Handle questions from potential guests before they book
- **Check-in/Check-out Coordination**: Send reminders and instructions to guests
- **Issue Resolution**: Triage guest concerns and escalate urgent issues to you

### Booking & Calendar Management
- Monitor reservation requests and approvals
- Track upcoming check-ins and check-outs
- Alert you to gaps in the calendar that might need attention
- Watch for special requests or notes from guests

### Operational Monitoring
- **Automated Checks**: Run scheduled checks for new messages, reviews, and booking updates
- **Alert System**: Notify you immediately when something needs your attention
- **Routine Tasks**: Handle repetitive administrative work on your behalf

### Research & Information
- Look up local information for guest recommendations
- Research pricing trends or competitor listings
- Find solutions to maintenance or operational questions
- Stay updated on Airbnb policy changes

### Memory & Context
- Remember guest preferences and past interactions
- Track maintenance history and vendor relationships
- Maintain records of what works (and what doesn't)
- Learn your preferences over time

## How to Work With Me

### Daily Operations
I run in the background and proactively notify you of anything requiring attention. No need to micromanage — I'll surface what's important.

### Communication Channels
I can reach you (and guests, where appropriate) through multiple channels:
- Web chat (primary interface)
- Email notifications
- Messaging apps (WhatsApp, Telegram, Signal, etc.)
- Push notifications

### Task Delegation
Just tell me what you need:
- "Check for new guest messages"
- "Draft a response to [guest name] about [topic]"
- "Remind me to schedule cleaning for Friday"
- "Research good restaurants near the property"

## What I Don't Do

- Make financial decisions (pricing changes, refunds) without your approval
- Access or modify sensitive account settings
- Make legally binding commitments
- Replace human judgment on complex guest issues

## Dependencies

Hudson relies on [Hyperspell](https://hyperspell.com) for memory and context management. Hyperspell connects with email, calendar, and docs to give Hudson the context it needs to manage your property effectively.

## Project Structure

```
skills/
  airbnb/SKILL.md    — Guest communication & monitoring skill
  pushover/SKILL.md  — Push notification skill
scripts/
  send-pushover.sh   — Send Pushover notifications
  scan-gmail.sh      — Scan Gmail for Airbnb messages
  monitor.sh         — Full monitoring loop (scan + classify + notify)
docs/
  setup.md           — Setup & configuration guide
```

## Quick Start

See [docs/setup.md](docs/setup.md) for full setup instructions.

```bash
# Set env vars
export PUSHOVER_APP_TOKEN="..."
export PUSHOVER_USER_TOKEN="..."
export GMAIL_ACCESS_TOKEN="..."

# Open Claude Code
claude
```

## Privacy & Security

- Guest data is handled securely and only used for operational purposes
- I don't share your property details or guest information externally
- All communications are logged for transparency
