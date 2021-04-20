#!/bin/bash

# shellcheck disable=SC1091

source "$APP_PATH/common.sh"

test__is_archive__returns_true_for_backup_tgz() {
  test_begin "is_archive returns true for backup ending with .tgz"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-1-20210410174014.tgz" && result=true

  # Assert
  assert_true "$result"
}

test__is_archive__returns_true_for_backup_zip() {
  test_begin "is_archive returns true for backup ending with .zip"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-2-20210410174014.zip" && result=true

  # Assert
  assert_true "$result"
}

test__is_archive__returns_true_for_backup_rar() {
  test_begin "is_archive returns true for backup ending with .rar"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-3-20210410174014.rar" && result=true

  # Assert
  assert_true "$result"
}

test__is_archive__returns_true_for_backup_7z() {
  test_begin "is_archive returns true for backup ending with .7z"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-4-20210410174014.7z" && result=true

  # Assert
  assert_true "$result"
}

test__is_archive__returns_false_if_file_does_not_start_with_backup() {
  test_begin "is_archive returns false if file does not start with backup"

  # Arrange
  result=false

  # Act
  is_archive "bakcup-sample-app-5-20210410174014.7z" && result=true

  # Assert
  assert_false "$result"
}

test__is_archive__returns_false_if_date_is_too_short() {
  test_begin "is_archive returns false if date is too short"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-5-202104101740.7z" && result=true

  # Assert
  assert_false "$result"
}
