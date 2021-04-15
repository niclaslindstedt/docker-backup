#!/bin/bash

# shellcheck disable=SC1090

source "$APP_PATH/common.sh"

testspec__one_hour__is_one_hour_in_seconds() {
  test_begin "ONE_HOUR is one hour in seconds"

  # Assert
  assert_equals "3600" "$ONE_HOUR"
}

testspec__one_day__is_one_day_in_seconds() {
  test_begin "ONE_DAY is one day in seconds"

  # Assert
  assert_equals "86400" "$ONE_DAY"
}

testspec__one_week__is_one_week_in_seconds() {
  test_begin "ONE_WEEK is one week in seconds"

  # Assert
  assert_equals "604800" "$ONE_WEEK"
}

testspec__one_month__is_one_month_in_seconds() {
  test_begin "ONE_MONTH is one month in seconds"

  # Assert
  assert_equals "2419200" "$ONE_MONTH"
}
