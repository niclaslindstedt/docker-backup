#!/bin/bash

testspec_log_calls_echo() {
  test_begin "Log calls echo"

  # Arrange
  test_message="xx log xx"
  echo() { set_result "$*"; }

  # Act
  log "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec_loga_calls_echo() {
  test_begin "Loga calls echo"

  # Arrange
  test_message="xx loga xx"
  echo() { set_result "$*"; }

  # Act
  loga "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec_logv_calls_echo_if_verbose() {
  test_begin "Logv calls echo if VERBOSE is true"

  # Arrange
  VERBOSE=true
  test_message="xx logv xx"
  echo() { set_result "$*"; }

  # Act
  logv "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec_logv_does_not_call_echo_if_not_verbose() {
  test_begin "Logv does not call echo if VERBOSE is false"

  # Arrange
  VERBOSE=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logv "test"

  # Assert
  assert_equals "null" "$(get_result)"
}

testspec_logd_calls_echo_if_debug() {
  test_begin "Logd calls echo if DEBUG is true"

  # Arrange
  DEBUG=true
  test_message="xx logd xx"
  echo() { set_result "$*"; }

  # Act
  logd "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec_logd_does_not_call_echo_if_not_debug() {
  test_begin "Logd does not call echo if DEBUG is false"

  # Arrange
  DEBUG=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logd "test"

  # Assert
  assert_equals "null" "$(get_result)"
}

testspec_error_starts_containers_if_stop_containers_is_set() {
  test_begin "Error starts Docker containers if STOP_CONTAINERS is set"

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

testspec_error_does_not_start_containers_if_stop_containers_is_null() {
  test_begin "Error does not start containers if STOP_CONTAINERS is null"

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

testspec_error_logs_error_if_parameter_is_used() {
  test_begin "Error logs ERROR: if parameter is used"

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

testspec_error_does_not_log_error_with_no_parameters() {
  test_begin "Error does not log ERROR: with no parameters"

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

testspec_error_exits_with_exit_code_1() {
  test_begin "Error exits with exit code 1"

  # Arrange
  set_result "false"
  exit() { [ "$1" = "1" ] && set_result "true"; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}

testspec_backup_two_volumes_creates_two_backups() {
  test_begin "Backup two volumes and get two backups"

  # Act
  prepare second-test
  backup

  # Assert
  local backup_count="$(get_backup_count)"
  assert_equals "2" "$backup_count"
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
