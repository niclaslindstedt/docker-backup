#!/bin/bash

# Set current timezone to the value of the TZ variable
set_timezone() {
  [ -f "/usr/share/zoneinfo/$TZ" ] || {
    echo "Invalid timezone"
    exit 1
  }

  sudo ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
  echo "$TZ" | sudo tee /etc/timezone >/dev/null

  echo "Timezone set to $TZ"
}
