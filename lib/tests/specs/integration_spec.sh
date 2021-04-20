#!/bin/bash

# shellcheck disable=SC1091,SC2034

source "$APP_PATH/common.sh"

test__backup_remove_restore() {
  local file_to_restore

  test_begin "Create a backup of a volume, remove a file from the volume and then restore the backup"

  # Arrange
  file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"

  # Act
  restore "$(get_latest_backup test)"

  # Assert
  assert_file_exists "$file_to_restore"
}

test__backup_remove_restore_encrypted() {
  local file_to_restore latest_backup

  test_begin "Create an encrypted backup of a volume, remove a file from the volume and then restore the encrypted backup"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  latest_backup="$(get_latest_backup test)"
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"

  # Act
  restore "$latest_backup"

  # Assert
  assert_file_exists "$file_to_restore"
}

test__restore_encrypted_with_bad_password() {
  local file_to_restore latest_backup

  test_begin "Try to restore an encrypted backup with a bad password"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  latest_backup="$(get_latest_backup test)"
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"

  # Act
  ENCRYPTION_PASSWORD=badpassword
  restore "$latest_backup"

  # Assert
  assert_file_does_not_exist "$file_to_restore"
}
