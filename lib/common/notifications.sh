#!/bin/bash

# Sends notifications to all notification channels
# Params: <message>, <footer>
send_notifications() {
  should_send_notifications || return 0

  notify_slack "$1" "$2"
  notify_discord "$1" "$2"
}

# Sends a notification to a Discord webhook
# Params: <message>, <footer>
notify_discord() {
  should_notify_discord || return 0

  payload="{
    \"embeds\": [{
      \"description\": \"$1\",
      \"footer\": {
        \"text\": \"$2\",
        \"icon_url\": \"https://icon-library.com/images/docker-icon/docker-icon-12.jpg\"
      }
    }]
  }"

  curl -H "Content-Type: application/json" -d "$payload" "$DISCORD_WEBHOOK_URL"
}

# Send a notifications to a Slack webhook
# Params: <message>, <footer>
notify_slack() {
  should_notify_slack || return 0

  payload="{
    \"text\": \"$1\",
    \"attachments\": [{
      \"footer\": \"$2\"
    }]
  }"

  curl -X POST --data-urlencode "payload=$payload" "$SLACK_WEBHOOK_URL"
}

should_send_notifications() { [ "$SEND_NOTIFICATIONS" = "$TRUE" ]; }
should_notify_slack() { [ -n "$SLACK_WEBHOOK_URL" ]; }
should_notify_discord() { [ -n "$DISCORD_WEBHOOK_URL" ]; }
