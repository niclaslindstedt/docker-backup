#!/bin/bash

# Extract the volume name from a backup filename/path
# Params: <filename|path>
get_volume_name() {
  ! is_backup "$1" && ! is_prerestore_backup "$1" && return 1
  echo "$1" | sed -E "s/.+?backup\-(.+?)\-.+?$/\1/g"
}

# Get a list of backups currently in the backup directory
# Params: [volume name]
get_backups() {
  go "$BACKUP_PATH"
    # shellcheck disable=SC2162
    find . -iname "backup-${1:-*}-??????????????.*" | \
      while read f; do is_backup "$f" && basename "$f"; done
  back
}

# Get a list pre-restore backups currently in the backup directory
# Params: [volume name]
get_prerestore_backups() {
  go "$BACKUP_PATH"
    # shellcheck disable=SC2162
    find . -iname "prerestore+*backup-${1:-*}-??????????????.*+??????????????.*" | \
      while read f; do is_prerestore_backup "$f" && basename "$f"; done
  back
}

# Copies a backup to a target path
# Params: <backup path>, <target path>
copy_backup() {
  log3 "+ Copying process started"

  copy_backup_files "$1" "$2"

  log3 "- Copying process finished"
}

# Move a backup to a target path
# Params: <backup path>, <target path>
move_backup() {
  local backup_name

  log3 "+ Moving process started"

  backup_name="${1%*.gpg}"
  copy_backup_files "$backup_name" "$2"
  remove_file "$backup_name" "$backup_name.sfv" "$backup_name.gpg" "$backup_name.gpg.sfv"

  log3 "- Moving process finished"
}

copy_backup_files() {
  local backup_name

  ! is_directory "$2" && error "Target path should be a directory"

  backup_name="${1%*.gpg}"
  copy_soft "$backup_name.sfv" "$2"
  copy_soft "$backup_name" "$2"
  verify_checksum "$2/$(basename "$backup_name")"
  copy_soft "$backup_name.gpg.sfv" "$2"
  copy_soft "$backup_name.gpg" "$2"
  verify_checksum "$2/$(basename "$backup_name").gpg"
}

# Helper functions
get_backup_count() { get_backups | wc -l; }
get_latest_backup() { get_backups "$1" | sort -r -n | head -n 1; }
get_oldest_backup() { get_backups "$1" | sort -n | head -n 1; }
get_latest_prerestore_backup() { get_prerestore_backups "$1" | sort -r -n | head -n 1; }
get_reversed_backups() { get_backups "$1" | sort -n -r; }
