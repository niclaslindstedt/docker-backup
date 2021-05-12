#!/bin/bash

# Parse the date of a backup and convert it to unixtime
# Params: <filename|path>
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

# Checks if a string contains a substring of YYYYMMDDHHmmss
# Params: <string>
contains_numeric_date() {
  [[ "$1" =~ (19[7-9][0-9]|20[0-3][0-9])(01|02|03|04|05|06|07|08|09|10|11|12)([0-2][0-9]|30|31)([0-1][0-9]|2[0-3])([0-5][0-9])([0-5][0-9]) ]]
}

# Returns current datetime in YYYYMMDDHHmmss format
datetime() { date +"%Y%m%d%H%M%S"; }

# Returns current datetime unixtime
unixtime() { date +"%s"; }

# Returns start of current hour in unixtime
unixtime_this_hour() { date --date="$(date +"%Y-%m-%d %H:00:00")" +%s; }

# Returns start of current day in unixtime
unixtime_this_day() { date --date="$(date +"%Y-%m-%d 00:00:00")" +%s; }

# Returns start of current week in unixtime
unixtime_this_week() { date -d @"$(($(unixtime_this_day) - ($(date +%u) - 1) * 86400))" +%s; }

# Returns start of current month in unixtime
unixtime_this_month() { date --date="$(date +"%Y-%m-01 00:00:00")" +%s; }

# Converts unixtime into a date with format YYYY-MM-DD HH:00:00 (minutes/seconds reset)
date_from_unixtime() { date -d @"$1" +"%Y-%m-%d %H:00:00"; }

# Calculate the current timezone difference
timezone_difference() { echo $((10#$(date -d @43200 +%H) - 12)); }
