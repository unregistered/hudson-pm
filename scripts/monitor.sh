#!/usr/bin/env bash
set -euo pipefail

# Hudson monitoring loop
# Scans Gmail for Airbnb messages, classifies urgency, sends Pushover alerts
# Designed to run via Claude Code cron or external cron

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MINUTES="${1:-15}"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Scanning last ${MINUTES} minutes..."

# Scan Gmail
MESSAGES=$("${SCRIPT_DIR}/scan-gmail.sh" --minutes "$MINUTES" 2>&1) || {
  echo "Gmail scan failed: ${MESSAGES}" >&2
  "${SCRIPT_DIR}/send-pushover.sh" \
    --title "Hudson: Gmail Scan Failed" \
    --message "Could not scan Gmail. Check GMAIL_ACCESS_TOKEN." \
    --priority 0
  exit 1
}

if [[ "$MESSAGES" == *"No new Airbnb messages"* ]]; then
  echo "No new messages."
  exit 0
fi

echo "Found messages:"
echo "$MESSAGES"

# Check for emergency keywords
EMERGENCY_KEYWORDS="EMERGENCY|URGENT|LOCKED OUT|BROKEN|HELP|FIRE|FLOOD"
if echo "$MESSAGES" | grep -qiE "$EMERGENCY_KEYWORDS"; then
  PRIORITY=2
  TITLE="Hudson: EMERGENCY Guest Message"
elif echo "$MESSAGES" | grep -qiE "check.?in|parking|wifi|key|access|door"; then
  PRIORITY=1
  TITLE="Hudson: Guest Message (Action Needed)"
else
  PRIORITY=0
  TITLE="Hudson: New Airbnb Message"
fi

# Extract first subject line for notification
SUBJECT=$(echo "$MESSAGES" | grep -m1 "^Subject:" | sed 's/^Subject: //' || echo "New message")

"${SCRIPT_DIR}/send-pushover.sh" \
  --title "$TITLE" \
  --message "$SUBJECT" \
  --priority "$PRIORITY"

echo "Notification sent (priority=${PRIORITY})"
