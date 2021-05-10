#!/bin/bash

get_volume_name() {
  is_archive "$1" || return 1
  echo "$1" | sed -E "s/.+?backup\-(.+?)\-.+?$/\1/g"
}

get_backups() {
  go "$BACKUP_PATH"
    # shellcheck disable=SC2162
    find . -iname "backup-${1:-*}-??????????????.*" | \
      while read f; do is_archive "$f" && basename "$f"; done
  back
}

get_backup_count() { get_backups | wc -l; }
get_latest_backup() { get_backups "$1" | sort -r -n | head -n 1; }
get_oldest_backup() { get_backups "$1" | sort -n | head -n 1; }
get_reversed_backups() { get_backups "$1" | sort -n -r; }

is_archive() {
  [[ "$(basename "$1")" =~ backup\-(.+?)\-[0-9]{14}\.(tgz|zip|rar|7z)(\.enc)?$ ]];
}
