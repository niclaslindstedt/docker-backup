#!/bin/bash

COMPONENT="TEST"
TEST_VOLUME=$VOLUME_PATH/test
TEST_SUCCESS="true" # This will be set to false by assert_fail

main() {
  # List of tests to run
  test_backup_remove_restore
  test_backup_remove_restore_encrypted
  test_restore_encrypted_with_bad_password
}

test_backup_remove_restore() {
  test_begin "Backup, remove and then restore file"

  # Arrange
  local file_to_restore="$TEST_VOLUME/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  rm -f $file_to_restore
  assert_file_does_not_exist "$file_to_restore"

  # Act
  restore "$(get_latest_backup test)"

  # Assert
  assert_file_exists "$file_to_restore"
}

test_backup_remove_restore_encrypted() {
  test_begin "Backup, remove and then restore file (with encryption)"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  local file_to_restore="$TEST_VOLUME/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  local latest_backup="$(get_latest_backup test)"
  rm -f $file_to_restore
  assert_file_does_not_exist "$file_to_restore"

  # Act
  restore "$latest_backup"

  # Assert
  assert_file_ends_with "$latest_backup" ".enc"
  assert_file_exists "$file_to_restore"
}

test_restore_encrypted_with_bad_password() {
  test_begin "Restore encrypted backup with bad password"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  local file_to_restore="$TEST_VOLUME/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  local latest_backup="$(get_latest_backup test)"
  rm -f $file_to_restore
  assert_file_does_not_exist "$file_to_restore"

  # Act
  ENCRYPTION_PASSWORD=badpassword
  restore "$latest_backup"

  # Assert
  assert_file_ends_with "$latest_backup" ".enc"
  assert_file_does_not_exist "$file_to_restore"
}


# Run tests
source "$APP_PATH/common.sh"
source "$APP_PATH/assertions.sh"
source "$APP_PATH/test_helpers.sh"

main "$1"

[ "$TEST_SUCCESS" != "true" ] && exit 1

exit 0
