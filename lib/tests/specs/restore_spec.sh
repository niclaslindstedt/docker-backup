#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034,SC2012

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/restore/*; do . "$f"; done

test__run_restore__restores_a_backup() {
  test_begin "Restore restores a backup"

  # Arrange
  ASSUME_YES=true
  vol_folder="$VOLUME_PATH/restore-test"
  rm -rf "$vol_folder"
  mkdir -p "$vol_folder"
  /bin/echo "abc123" > "$vol_folder/one_file"
  cd "$vol_folder" || exit 1
  tar czf "$BACKUP_PATH/backup-restore-test-20210101155701.tgz" .
  rm "$vol_folder/one_file"
  cd - >/dev/null || exit 1
  assert_file_does_not_exist "$vol_folder/one_file"

  # Act
  run_restore restore-test

  # Assert
  assert_equals "abc123" "$(cat "$vol_folder/one_file")"
}

test__run_restore__removes_content_before_restoring_a_backup() {
  test_begin "Restore removes content before restoring a backup"

  # Arrange
  ASSUME_YES=true
  vol_folder="$VOLUME_PATH/restore-test"
  rm -rf "$vol_folder"
  mkdir -p "$vol_folder"
  /bin/echo "abc123" > "$vol_folder/one_file"
  cd "$vol_folder" || exit 1
  tar czf "$BACKUP_PATH/backup-restore-test-20210101155701.tgz" .
  /bin/echo "xyz987" > "$vol_folder/one_file"
  /bin/echo "asd555" > "$vol_folder/two_file" # this file should be removed
  cd - >/dev/null || exit 1

  # Act
  run_restore restore-test

  # Assert
  assert_equals "1" "$(get_file_count "$vol_folder")"
}
