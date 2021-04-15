#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

test__get_backups__lists_backups_in_backup_folder() {
  test_begin "get_backups lists backups in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  result="$(get_backups | wc -l)"

  # Assert
  assert_equals "3" "$result"
}

test__get_backups__does_not_list_sfv_files() {
  test_begin "get_backups lists backups in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.sfv
  touch /backup/backup-test-backup-20210101155703.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155705.tgz

  # Act
  result="$(get_backups | wc -l)"

  # Assert
  assert_equals "4" "$result"
}

test__get_backups__only_lists_given_argument() {
  test_begin "get_backups lists backups matching given argument in /backup"

  # Arrange
  touch /backup/backup-aaa-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.sfv
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-bbb-backup-20210101155703.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-ccc-backup-20210101155705.tgz

  # Act
  result="$(get_backups "test-backup" | wc -l)"

  # Assert
  assert_equals "2" "$result"
}
