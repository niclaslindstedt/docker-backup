#!/bin/bash

COMPONENT="TEST"
TEST_VOLUME=$VOLUME_PATH/test
TEST_SUCCESS="true"

main() {
  test_backup_remove_restore
  test_backup_remove_restore_encrypted
  test_restore_encrypted_with_bad_password
}

test_backup_remove_restore() {
  test_begin "Backup, remove and then restore file"

  # Arrange
  local file_to_restore="$TEST_VOLUME/test_file_2"
  assert_file_exists "$file_to_restore"

  # Act
  backup
  rm -f $file_to_restore
  assert_file_does_not_exist "$file_to_restore"
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

  # Act
  backup
  local latest_backup="$(get_latest_backup test)"
  rm -f $file_to_restore
  assert_file_does_not_exist "$file_to_restore"
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

  # Act
  backup
  local latest_backup="$(get_latest_backup test)"
  rm -f $file_to_restore
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"
  ENCRYPTION_PASSWORD=badpassword
  restore "$latest_backup"

  # Assert
  assert_file_does_not_exist "$file_to_restore"
}

assert_file_exists() {
  [ ! -f "$1" ] && assert_fail "Expected file to exist. It does not exist: $1"
  assert_success "File exists: $1"
}

assert_file_does_not_exist() {
  [ -f "$1" ] && assert_fail "Expected file to not exist. It exists: $1"
  assert_success "File does not exist: $1"
}

assert_file_ends_with() {
  [ ! -f "$1" ] || assert_fail "Expected file to end with '$2'. It does not exist: $1"
  if [[ "$1" =~ "$2"$ ]]; then
    assert_success "File ends with '$2': $1"
  else
    assert_fail "Expected file to end with '$2'. It does not: $1"
  fi
}

test_begin() {
  reset_tests
  log "${YELLOW}*** TEST: $* ***${EC}"
}

assert_success() {
  log "${GREEN}Assertion successful!${EC} $*"
}

assert_fail() {
  TEST_SUCCESS="false"
  error "${RED}Assertion failed.${EC} $*"
}

prepare() {
  mkdir -p $BACKUP_PATH $LTS_PATH $TEST_VOLUME
  echo "this" >> $TEST_VOLUME/test_file_1
  echo "is a way" >> $TEST_VOLUME/test_file_2
  echo "to test" >> $TEST_VOLUME/test_file_3
  echo "that backup" >> $TEST_VOLUME/test_file_4
  echo "actually works" >> $TEST_VOLUME/test_file_5
}

reset_tests() {
  log "Cleaning up."
  rm -rf $BACKUP_PATH $LTS_PATH $TEST_VOLUME
  prepare
}

source "$APP_PATH/common.sh"

main "$1"

[ "$TEST_SUCCESS" != "true" ] && exit 1

exit 0