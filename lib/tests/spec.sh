#!/bin/bash

testspec_backup_two_volumes_creates_two_backups() {
  test_begin "Backup two volumes and get two backups"

  # Act
  prepare second-test
  backup

  # Assert
  local backup_count="$(get_backup_count)"
  assert_equals "$backup_count" "2"
}

testspec_backup_volume_with_correct_name() {
  test_begin "Backup a volume with the correct backup filename"

  # Act
  backup

  # Assert
  local backup_name="$(get_latest_backup test)"
  assert_file_starts_with "$backup_name" "backup-test-"
}

testspec_backup_remove_restore() {
  test_begin "Backup, remove and then restore file"

  # Arrange
  local file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"

  # Act
  restore "$(get_latest_backup test)"

  # Assert
  assert_file_exists "$file_to_restore"
}

testspec_backup_remove_restore_encrypted() {
  test_begin "Backup, remove and then restore file (with encryption)"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  local file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  local latest_backup="$(get_latest_backup test)"
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"

  # Act
  restore "$latest_backup"

  # Assert
  assert_file_exists "$file_to_restore"
}

testspec_restore_encrypted_with_bad_password() {
  test_begin "Restore encrypted backup with bad password"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  local file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  local latest_backup="$(get_latest_backup test)"
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"

  # Act
  ENCRYPTION_PASSWORD=badpassword
  restore "$latest_backup"

  # Assert
  assert_file_does_not_exist "$file_to_restore"
}
