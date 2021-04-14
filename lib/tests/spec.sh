#!/bin/bash

# common/log

testspec__log__calls_echo() {
  test_begin "log calls echo"

  # Arrange
  test_message="xx log xx"
  echo() { set_result "$*"; }

  # Act
  log "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}


# common/loga

testspec__loga__calls_echo() {
  test_begin "loga calls echo"

  # Arrange
  test_message="xx loga xx"
  echo() { set_result "$*"; }

  # Act
  loga "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}


# common/logv

testspec__logv__calls_echo_if_verbose() {
  test_begin "logv calls echo if VERBOSE is true"

  # Arrange
  VERBOSE=true
  test_message="xx logv xx"
  echo() { set_result "$*"; }

  # Act
  logv "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec__logv__does_not_call_echo_if_not_verbose() {
  test_begin "logv does not call echo if VERBOSE is false"

  # Arrange
  VERBOSE=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logv "test"

  # Assert
  assert_equals "null" "$(get_result)"
}


# common/logd

testspec__logd__calls_echo_if_debug() {
  test_begin "logd calls echo if DEBUG is true"

  # Arrange
  DEBUG=true
  test_message="xx logd xx"
  echo() { set_result "$*"; }

  # Act
  logd "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec__logd__does_not_call_echo_if_not_debug() {
  test_begin "logd does not call echo if DEBUG is false"

  # Arrange
  DEBUG=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logd "test"

  # Assert
  assert_equals "null" "$(get_result)"
}


# common/error

testspec__error__starts_containers_if_stop_containers_is_set() {
  test_begin "error starts Docker containers if STOP_CONTAINERS is set"

  # Arrange
  STOP_CONTAINERS="container1, container2"
  set_result "false"
  start_containers() { set_result "true"; }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}

testspec__error__does_not_start_containers_if_stop_containers_is_null() {
  test_begin "error does not start containers if STOP_CONTAINERS is null"

  # Arrange
  STOP_CONTAINERS=""
  set_result "false"
  start_containers() { set_result "true"; }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_false "$(get_result)"
}

testspec__error__logs_error_if_parameter_is_used() {
  test_begin "error logs ERROR: if parameter is used"

  # Arrange
  set_result "false"
  log() {
    [[ "$1" =~ ^ERROR: ]] && set_result "true"
  }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}

testspec__error__does_not_log_error_with_no_parameters() {
  test_begin "error does not log ERROR: with no parameters"

  # Arrange
  set_result "false"
  log() {
    [[ "$1" =~ ^ERROR: ]] && set_result "true"
  }
  exit() { noop; }

  # Act
  error

  # Assert
  assert_false "$(get_result)"
}

testspec__error__exits_with_exit_code_1() {
  test_begin "error exits with exit code 1"

  # Arrange
  set_result "false"
  exit() { [ "$1" = "1" ] && set_result "true"; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}


# common/is_not_empty

testspec__is_not_empty__returns_false_if_empty() {
  test_begin "is_not_empty returns false if directory is empty"

  # Arrange
  mkdir -p "$TEST_PATH/empty_folder"
  result=false

  # Act
  is_not_empty "$TEST_PATH/empty_folder" && result=true

  # Assert
  assert_false "$result"
}

testspec__is_not_empty__returns_true_if_not_empty() {
  test_begin "is_not_empty returns true if directory is not empty"

  # Arrange
  mkdir -p "$TEST_PATH/non_empty_folder"
  /bin/echo "Test" > "$TEST_PATH/non_empty_folder/test_file"
  result=false

  # Act
  is_not_empty "$TEST_PATH/non_empty_folder" && result=true

  # Assert
  assert_true "$result"
}


# common/get_volume_name

testspec__is_archive__returns_true_for_backup_tgz() {
  test_begin "is_archive returns true for backup ending with .tgz"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-1-20210410174014.tgz" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_true_for_backup_zip() {
  test_begin "is_archive returns true for backup ending with .zip"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-2-20210410174014.zip" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_true_for_backup_rar() {
  test_begin "is_archive returns true for backup ending with .rar"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-3-20210410174014.rar" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_true_for_backup_7z() {
  test_begin "is_archive returns true for backup ending with .7z"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-4-20210410174014.7z" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_false_if_file_does_not_start_with_backup() {
  test_begin "is_archive returns false if file does not start with backup"

  # Arrange
  result=false

  # Act
  is_archive "bakcup-sample-app-5-20210410174014.7z" && result=true

  # Assert
  assert_false "$result"
}

testspec__is_archive__returns_false_if_date_is_too_short() {
  test_begin "is_archive returns false if date is too short"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-5-202104101740.7z" && result=true

  # Assert
  assert_false "$result"
}


# Integration tests

testspec__backup_two_volumes_creates_two_backups() {
  local backup_count

  test_begin "Backup two volumes and get two backups"

  # Act
  prepare second-test
  backup

  # Assert
  backup_count="$(get_backup_count)"
  assert_equals "2" "$backup_count"
}

testspec__backup_volume_with_correct_name() {
  local backup_count

  test_begin "Backup a volume with the correct backup filename"

  # Act
  backup

  # Assert
  backup_name="$(get_latest_backup test)"
  assert_file_starts_with "$backup_name" "backup-test-"
}

testspec__backup_remove_restore() {
  local file_to_restore

  test_begin "Backup, remove and then restore file"

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

testspec__backup_remove_restore_encrypted() {
  local file_to_restore latest_backup

  test_begin "Backup, remove and then restore file (with encryption)"

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

testspec__restore_encrypted_with_bad_password() {
  local file_to_restore latest_backup

  test_begin "Restore encrypted backup with bad password"

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
