#!/bin/bash

# Check if current user has permission to access important folders
check_permissions() {
  check_permission "$VOLUME_PATH"
  check_permission "$BACKUP_PATH"
  check_permission "$LTS_PATH"
  check_permission "$TMP_PATH"
}

# Check if user has access to a path
# Params: <path>
check_permission() {
  ! is_directory "$1" && error "Permissions NOT OK for $1 (path does not exist)"
  if [ ! -x "$1" ] || [ ! -r "$1" ] || [ ! -w "$1" ]; then
    echo "FATAL: Insufficient permissions for $1"
    exit 1
  fi
  echo "Permissions OK for $1"
}
