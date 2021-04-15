#!/bin/bash

testspec__backup__two_volumes_creates_two_backups() {
  local backup_count

  test_begin "Backup two volumes and get two backups"

  # Act
  prepare second-test
  backup

  # Assert
  backup_count="$(get_backup_count)"
  assert_equals "2" "$backup_count"
}

testspec__backup__volume_with_correct_name() {
  local backup_count

  test_begin "Backup a volume with the correct backup filename"

  # Act
  backup

  # Assert
  backup_name="$(get_latest_backup test)"
  assert_file_starts_with "$backup_name" "backup-test-"
}
