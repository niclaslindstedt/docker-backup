#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

for f in "$APP_PATH"/common/*; do . "$f"; done

test__verify_checksum__calls_cksfv_if_verify_checksums_is_true() {
  test_begin "verify_checksum calls cksfv if VERIFY_CHECKSUMS is true"

  # Arrange
  VERIFY_CHECKSUMS="true"
  /bin/echo "test" | tee ./test.7z ./test.7z.sfv >/dev/null
  set_result "false"
  cksfv() { set_result "true"; }

  # Act
  verify_checksum ./test.7z

  # Assert
  assert_true "$(get_result)"
}

test__verify_checksum__does_not_call_cksfv_if_verify_checksums_is_false() {
  test_begin "verify_checksum does not call cksfv if VERIFY_CHECKSUMS is false"

  # Arrange
  VERIFY_CHECKSUMS="false"
  /bin/echo "test" | tee ./test.7z ./test.7z.sfv >/dev/null
  set_result "false"
  cksfv() { set_result "true"; }

  # Act
  verify_checksum ./test.7z

  # Assert
  assert_false "$(get_result)"
}

test__create_checksum__calls_error_if_file_does_not_exist() {
  test_begin "create_checksum calls error if file does not exist"

  # Arrange
  VERIFY_CHECKSUMS="true"
  set_result "false"
  cksfv() { set_result "true"; }

  # Act
  /bin/rm -f ./non_existant_file.7z.sfv
  verify_checksum ./non_existant_file.7z

  # Assert
  assert_false "$(get_result)"
}
