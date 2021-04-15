#!/bin/bash

# shellcheck disable=SC1090,SC2034

source "$APP_PATH/common.sh"

test__create_checksum__calls_cksfv_if_create_checksums_is_true() {
  test_begin "create_checksum calls cksfv if CREATE_CHECKSUMS is true"

  # Arrange
  CREATE_CHECKSUMS=true
  /bin/echo "test" > ./test.7z
  result="false"
  cksfv() { result="true"; }

  # Act
  create_checksum ./test.7z

  # Assert
  assert_true "$result"
}

test__create_checksum__calls_error_if_file_does_not_exist() {
  test_begin "create_checksum calls error if file does not exist"

  # Arrange
  CREATE_CHECKSUMS=true
  result="false"
  cksfv() { result="true"; }

  # Act
  rm -f ./non_existant_file.7z
  create_checksum ./non_existant_file.7z

  # Assert
  assert_false "$result"
}
