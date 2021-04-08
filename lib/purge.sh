#!/bin/bash

# This script will remove backups that are older
# than x days from the backup location.

COMPONENT="PURGE"

main() {
  log "Starting purge process"

  go "$BACKUP_PATH"

  for file_to_purge in *; do
    [ -f "$file_to_purge" ] && purge "$file_to_purge" "$KEEP_BACKUPS_FOR_DAYS"
  done

  back

  log "Finished purge process"
}

purge() {
  current_unixtime=$(date +"%s")
  file_unixtime=$(get_filetime "$1")
  file_age=$(((current_unixtime - file_unixtime) / 86400))
  [ "$file_age" -gt "$2" ] && {
    log "$1 is $file_age days old (limit is $2 days). Removing."
    rm -f "${1:?}"
  }
}

source "$APP_PATH/common.sh"

main "$1"
