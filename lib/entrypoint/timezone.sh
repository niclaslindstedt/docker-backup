#!/bin/bash

set_timezone() {
  [ -f "/usr/share/zoneinfo/$TZ" ] || error "Invalid timezone"
  sudo ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
  echo "$TZ" | sudo tee /etc/timezone >/dev/null
}
