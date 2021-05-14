#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__create_checksum__creates_checksum_if_create_checksums_is_true() {
  test_begin "create_checksum creates checksum if CREATE_CHECKSUMS is true"

  # Arrange
  CREATE_CHECKSUMS="$TRUE"
  /bin/echo "test" > ./test.7z

  # Act
  create_checksum ./test.7z

  # Assert
  assert_file_exists "./test.7z.sfv"
}

test__create_checksum__does_not_call_cksfv_if_create_checksums_is_false() {
  test_begin "create_checksum does not call cksfv if CREATE_CHECKSUMS is false"

  # Arrange
  CREATE_CHECKSUMS="$FALSE"
  /bin/echo "test" > ./test.7z
  set_result "$FALSE"
  cksfv() { set_result "$TRUE"; }

  # Act
  create_checksum ./test.7z

  # Assert
  assert_false "$(get_result)"
}

test__create_checksum__calls_error_if_file_does_not_exist() {
  test_begin "create_checksum calls error if file does not exist"

  # Arrange
  CREATE_CHECKSUMS="$TRUE"
  set_result "$FALSE"
  cksfv() { set_result "$TRUE"; }

  # Act
  /bin/rm -f ./non_existant_file.7z
  create_checksum ./non_existant_file.7z

  # Assert
  assert_false "$(get_result)"
}
