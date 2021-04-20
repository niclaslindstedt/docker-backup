#!/bin/bash

# shellcheck disable=SC1091,SC2034

source "$APP_PATH/common.sh"

test__create_checksum__calls_cksfv_if_create_checksums_is_true() {
  test_begin "create_checksum calls cksfv if CREATE_CHECKSUMS is true"

  # Arrange
  CREATE_CHECKSUMS="true"
  /bin/echo "test" > ./test.7z
  set_result "false"
  cksfv() { set_result "true"; }

  # Act
  create_checksum ./test.7z

  # Assert
  assert_true "$(get_result)"
}

test__create_checksum__does_not_call_cksfv_if_create_checksums_is_false() {
  test_begin "create_checksum does not call cksfv if CREATE_CHECKSUMS is false"

  # Arrange
  CREATE_CHECKSUMS="false"
  /bin/echo "test" > ./test.7z
  set_result "false"
  cksfv() { set_result "true"; }

  # Act
  create_checksum ./test.7z

  # Assert
  assert_false "$(get_result)"
}

test__create_checksum__calls_error_if_file_does_not_exist() {
  test_begin "create_checksum calls error if file does not exist"

  # Arrange
  CREATE_CHECKSUMS="true"
  set_result "false"
  cksfv() { set_result "true"; }

  # Act
  rm -f ./non_existant_file.7z
  create_checksum ./non_existant_file.7z

  # Assert
  assert_false "$(get_result)"
}
