#!/bin/bash

# shellcheck disable=SC1091,SC2162

source "$APP_PATH/common.sh"

test__get_reversed_backups__outputs_backups_in_reversed_order_in_backup_folder() {
  test_begin "get_reversed_backups outputs backups in reversed order in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  LFS=$'\n' read -d '' -a files <<< "$(get_reversed_backups)"

  # Assert
  assert_equals "backup-test-backup-20210101155704.tgz" "${files[0]}"
  assert_equals "backup-test-backup-20210101155701.tgz" "${files[3]}"
  assert_equals "4" "${#files[@]}"
}
