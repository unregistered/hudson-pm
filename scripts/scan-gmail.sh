#!/usr/bin/env bash
set -euo pipefail

# Scan Gmail for recent Airbnb messages via Gmail API
# Requires: GMAIL_ACCESS_TOKEN env var (OAuth2 token)

: "${GMAIL_ACCESS_TOKEN:?Set GMAIL_ACCESS_TOKEN}"

MINUTES=15
QUERY="from:airbnb.com"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --minutes) MINUTES="$2"; shift 2 ;;
    --query)   QUERY="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

# Calculate epoch timestamp for N minutes ago
if [[ "$(uname)" == "Darwin" ]]; then
  AFTER=$(date -v-"${MINUTES}"M +%s)
else
  AFTER=$(date -d "${MINUTES} minutes ago" +%s)
fi

SEARCH_QUERY="${QUERY} after:${AFTER}"
ENCODED_QUERY=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${SEARCH_QUERY}'))")

# List matching messages
RESPONSE=$(curl -s \
  -H "Authorization: Bearer ${GMAIL_ACCESS_TOKEN}" \
  "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=${ENCODED_QUERY}&maxResults=10")

MESSAGE_IDS=$(echo "$RESPONSE" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for msg in data.get('messages', []):
    print(msg['id'])
" 2>/dev/null || true)

if [[ -z "$MESSAGE_IDS" ]]; then
  echo "No new Airbnb messages in the last ${MINUTES} minutes."
  exit 0
fi

# Fetch each message
while IFS= read -r MSG_ID; do
  MSG=$(curl -s \
    -H "Authorization: Bearer ${GMAIL_ACCESS_TOKEN}" \
    "https://gmail.googleapis.com/gmail/v1/users/me/messages/${MSG_ID}?format=full")

  echo "$MSG" | python3 -c "
import json, sys, base64
msg = json.load(sys.stdin)
headers = {h['name']: h['value'] for h in msg['payload']['headers']}
print('---')
print(f\"From: {headers.get('From', 'unknown')}\")
print(f\"Subject: {headers.get('Subject', '(no subject)')}\")
print(f\"Date: {headers.get('Date', 'unknown')}\")

# Extract body
parts = msg['payload'].get('parts', [msg['payload']])
for part in parts:
    if part.get('mimeType') == 'text/plain':
        body = part.get('body', {}).get('data', '')
        if body:
            print(f\"Body: {base64.urlsafe_b64decode(body).decode('utf-8', errors='replace')[:500]}\")
            break
print()
"
done <<< "$MESSAGE_IDS"
