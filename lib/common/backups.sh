#!/bin/bash

# Extract the volume name from a backup filename/path
# Params: <filename|path>
get_volume_name() {
  ! is_backup "$1" && return 1
  echo "$1" | sed -E "s/.+?backup\-(.+?)\-.+?$/\1/g"
}

# Get a list backups currently in the backup directory
# Params: [volume name]
get_backups() {
  go "$BACKUP_PATH"
    # shellcheck disable=SC2162
    find . -iname "backup-${1:-*}-??????????????.*" | \
      while read f; do is_backup "$f" && basename "$f"; done
  back
}

# Helper functions
get_backup_count() { get_backups | wc -l; }
get_latest_backup() { get_backups "$1" | sort -r -n | head -n 1; }
get_oldest_backup() { get_backups "$1" | sort -n | head -n 1; }
get_reversed_backups() { get_backups "$1" | sort -n -r; }
