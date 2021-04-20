#!/bin/bash

# shellcheck disable=SC1091,SC2034,SC2012

source "$APP_PATH/common.sh"
source "$APP_PATH/prune_functions.sh"

test__purge_2_day_old_backups() {
  local file_to_restore latest_backup

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

test__purge_4_day_old_backups() {
  local file_to_restore latest_backup

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
