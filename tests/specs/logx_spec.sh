#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__log1__calls_echo_if_log_level_1() {
  test_begin "log1 calls echo if LOG_LEVEL is 1"

  # Arrange
  LOG_LEVEL=1
  test_message="xx log1 xx"
  echo() { set_result "$*"; }

  # Act
  log1 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log1__does_not_call_echo_if_log_level_0() {
  test_begin "log1 does not call echo if LOG_LEVEL is 0"

  # Arrange
  LOG_LEVEL=0
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  log1 "test"

  # Assert
  assert_equals "$(get_result)" "null"
}

test__log2__calls_echo_if_log_level_3() {
  test_begin "log2 calls echo if LOG_LEVEL is 3"

  # Arrange
  LOG_LEVEL=3
  test_message="xx log2 xx"
  echo() { set_result "$*"; }

  # Act
  log2 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log2__calls_echo_if_log_level_2() {
  test_begin "log2 calls echo if LOG_LEVEL is 2"

  # Arrange
  LOG_LEVEL=2
  test_message="xx log2 xx"
  echo() { set_result "$*"; }

  # Act
  log2 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log2__does_not_call_echo_if_log_level_1() {
  test_begin "log2 does not call echo if LOG_LEVEL is 1"

  # Arrange
  LOG_LEVEL=1
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  log2 "test"

  # Assert
  assert_equals "$(get_result)" "null"
}

test__log3__calls_echo_if_log_level_4() {
  test_begin "log3 calls echo if LOG_LEVEL is 4"

  # Arrange
  LOG_LEVEL=4
  test_message="xx log3 xx"
  echo() { set_result "$*"; }

  # Act
  log3 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log3__calls_echo_if_log_level_3() {
  test_begin "log3 calls echo if LOG_LEVEL is 3"

  # Arrange
  LOG_LEVEL=3
  test_message="xx log3 xx"
  echo() { set_result "$*"; }

  # Act
  log3 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log3__does_not_call_echo_if_log_level_2() {
  test_begin "log3 does not call echo if LOG_LEVEL is 2"

  # Arrange
  LOG_LEVEL=2
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  log3 "test"

  # Assert
  assert_equals "$(get_result)" "null"
}

test__log4__calls_echo_if_log_level_5() {
  test_begin "log4 calls echo if LOG_LEVEL is 5"

  # Arrange
  LOG_LEVEL=5
  test_message="xx log4 xx"
  echo() { set_result "$*"; }

  # Act
  log4 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log4__calls_echo_if_log_level_4() {
  test_begin "log4 calls echo if LOG_LEVEL is 4"

  # Arrange
  LOG_LEVEL=4
  test_message="xx log4 xx"
  echo() { set_result "$*"; }

  # Act
  log4 "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__log4__does_not_call_echo_if_log_level_3() {
  test_begin "log4 does not call echo if LOG_LEVEL is 3"

  # Arrange
  LOG_LEVEL=3
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  log4 "test"

  # Assert
  assert_equals "$(get_result)" "null"
}


test__logd__calls_echo_if_log_level_5() {
  test_begin "logd calls echo if LOG_LEVEL is 5"

  # Arrange
  LOG_LEVEL=5
  test_message="xx logd xx"
  echo() { set_result "$*"; }

  # Act
  logd "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

test__logd__does_not_call_echo_if_log_level_4() {
  test_begin "logd does not call echo if LOG_LEVEL is 4"

  # Arrange
  LOG_LEVEL=4
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logd "test"

  # Assert
  assert_equals "$(get_result)" "null"
}
