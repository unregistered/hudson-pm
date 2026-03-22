#!/usr/bin/env bash
set -euo pipefail

# Send push notifications via Pushover API
# Requires: PUSHOVER_APP_TOKEN, PUSHOVER_USER_TOKEN env vars

: "${PUSHOVER_APP_TOKEN:?Set PUSHOVER_APP_TOKEN}"
: "${PUSHOVER_USER_TOKEN:?Set PUSHOVER_USER_TOKEN}"

TITLE=""
MESSAGE=""
PRIORITY=0
RETRY=30
EXPIRE=3600

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title)   TITLE="$2"; shift 2 ;;
    --message) MESSAGE="$2"; shift 2 ;;
    --priority) PRIORITY="$2"; shift 2 ;;
    --retry)   RETRY="$2"; shift 2 ;;
    --expire)  EXPIRE="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$MESSAGE" ]]; then
  echo "Usage: send-pushover.sh --title 'Title' --message 'Body' [--priority -1|0|1|2]" >&2
  exit 1
fi

CURL_ARGS=(
  -s -o /dev/null -w "%{http_code}"
  -X POST https://api.pushover.net/1/messages.json
  -d "token=${PUSHOVER_APP_TOKEN}"
  -d "user=${PUSHOVER_USER_TOKEN}"
  -d "title=${TITLE}"
  -d "message=${MESSAGE}"
  -d "priority=${PRIORITY}"
)

# Emergency priority requires retry/expire
if [[ "$PRIORITY" == "2" ]]; then
  CURL_ARGS+=(-d "retry=${RETRY}" -d "expire=${EXPIRE}")
fi

HTTP_CODE=$(curl "${CURL_ARGS[@]}")

if [[ "$HTTP_CODE" == "200" ]]; then
  echo "Notification sent (priority=${PRIORITY})"
else
  echo "Failed: HTTP ${HTTP_CODE}" >&2
  exit 1
fi
