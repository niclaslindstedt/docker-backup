#!/bin/bash

# Purge old backups in backup directory
purge_backups() {
  local file_unixtime

  log1 "Purging short-term backups that are older than $KEEP_BACKUPS_FOR_DAYS days"

  go "$BACKUP_PATH"

    logd "Entered $BACKUP_PATH"

    for filename in $(get_reversed_backups "$1"); do

      logd "Analyzing $filename"

      [ ! -f "$filename" ] && continue

      contains_numeric_date "$filename" || error "Cannot parse date in filename: $filename"

      file_unixtime="$(parse_time "$filename")"
      [ "$(($(unixtime) - file_unixtime))" -gt "$((KEEP_BACKUPS_FOR_DAYS * ONE_DAY))" ] && {
        log4 "Purging $filename"
        remove_backup "$filename"
      }

    done

  back
}
