#!/bin/bash

check_permissions() {
  check_permission "$VOLUME_PATH"
  check_permission "$BACKUP_PATH"
  check_permission "$LTS_PATH"
}

check_permission() {
  if [ ! -x "$1" ] || [ ! -r "$1" ] || [ ! -w "$1" ]; then
    echo "FATAL: Insufficient permissions for $1"
    exit 1
  fi
  echo "Permissions OK for $1"
}
