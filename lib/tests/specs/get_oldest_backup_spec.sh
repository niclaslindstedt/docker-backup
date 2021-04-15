#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

testspec__get_oldest_backup__outputs_the_oldest_backup_in_backup_folder() {
  test_begin "get_oldest_backup outputs the oldest backup in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  result="$(get_oldest_backup)"

  # Assert
  assert_equals "backup-test-backup-20210101155701.tgz" "$result"
}
