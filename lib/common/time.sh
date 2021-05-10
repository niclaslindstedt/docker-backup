#!/bin/bash

parse_time() {
  local file_date file_year file_month file_day file_hour file_minute file_second

  ! contains_numeric_date "$1" && { echo "0"; return 1; }

  file_date=$(echo "$1" | grep -Eo '[[:digit:]]{14}')
  file_year=$(echo "$file_date" | cut -c1-4)
  file_month=$(echo "$file_date" | cut -c5-6)
  file_day=$(echo "$file_date" | cut -c7-8)
  file_hour=$(echo "$file_date" | cut -c9-10)
  file_minute=$(echo "$file_date" | cut -c11-12)
  file_second=$(echo "$file_date" | cut -c13-14)
  date --date "$file_year-$file_month-$file_day $file_hour:$file_minute:$file_second" +"%s"
}

contains_numeric_date() {
  # Contains a substring of YYYYMMDDHHmmss
  [[ "$1" =~ (19[7-9][0-9]|20[0-3][0-9])(01|02|03|04|05|06|07|08|09|10|11|12)([0-2][0-9]|30|31)([0-1][0-9]|2[0-3])([0-5][0-9])([0-5][0-9]) ]]
}

datetime() { date +"%Y%m%d%H%M%S"; }
unixtime() { date +"%s"; }
unixtime_this_hour() { date --date="$(date +"%Y-%m-%d %H:00:00")" +%s; }
unixtime_this_day() { date --date="$(date +"%Y-%m-%d 00:00:00")" +%s; }
unixtime_this_week() { date -d @"$(($(unixtime_this_day) - ($(date +%u) - 1) * 86400))" +%s; }
unixtime_this_month() { date --date="$(date +"%Y-%m-01 00:00:00")" +%s; }
date_from_unixtime() { date -d @"$1" +"%Y-%m-%d %H:00:00"; }
timezone_difference() { echo $((10#$(date -d @43200 +%H) - 12)); }
