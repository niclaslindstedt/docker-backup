#!/bin/bash

# Prepare long-term storage backup data for use by the prune script
prepare_backup_data() {
  local csv_filename

  ! is_directory "$LTS_PATH/$1" && error "'$1' is not a valid volume"

  log "Entering $1"
  csv_filename="$(get_prune_csv_filename "$1")"
  echo -n > "$csv_filename"

  go "$LTS_PATH/$1"

    for file_name in *; do

      local file_fullpath file_volume file_unixtime file_year file_month file_week file_day file_hour file_size

      logd "Analyzing $file_name"

      # Go to next file if this is not a file
      [ ! -f "$file_name" ] && continue

      # Go to next file if this is a checksum file
      [[ "$file_name" =~ \.sfv$ ]] && continue

      contains_numeric_date "$file_name" || error "Cannot parse date in filename: $file_name"

      # Get information about backup
      file_fullpath="$(pwd)/$file_name"
      file_volume="$(get_volume_name "$file_name")"
      file_unixtime="$(parse_time "$file_name")"
      file_year="$(date -d @"$file_unixtime" +%Y)"
      file_month="$(((file_year - 1970) * 12 + 10#$(date -d @"$file_unixtime" +%m)))"
      file_week="$(((file_unixtime - $(get_first_monday)) / ONE_WEEK + 1))"
      file_dow="$(date -d @"$file_unixtime" +%u)"
      file_day="$((file_unixtime / ONE_DAY))"
      file_hour="$((file_unixtime / ONE_HOUR))"
      file_age_hours="$((($(unixtime_this_hour) - file_unixtime) / ONE_HOUR))" # age from the last hour (e.g. if time is 12:48, we count from 12:00)
      file_age_days="$((($(unixtime_this_day) - file_unixtime) / ONE_DAY + 1))" # age from the start of this day (e.g. from today 00:00)
      file_age_weeks="$((($(unixtime_this_week) - file_unixtime) / ONE_WEEK + 1))" # age from the start of this week (i.e. from this week's monday at 00:00)
      file_age_months="$((($(unixtime_this_month) - file_unixtime) / ONE_MONTH + 1))" # age from the start of this month (i.e. from this months's first day at 00:00)
      file_size="$(get_file_size "$file_name")"

      echo "$file_volume;$file_name;$file_fullpath;$file_unixtime;$file_year;$file_month;$file_week;$file_day;$file_hour;$file_age_hours;$file_age_days;$file_age_weeks;$file_age_months;$file_dow;$file_size" >> "$csv_filename"

    done

  back
}

# Returns unixtime of the first monday of 1970
get_first_monday() { echo $((345600 + $(timezone_difference) * 3600)); }

# Helper functions for csv written in prepare_backup_data()
get_backup_volume() { get_backup_info_by_column "$1" 1; }
get_backup_filename() { get_backup_info_by_column "$1" 2; }
get_backup_path() { get_backup_info_by_column "$1" 3; }
get_backup_unixtime() { get_backup_info_by_column "$1" 4; }
get_backup_month() { get_backup_info_by_column "$1" 6; }
get_backup_week() { get_backup_info_by_column "$1" 7; }
get_backup_day() { get_backup_info_by_column "$1" 8; }
get_backup_hour() { get_backup_info_by_column "$1" 9; }
get_backup_age_hours() { get_backup_info_by_column "$1" 10; }
get_backup_age_days() { get_backup_info_by_column "$1" 11; }
get_backup_age_weeks() { get_backup_info_by_column "$1" 12; }
get_backup_age_months() { get_backup_info_by_column "$1" 13; }
get_backup_info_by_column() { echo "$1" | cut -d\; -f"$2"; }
get_backups_by_month() { get_backups_by_column "$1" 6; }
get_backups_by_week() { get_backups_by_column "$1" 7; }
get_backups_by_day() { get_backups_by_column "$1" 8; }
get_backups_by_hour() { get_backups_by_column "$1" 9; }
get_backups_by_age() { get_backups_by_column "$1" 10; }
get_backups_by_column() { sort -k"$2" -n -t\; "$(get_prune_csv_filename "$1")"; }
get_prune_csv_filename() { mkdir -p /tmp/prune/; echo "/tmp/prune/$1.csv"; }
