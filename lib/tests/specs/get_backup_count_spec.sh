#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

testspec__get_backup_count__outputs_backup_count_in_backup_folder() {
  test_begin "get_backup_count outputs backup count in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155703.tgz
  touch /backup/backup-test-backup-20210101155704.tgz

  # Act
  result="$(get_backup_count)"

  # Assert
  assert_equals "4" "$result"
}
