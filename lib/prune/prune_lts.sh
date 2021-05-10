#!/bin/bash

# shellcheck disable=SC1091,SC2034

prune_lts() {
  local purge_age monthly_age weekly_age daily_age

  purge_age="$(($(unixtime_this_hour) - KEEP_LTS_FOR_MONTHS * ONE_MONTH))"
  monthly_age="$(($(unixtime_this_hour) - KEEP_MONTHLY_AFTER_WEEKS * ONE_WEEK))"
  weekly_age="$(($(unixtime_this_hour) - KEEP_WEEKLY_AFTER_DAYS * ONE_DAY))"
  daily_age="$(($(unixtime_this_hour) - KEEP_DAILY_AFTER_HOURS * ONE_HOUR))"

  logd "Purge cutoff: $(date_from_unixtime "$purge_age")"
  logd "Monthly cutoff: $(date_from_unixtime "$monthly_age")"
  logd "Weekly cutoff: $(date_from_unixtime "$weekly_age")"
  logd "Daily cutoff: $(date_from_unixtime "$daily_age")"

  go "$LTS_PATH"

    prepare_backup_data .

    for volume_name in *; do

      for backup in $(get_backups_by_hour "$volume_name"); do
        local filename hours_old last_month last_week last_day last_hour file_age_days

        file_name="$(get_backup_filename "$backup")"
        file_path="$(get_backup_path "$backup")"
        file_unixtime="$(get_backup_unixtime "$backup")"
        file_age_days="$(get_backup_age_days "$backup")"
        file_age_weeks="$(get_backup_age_weeks "$backup")"
        file_age_months="$(get_backup_age_months "$backup")"

        # Purge old
        if [ "$file_unixtime" -le "$purge_age" ]; then

          log "Removing old backup: $file_name ($file_age_months months old)"

          # Remove all backups older than purge date
          purge_file "$file_path"
          last_month="$(get_backup_month "$backup")"

        # Purge monthly
        elif [ "$file_unixtime" -le "$monthly_age" ]; then

          # Only keep one per month -- keep the earliest
          if [ "$(get_backup_month "$backup")" = "$last_month" ]; then
            logd "Removing monthly backup: $file_name ($file_age_months months old)"
            purge_file "$file_path"
            continue
          fi

          log "Keeping monthly backup: $file_name ($file_age_months months old)"
          last_month="$(get_backup_month "$backup")"
          last_week="$(get_backup_week "$backup")"

        # Purge weekly
        elif [ "$file_unixtime" -le "$weekly_age" ]; then

          # Only keep one per week -- keep the earliest
          if [ "$(get_backup_week "$backup")" = "$last_week" ]; then
            logd "Removing weekly backup: $file_name ($file_age_weeks weeks old)"
            purge_file "$file_path"
            continue
          fi

          log "Keeping weekly backup: $file_name ($file_age_weeks weeks old)"
          last_week="$(get_backup_week "$backup")"
          last_day="$(get_backup_day "$backup")"

        # Purge daily
        elif [ "$file_unixtime" -le "$daily_age" ]; then

          # Only keep one per day -- keep the earliest
          if [ "$(get_backup_day "$backup")" = "$last_day" ]; then
            purge_file "$file_path"
            continue
          fi

          log "Keeping daily backup: $file_name ($file_age_days days old)"
          last_day="$(get_backup_day "$backup")"

        fi

      done

    done

  back

}

purge_file() {
  logv "Pruning $filename"
  rm -f "$1" >"$OUTPUT"
}
