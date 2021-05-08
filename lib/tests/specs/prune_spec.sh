#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034,SC2012

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/prune/*; do . "$f"; done

test__purge_backups__purge_2_day_old_backups() {
  test_begin "Purge 2 day old backups from short-term backup path"

  # Arrange
  KEEP_BACKUPS_FOR_DAYS=2
  unixtime() { date --date "2021-01-15 00:00:00" +"%s"; }
  touch "$BACKUP_PATH/backup-sample-app-1-20210105125600.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210106125955.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210107125601.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210108125555.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210109170000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210110120000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111150000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111200000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111200001.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210112235000.tgz" # <- edge case -- should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210113150000.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114140500.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114145600.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114152800.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114153000.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114230000.tgz"

  # Act
  purge_backups

  # Assert
  assert_equals "6" "$(ls "$BACKUP_PATH" | wc -l)"
}

test__purge_backups__purge_4_day_old_backups() {
  test_begin "Purge 4 day old backups from short-term backup path"

  # Arrange
  KEEP_BACKUPS_FOR_DAYS=4
  unixtime() { date --date "2021-01-15 20:00:02" +"%s"; }
  touch "$BACKUP_PATH/backup-sample-app-1-20210105125600.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210106125955.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210107125601.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210108125555.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210109170000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210110120000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111150000.tgz" # should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111200001.tgz" # <- edge case -- should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111200002.tgz" # <- edge case -- should be removed
  touch "$BACKUP_PATH/backup-sample-app-1-20210111200003.tgz" # <- edge case
  touch "$BACKUP_PATH/backup-sample-app-1-20210112235000.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210113150000.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114140500.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114145600.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114152800.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114153000.tgz"
  touch "$BACKUP_PATH/backup-sample-app-1-20210114230000.tgz"

  # Act
  purge_backups

  # Assert
  assert_equals "9" "$(ls "$BACKUP_PATH" | wc -l)"
}

test__prune_lts__prune_daily_backups() {
  test_begin "Prune long-term storage backups"

  # Arrange
  KEEP_DAILY_AFTER_HOURS=24
  KEEP_WEEKLY_AFTER_DAYS=7
  unixtime() { date --date "2021-01-01 00:01:23" +"%s"; }
  unixtime_this_hour() { date --date "2021-01-01 00:00:00" +"%s"; }
  unixtime_this_day() { date --date "2021-01-01 00:00:00" +"%s"; }
  generate_hourly_lts_backups "sample-app-1" "2021-01-01 00:00:10" 6 # 6 days of hourly backups ending at 1st jan 00:00:10

  # Act
  prune_lts

  # Assert
  assert_equals "29" "$(ls "$LTS_PATH/sample-app-1" | wc -l)"
}

test__prune_lts__prune_weekly_backups() {
  test_begin "Prune long-term storage backups"

  # Arrange
  KEEP_LTS_FOR_MONTHS=12
  KEEP_DAILY_AFTER_HOURS=24
  KEEP_WEEKLY_AFTER_DAYS=7
  KEEP_MONTHLY_AFTER_WEEKS=10
  unixtime() { date --date "2021-01-01 00:01:23" +"%s"; }
  unixtime_this_hour() { date --date "2021-01-01 00:00:00" +"%s"; }
  unixtime_this_day() { date --date "2021-01-01 00:00:00" +"%s"; }
  unixtime_this_week() { date --date "2020-12-28 00:00:00" +"%s"; }
  unixtime_this_month() { date --date "2020-01-01 00:00:00" +"%s"; }
  generate_daily_lts_backups "sample-app-1" "2021-01-01 00:00:05" 40 # 40 days of daily backups ending at 1st jan 00:00:05
  generate_hourly_lts_backups "sample-app-1" "2021-01-01 00:00:10" 8 # 8 days of hourly backups ending at 1st jan 00:00:10

  # Act
  prune_lts

  # Assert
  assert_equals "37" "$(ls "$LTS_PATH/sample-app-1" | wc -l)"
}

test__prune_lts__prune_monthly_backups() {
  test_begin "Prune long-term storage backups"

  # Arrange
  KEEP_LTS_FOR_MONTHS=12
  KEEP_DAILY_AFTER_HOURS=24
  KEEP_WEEKLY_AFTER_DAYS=7
  KEEP_MONTHLY_AFTER_WEEKS=10
  unixtime() { date --date "2021-01-01 00:01:23" +"%s"; }
  unixtime_this_hour() { date --date "2021-01-01 00:00:00" +"%s"; }
  unixtime_this_day() { date --date "2021-01-01 00:00:00" +"%s"; }
  unixtime_this_week() { date --date "2020-12-28 00:00:00" +"%s"; }
  unixtime_this_month() { date --date "2021-01-01 00:00:00" +"%s"; }
  generate_daily_lts_backups "sample-app-1" "2021-01-01 00:00:05" 370 # 370 days of daily backups ending at 1st jan 00:00:05
  generate_hourly_lts_backups "sample-app-1" "2021-01-01 00:00:10" 8 # 8 days of hourly backups ending at 1st jan 00:00:10

  # Act
  prune_lts

  # Assert
  assert_equals "50" "$(ls "$LTS_PATH/sample-app-1" | wc -l)"
}


# Helper functions

generate_hourly_lts_backups() {
  local timestamp starttime now backuptime backupname

  timestamp="$(date --date="$2" +"%s")"
  starttime="$((timestamp - $3 * ONE_DAY))" # calculate when we should start generating backups
  logd "Hourly backups generated from $starttime"
  now="$(date -d "@$starttime" +"%s")" # start from this date and generate backups until today
  mkdir -p "$LTS_PATH/$1"
  for day in $(seq 1 "$3"); do
    for hour in $(seq -f "%02g" 1 24); do
      backuptime="$(date -d "@$now" +"%Y%m%d%H%M%S")"
      backupname="$LTS_PATH/$1/backup-$1-$backuptime.tgz"
      touch "$backupname"
      now="$((now + ONE_HOUR))"
    done
  done
}

generate_daily_lts_backups() {
  local timestamp starttime now backuptime backupname

  timestamp="$(date --date "$2" +"%s")"
  starttime="$((timestamp - $3 * ONE_DAY))" # calculate when we should start generating backups
  logd "Daily backups generated from $starttime"
  now="$(date -d "@$starttime" +"%s")" # start from this date and generate backups until today
  mkdir -p "$LTS_PATH/$1"
  for day in $(seq 1 "$3"); do
    backuptime="$(date -d "@$now" +"%Y%m%d%H%M%S")"
    backupname="$LTS_PATH/$1/backup-$1-$backuptime.tgz"
    touch "$backupname"
    now="$((now + ONE_DAY))"
  done
}
