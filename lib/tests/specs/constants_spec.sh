#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__one_hour__is_one_hour_in_seconds() {
  test_begin "ONE_HOUR is one hour in seconds"

  # Assert
  assert_equals "3600" "$ONE_HOUR"
}

test__one_day__is_one_day_in_seconds() {
  test_begin "ONE_DAY is one day in seconds"

  # Assert
  assert_equals "86400" "$ONE_DAY"
}

test__one_week__is_one_week_in_seconds() {
  test_begin "ONE_WEEK is one week in seconds"

  # Assert
  assert_equals "604800" "$ONE_WEEK"
}

test__one_month__is_one_month_in_seconds() {
  test_begin "ONE_MONTH is one month in seconds"

  # Assert
  assert_equals "2628002" "$ONE_MONTH" # 30,4167 days
}
