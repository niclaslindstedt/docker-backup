#!/bin/bash

# shellcheck disable=SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__error__starts_containers_if_pause_containers_is_set() {
  test_begin "error starts Docker containers if PAUSE_CONTAINERS is set"

  # Arrange
  PAUSE_CONTAINERS="container1, container2"
  set_result "false"
  unpause_containers() { set_result "true"; }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}

test__error__does_not_unpause_containers_if_pause_containers_is_null() {
  test_begin "error does not start containers if PAUSE_CONTAINERS is null"

  # Arrange
  PAUSE_CONTAINERS=""
  set_result "false"
  unpause_containers() { set_result "true"; }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_false "$(get_result)"
}

test__error__logs_error_if_parameter_is_used() {
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

test__error__does_not_log_error_with_no_parameters() {
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

test__error__exits_with_exit_code_1() {
  test_begin "error exits with exit code 1"

  # Arrange
  set_result "false"
  exit() { [ "$1" = "1" ] && set_result "true"; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}
