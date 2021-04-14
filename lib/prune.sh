#!/bin/bash

# This script will remove backups that are older than x days from
# the backup location and prune backups in the long-term storage
# to keep disks from overflowing.

COMPONENT="PRUNE"

main() {
  log "Starting prune process"

  #purge_backups
  prune_lts

  log "Finished prune process"
}

purge_backups() {
  local file_unixtime

  log "Purging short-term backups that are older than $KEEP_BACKUPS_FOR_DAYS days"
  go "$BACKUP_PATH"
    for filename in $(get_reversed_backups); do
      [ ! -f "$filename" ] && continue
      file_unixtime="$(get_filetime "$filename")"
      [ "$(($(unixtime) - file_unixtime))" -gt "$((KEEP_BACKUPS_FOR_DAYS * ))" ] && {
        logv "Purging $filename"
        #rm -f $filename $filename.sfv
      }
    done
  back
}

prune_lts() {
  log "Purging long-term storage"
  go "$LTS_PATH"
    prune_lts_daily
    prune_lts_weekly
    prune_lts_monthly
  back
}

prune_lts_daily() {
  local start_time stop_time

  log "Pruning backups that are between $KEEP_DAILY_AFTER_HOURS hours and $KEEP_WEEKLY_AFTER_DAYS days -- keeping 1 per day"

  start_time="$(($(unixtime) - KEEP_DAILY_AFTER_HOURS * ONE_HOUR))"
  stop_time="$(($(unixtime) - KEEP_WEEKLY_AFTER_DAYS * ONE_DAY))"
  prune_lts_loop "$start_time" "$stop_time" "$ONE_DAY" "days"
}

prune_lts_weekly() {
  local start_time stop_time

  log "Pruning backups that are between $KEEP_WEEKLY_AFTER_DAYS days and $KEEP_MONTHLY_AFTER_WEEKS weeks -- keeping 1 per week"

  start_time="$(($(unixtime) - KEEP_WEEKLY_AFTER_DAYS * ONE_DAY))"
  stop_time="$(($(unixtime) - KEEP_MONTHLY_AFTER_WEEKS * ONE_WEEK))"
  prune_lts_loop "$start_time" "$stop_time" "$ONE_WEEK" "weeks"
}

prune_lts_monthly() {
  local start_time

  log "Pruning backups that are between $KEEP_MONTHLY_AFTER_WEEKS weeks and $KEEP_LTS_FOR_MONTHS months -- keeping 1 per month"

  start_time="$(($(unixtime) - KEEP_MONTHLY_AFTER_WEEKS * ONE_WEEK))"
  prune_lts_loop "$start_time" 0 "$ONE_MONTH" "months"
}

prune_lts_loop() {
  local start_time stop_time decrements unit removal_time compare_time file_unixtime

  start_time="$1"
  stop_time="$2"
  decrements="$3"
  unit="$4"

  # If a file is older than this, it should no longer be kept around
  removal_time="$(($(unixtime) - KEEP_LTS_FOR_MONTHS * ONE_MONTH))"

  # Loop through all volumes in the lts storage
  for volume_name in *; do

    log "Entering $volume_name"
    go $volume_name
    compare_time="$(unixtime)"

      # Get a list of all backups, newest first, and loop through them
      for filename in $(get_reversed_backups); do

        # Go to next file if this is not a file
        [ ! -f "$filename" ] && continue
        file_unixtime="$(get_filetime "$filename")"

        # Go to next file if the file is newer than start_time
        [ "$file_unixtime" -gt "$start_time" ] && continue

        # Stop processing files if the file is older than stop_time
        [ "$file_unixtime" -lt "$stop_time" ] && break

        # Remove file if file is one decrement older than compare_time
        # or older than removal_time
        [ "$((compare_time - file_unixtime))" -lt "$decrements" ] || \
        [ "$file_unixtime" -lt "$removal_time" ] && {
          logv "Pruning $filename"
          rm -f "$filename" "$filename.sfv"
          continue
        }

        logv "Keeping $filename $(($(unixtime) - file_unixtime)) $decrements $unit old"

        # Calculate time for next backup
        compare_time="$((compare_time - decrements))"

      done

    back

  done
}

source "$APP_PATH/common.sh"

main "$1"
