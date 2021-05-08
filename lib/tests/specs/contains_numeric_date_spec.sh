#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__contains_numeric_date__returns_true_if_valid_date() {
  test_begin "contains_numeric_date returns true if valid date"

  # Arrange
  backup_filename="backup-test-backup-20140517223559.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_true "$result"
}

test__contains_numeric_date__returns_true_if_valid_date_2() {
  test_begin "parse_time returns true if valid date (2)"

  # Arrange
  backup_filename="backup-test-backup-20210110120000.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_true "$result"
}

test__contains_numeric_date__returns_false_if_too_short_date() {
  test_begin "contains_numeric_date returns false if bad date"

  # Arrange
  backup_filename="backup-test-backup-201405172235.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

test__contains_numeric_date__returns_false_if_old_year() {
  test_begin "contains_numeric_date returns false if old year"

  # Arrange
  backup_filename="backup-test-backup-19690522143556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

test__contains_numeric_date__returns_false_if_bad_month() {
  test_begin "contains_numeric_date returns false if bad month"

  # Arrange
  backup_filename="backup-test-backup-19891322143556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

test__contains_numeric_date__returns_false_if_bad_day() {
  test_begin "contains_numeric_date returns false if bad day"

  # Arrange
  backup_filename="backup-test-backup-19891132143556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

test__contains_numeric_date__returns_false_if_bad_hour() {
  test_begin "contains_numeric_date returns false if bad hour"

  # Arrange
  backup_filename="backup-test-backup-19891131243556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

test__contains_numeric_date__returns_false_if_bad_minute() {
  test_begin "contains_numeric_date returns false if bad minute"

  # Arrange
  backup_filename="backup-test-backup-19891131236056.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

test__contains_numeric_date__returns_false_if_bad_second() {
  test_begin "contains_numeric_date returns false if bad second"

  # Arrange
  backup_filename="backup-test-backup-19891131235960.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}
