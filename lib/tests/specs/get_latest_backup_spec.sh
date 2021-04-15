#!/bin/bash

testspec__get_latest_backup__outputs_the_latest_backup_in_backup_folder() {
  test_begin "get_latest_backup outputs the latest backup in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  result="$(get_latest_backup)"

  # Assert
  assert_equals "backup-test-backup-20210101155704.tgz" "$result"
}
