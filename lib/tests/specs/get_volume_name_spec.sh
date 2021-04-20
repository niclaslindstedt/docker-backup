#!/bin/bash

# shellcheck disable=SC1091

source "$APP_PATH/common.sh"

test__get_volume_name__returns_only_volume_name_from_archive_filename() {
  test_begin "get_volume_name returns only volume name from archive filename"

  # Arrange
  result="not_correct"

  # Act
  result="$(get_volume_name "backup-sample-app-5-20210410174014.7z")"

  # Assert
  assert_equals "sample-app-5" "$result"
}

test__get_volume_name__returns_volume_name_with_underscore() {
  test_begin "get_volume_name returns volume name with underscores"

  # Arrange
  result="not_correct"

  # Act
  result="$(get_volume_name "backup-sample_app_2-20210410174014.7z")"

  # Assert
  assert_equals "sample_app_2" "$result"
}
