#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/store/*; do . "$f"; done

test__run_store__should_copy_the_latest_backup() {
  test_begin "Store should copy the latest backup"

  # Arrange
  VERIFY_CHECKSUMS=false
  touch "$BACKUP_PATH/backup-test-20210101155701.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155702.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155703.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155704.tgz"

  # Act
  run_store

  # Assert
  backup="$(get_latest_backup test)"
  assert_equals "backup-test-20210101155704.tgz" "$backup"
}

test__run_store__should_only_copy_the_latest_backup() {
  test_begin "Store should only copy the latest backup"

  # Arrange
  VERIFY_CHECKSUMS=false
  touch "$BACKUP_PATH/backup-test-20210101155701.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155702.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155703.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155704.tgz"

  # Act
  run_store

  # Assert
  backup_count="$(get_file_count "$LTS_PATH/test")"
  assert_equals "1" "$backup_count"
}

test__run_store__should_copy_latest_backups_of_two_volumes() {
  test_begin "Store should only copy the latest backup"

  # Arrange
  VERIFY_CHECKSUMS=false
  touch "$BACKUP_PATH/backup-test-20210101155701.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155702.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155703.tgz"
  touch "$BACKUP_PATH/backup-xxx-20210101155700.tgz"
  touch "$BACKUP_PATH/backup-xxx-20210101155701.tgz"
  touch "$BACKUP_PATH/backup-xxx-20210101155702.tgz"
  prepare xxx

  # Act
  run_store

  # Assert
  backup="$(get_latest_backup xxx)"
  assert_equals "backup-xxx-20210101155702.tgz" "$backup"
}

test__run_store__should_copy_latest_backups_of_two_volumes_with_existing_lts_backups() {
  test_begin "Store should only copy the latest backup"

  # Arrange
  VERIFY_CHECKSUMS=false
  touch "$BACKUP_PATH/backup-test-20210101155701.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155702.tgz"
  touch "$BACKUP_PATH/backup-test-20210101155703.tgz"
  touch "$BACKUP_PATH/backup-xxx-20210101155700.tgz"
  touch "$BACKUP_PATH/backup-xxx-20210101155701.tgz"
  touch "$BACKUP_PATH/backup-xxx-20210101155702.tgz"
  touch "$LTS_PATH/backup-xxx-20210101155700.tgz"
  prepare xxx

  # Act
  run_store

  # Assert
  backup="$(get_latest_backup xxx)"
  assert_equals "backup-xxx-20210101155702.tgz" "$backup"
}
