#!/bin/bash

# shellcheck disable=SC1090,SC1091

for f in "$APP_PATH"/common/*; do . "$f"; done

test__get_latest_prerestore_backup__outputs_the_latest_prerestore_backup_in_backup_folder() {
  test_begin "get_latest_prerestore_backup outputs the latest pre-restore backup in /backup"

  # Arrange
  touch /backup/prerestore+backup-test-backup-20210101155701.tgz+20210101155705.tgz
  touch /backup/prerestore+backup-test-backup-20210101155702.tgz+20210101155702.tgz
  touch /backup/prerestore+backup-test-backup-20210101155704.tgz+20210101155709.tgz
  touch /backup/prerestore+backup-test-backup-20210101155703.tgz+20210101155701.tgz

  # Act
  result="$(get_latest_prerestore_backup)"

  # Assert
  assert_equals "prerestore+backup-test-backup-20210101155704.tgz+20210101155709.tgz" "$result"
}
