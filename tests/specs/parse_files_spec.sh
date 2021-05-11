#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__parse_time__outputs_correct_unixtime() {
  test_begin "parse_time outputs correct unixtime"

  # Arrange
  backup_filename="backup-test-backup-20140517223556.tgz"
  expected_unixtime=$(date --date "2014-05-17 22:35:56" +"%s")

  # Act
  result="$(parse_time "$backup_filename")"

  # Assert
  assert_equals "$expected_unixtime" "$result"
}

test__parse_time__outputs_0_if_bad_date() {
  test_begin "parse_time outputs 0 if bad date"

  # Arrange
  backup_filename="backup-test-backup-18000517223556.tgz"

  # Act
  result="$(parse_time "$backup_filename")"

  # Assert
  assert_equals "0" "$result"
}
