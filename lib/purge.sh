#!/bin/bash

# This script will remove backups that are older
# than x days from the backup location.

COMPONENT="PRUNE"

main() {
  log "Starting prune process"

  #prune_backups
  prune_lts

  log "Finished prune process"
}

prune_backups() {
  log "Purging backups"
  go "$BACKUP_PATH"
    for filename in $(get_reversed_backups); do
      [ ! -f "$filename" ] && continue
      file_unixtime="$(get_filetime "$filename")"
      days_old="$((($(unixtime) - $file_unixtime) / ONE_DAY))"
      [ "$days_old" -gt "$KEEP_BACKUPS_FOR_DAYS" ] && {
        log "$filename is $days_old days old (limit is $KEEP_BACKUPS_FOR_DAYS days). Removing."
        rm -f $filename $filename.sfv
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
  log "Purging backups that are between $KEEP_DAILY_AFTER_HOURS hours and $KEEP_WEEKLY_AFTER_DAYS days -- keeping 1 per day"

  start_time="$(($(unixtime) - KEEP_DAILY_AFTER_HOURS * ONE_HOUR))"
  stop_time="$(($(unixtime) - KEEP_WEEKLY_AFTER_DAYS * ONE_DAY))"
  prune_lts_loop "$start_time" "$stop_time" "$ONE_DAY" "days"
}

prune_lts_weekly() {
  log "Purging backups that are between $KEEP_WEEKLY_AFTER_DAYS days and $KEEP_MONTHLY_AFTER_WEEKS weeks -- keeping 1 per week"

  start_time="$(($(unixtime) - KEEP_WEEKLY_AFTER_DAYS * ONE_DAY))"
  stop_time="$(($(unixtime) - KEEP_MONTHLY_AFTER_WEEKS * ONE_WEEK))"
  prune_lts_loop "$start_time" "$stop_time" "$ONE_WEEK" "weeks"
}

prune_lts_monthly() {
  log "Purging backups that are between $KEEP_MONTHLY_AFTER_WEEKS weeks and $KEEP_LTS_FOR_MONTHS months -- keeping 1 per month"

  start_time="$(($(unixtime) - KEEP_MONTHLY_AFTER_WEEKS * ONE_WEEK))"
  prune_lts_loop "$start_time" 0 "$ONE_MONTH" "months"
}

prune_lts_loop() {
  start_time="$1"
  stop_time="$2"
  decrements="$3"
  unit="$4"

  removal_time="$(($(unixtime) - KEEP_LTS_FOR_MONTHS * ONE_MONTH))"
  decrement_num=1
  for volume_name in *; do
    log "Entering $volume_name"
    go $volume_name
      for filename in $(get_reversed_backups); do
        compare_time="$(($(unixtime) - decrements * decrement_num))"
        [ ! -f "$filename" ] && continue
        file_unixtime="$(get_filetime "$filename")"
        [ "$file_unixtime" -gt "$start_time" ] && continue
        [ "$file_unixtime" -lt "$stop_time" ] && break
        [ "$file_unixtime" -gt "$compare_time" ] || \
        [ "$file_unixtime" -lt "$removal_time" ] && {
          log "Removing $filename"
          rm -f $filename $filename.sfv
          continue
        }
        log "Keeping $filename ($decrement_num)"
        ((decrement_num++))
      done
    back
  done
}

source "$APP_PATH/common.sh"

main "$1"
