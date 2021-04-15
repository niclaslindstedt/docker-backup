#!/bin/bash

# shellcheck disable=SC2034

# common/log

testspec__log__calls_echo() {
  test_begin "log calls echo"

  # Arrange
  test_message="xx log xx"
  echo() { set_result "$*"; }

  # Act
  log "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}


# common/loga

testspec__loga__calls_echo() {
  test_begin "loga calls echo"

  # Arrange
  test_message="xx loga xx"
  echo() { set_result "$*"; }

  # Act
  loga "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}


# common/logv

testspec__logv__calls_echo_if_verbose() {
  test_begin "logv calls echo if VERBOSE is true"

  # Arrange
  VERBOSE=true
  test_message="xx logv xx"
  echo() { set_result "$*"; }

  # Act
  logv "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec__logv__does_not_call_echo_if_not_verbose() {
  test_begin "logv does not call echo if VERBOSE is false"

  # Arrange
  VERBOSE=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logv "test"

  # Assert
  assert_equals "null" "$(get_result)"
}


# common/logd

testspec__logd__calls_echo_if_debug() {
  test_begin "logd calls echo if DEBUG is true"

  # Arrange
  DEBUG=true
  test_message="xx logd xx"
  echo() { set_result "$*"; }

  # Act
  logd "$test_message"

  # Assert
  assert_string_ends_with "$(get_result)" "$test_message"
}

testspec__logd__does_not_call_echo_if_not_debug() {
  test_begin "logd does not call echo if DEBUG is false"

  # Arrange
  DEBUG=false
  set_result "null"
  echo() { set_result "$*"; }

  # Act
  logd "test"

  # Assert
  assert_equals "null" "$(get_result)"
}


# common/error

testspec__error__starts_containers_if_stop_containers_is_set() {
  test_begin "error starts Docker containers if STOP_CONTAINERS is set"

  # Arrange
  STOP_CONTAINERS="container1, container2"
  set_result "false"
  start_containers() { set_result "true"; }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}

testspec__error__does_not_start_containers_if_stop_containers_is_null() {
  test_begin "error does not start containers if STOP_CONTAINERS is null"

  # Arrange
  STOP_CONTAINERS=""
  set_result "false"
  start_containers() { set_result "true"; }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_false "$(get_result)"
}

testspec__error__logs_error_if_parameter_is_used() {
  test_begin "error logs ERROR: if parameter is used"

  # Arrange
  set_result "false"
  log() {
    [[ "$1" =~ ^ERROR: ]] && set_result "true"
  }
  exit() { noop; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}

testspec__error__does_not_log_error_with_no_parameters() {
  test_begin "error does not log ERROR: with no parameters"

  # Arrange
  set_result "false"
  log() {
    [[ "$1" =~ ^ERROR: ]] && set_result "true"
  }
  exit() { noop; }

  # Act
  error

  # Assert
  assert_false "$(get_result)"
}

testspec__error__exits_with_exit_code_1() {
  test_begin "error exits with exit code 1"

  # Arrange
  set_result "false"
  exit() { [ "$1" = "1" ] && set_result "true"; }

  # Act
  error "Something went wrong"

  # Assert
  assert_true "$(get_result)"
}


# common/is_not_empty

testspec__is_not_empty__returns_false_if_empty() {
  test_begin "is_not_empty returns false if directory is empty"

  # Arrange
  mkdir -p "$TEST_PATH/empty_folder"
  result=false

  # Act
  is_not_empty "$TEST_PATH/empty_folder" && result=true

  # Assert
  assert_false "$result"
}

testspec__is_not_empty__returns_true_if_not_empty() {
  test_begin "is_not_empty returns true if directory is not empty"

  # Arrange
  mkdir -p "$TEST_PATH/non_empty_folder"
  /bin/echo "Test" > "$TEST_PATH/non_empty_folder/test_file"
  result=false

  # Act
  is_not_empty "$TEST_PATH/non_empty_folder" && result=true

  # Assert
  assert_true "$result"
}


# common/is_archive

testspec__is_archive__returns_true_for_backup_tgz() {
  test_begin "is_archive returns true for backup ending with .tgz"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-1-20210410174014.tgz" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_true_for_backup_zip() {
  test_begin "is_archive returns true for backup ending with .zip"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-2-20210410174014.zip" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_true_for_backup_rar() {
  test_begin "is_archive returns true for backup ending with .rar"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-3-20210410174014.rar" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_true_for_backup_7z() {
  test_begin "is_archive returns true for backup ending with .7z"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-4-20210410174014.7z" && result=true

  # Assert
  assert_true "$result"
}

testspec__is_archive__returns_false_if_file_does_not_start_with_backup() {
  test_begin "is_archive returns false if file does not start with backup"

  # Arrange
  result=false

  # Act
  is_archive "bakcup-sample-app-5-20210410174014.7z" && result=true

  # Assert
  assert_false "$result"
}

testspec__is_archive__returns_false_if_date_is_too_short() {
  test_begin "is_archive returns false if date is too short"

  # Arrange
  result=false

  # Act
  is_archive "backup-sample-app-5-202104101740.7z" && result=true

  # Assert
  assert_false "$result"
}


# common/get_volume_name

testspec__get_volume_name__returns_only_volume_name_from_archive_filename() {
  test_begin "get_volume_name returns only volume name from archive filename"

  # Arrange
  result="not_correct"

  # Act
  result="$(get_volume_name "backup-sample-app-5-20210410174014.7z")"

  # Assert
  assert_equals "sample-app-5" "$result"
}

testspec__get_volume_name__returns_volume_name_with_underscore() {
  test_begin "get_volume_name returns volume name with underscores"

  # Arrange
  result="not_correct"

  # Act
  result="$(get_volume_name "backup-sample_app_2-20210410174014.7z")"

  # Assert
  assert_equals "sample_app_2" "$result"
}


# common/get_free_space

testspec__get_free_space__returns_free_space_in_kb_from_df() {
  test_begin "get_free_space returns free space in kilobytes from df"

  # Arrange
  df() {
    /bin/echo "Filesystem    1024-blocks      Used Available Capacity Mounted on"
    /bin/echo "/dev/sda1       237584168 157483896  67961984      70% /volumes"
  }

  # Act
  result="$(get_free_space /volumes)"

  # Assert
  assert_equals "67961984" "$result"
}

testspec__get_free_space__returns_0_if_not_a_directory() {
  test_begin "get_free_space returns 0 if not a directory"

  # Arrange
  df() {
    /bin/echo "Filesystem    1024-blocks      Used Available Capacity Mounted on"
    /bin/echo "/dev/sda1       237584168 157483896  67961984      70% /not_a_directory"
  }

  # Act
  result="$(get_free_space /not_a_directory)"

  # Assert
  assert_equals "0" "$result"
}


# common/get_free_space_gb

testspec__get_free_space_gb__returns_free_space_in_gb() {
  test_begin "get_free_space_gb returns free space in gb"

  # Arrange
  df() {
    /bin/echo "Filesystem    1024-blocks      Used Available Capacity Mounted on"
    /bin/echo "/dev/sda1       237584168 157483896  67961984      70% /volumes"
  }

  # Act
  result="$(get_free_space_gb /volumes)"

  # Assert
  assert_equals "64" "$result"
}


# common/get_folder_size

testspec__get_folder_size__returns_folder_size_in_kb_from_du() {
  test_begin "get_folder_size returns folder size in kilobytes from du"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size /volumes/test)"

  # Assert
  assert_equals "22530640" "$result"
}

testspec__get_folder_size__returns_0_if_not_a_directory() {
  test_begin "get_folder_size returns 0 if not a directory"

  # Arrange
  du() {
    /bin/echo "22530640	/not_a_directory"
  }

  # Act
  result="$(get_folder_size /not_a_directory)"

  # Assert
  assert_equals "0" "$result"
}


# common/get_folder_size_mb

testspec__get_folder_size_mb__returns_folder_size_in_mb() {
  test_begin "get_folder_size_mb returns folder size in mb"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size_mb /volumes/test)"

  # Assert
  assert_equals "22002" "$result"
}


# common/get_folder_size_gb

testspec__get_folder_size_gb__returns_folder_size_in_gb() {
  test_begin "get_folder_size_gb returns folder size in gb"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size_gb /volumes/test)"

  # Assert
  assert_equals "21" "$result"
}


# common/get_folder_size_str

testspec__get_folder_size_str__returns_folder_size_in_mb_with_unit() {
  test_begin "get_folder_size_str returns folder size in mb with unit"

  # Arrange
  du() {
    /bin/echo "22530640	/volumes/test"
  }

  # Act
  result="$(get_folder_size_str /volumes/test)"

  # Assert
  assert_equals "22002 MB" "$result"
}


# common/get_file_size

testspec__get_file_size__returns_file_size_in_bytes() {
  test_begin "get_file_size returns file size in bytes"

  # Arrange
  stat() {
    /bin/echo "1113999"
  }

  # Act
  result="$(get_file_size /bin/bash)"

  # Assert
  assert_equals "1113999" "$result"
}

testspec__get_file_size__returns_0_if_file_does_not_exist() {
  test_begin "get_file_size returns file size in bytes"

  # Arrange
  stat() {
    /bin/echo "1113999"
  }

  # Act
  result="$(get_file_size /bin/nonexistent_file)"

  # Assert
  assert_equals "0" "$result"
}


# common/get_file_size_mb

testspec__get_file_size_mb__returns_file_size_in_mb() {
  test_begin "get_file_size_mb returns file size in mb"

  # Arrange
  stat() {
    /bin/echo "6200000"
  }

  # Act
  result="$(get_file_size_mb /bin/bash)"

  # Assert
  assert_equals "5" "$result"
}


# common/get_backups

testspec__get_backups__lists_backups_in_backup_folder() {
  test_begin "get_backups lists backups in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  result="$(get_backups | wc -l)"

  # Assert
  assert_equals "3" "$result"
}

testspec__get_backups__does_not_list_sfv_files() {
  test_begin "get_backups lists backups in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.sfv
  touch /backup/backup-test-backup-20210101155703.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155705.tgz

  # Act
  result="$(get_backups | wc -l)"

  # Assert
  assert_equals "4" "$result"
}

testspec__get_backups__only_lists_given_argument() {
  test_begin "get_backups lists backups matching given argument in /backup"

  # Arrange
  touch /backup/backup-aaa-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.sfv
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-bbb-backup-20210101155703.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-ccc-backup-20210101155705.tgz

  # Act
  result="$(get_backups "test-backup" | wc -l)"

  # Assert
  assert_equals "2" "$result"
}


# common/get_backup_count

testspec__get_backup_count__outputs_backup_count_in_backup_folder() {
  test_begin "get_backup_count outputs backup count in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155703.tgz
  touch /backup/backup-test-backup-20210101155704.tgz

  # Act
  result="$(get_backup_count)"

  # Assert
  assert_equals "4" "$result"
}


# common/get_latest_backup

testspec__get_latest_backup__outputs_the_latest_backup_in_backup_folder() {
  test_begin "get_latest_backup outputs the latest backup in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  result="$(get_latest_backup)"

  # Assert
  assert_equals "backup-test-backup-20210101155704.tgz" "$result"
}


# common/get_oldest_backup

testspec__get_oldest_backup__outputs_the_oldest_backup_in_backup_folder() {
  test_begin "get_oldest_backup outputs the oldest backup in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  result="$(get_oldest_backup)"

  # Assert
  assert_equals "backup-test-backup-20210101155701.tgz" "$result"
}


# common/get_reversed_backups

testspec__get_reversed_backups__outputs_backups_in_reversed_order_in_backup_folder() {
  test_begin "get_reversed_backups outputs backups in reversed order in /backup"

  # Arrange
  touch /backup/backup-test-backup-20210101155702.tgz
  touch /backup/backup-test-backup-20210101155701.tgz
  touch /backup/backup-test-backup-20210101155704.tgz
  touch /backup/backup-test-backup-20210101155703.tgz

  # Act
  LFS=$'\n' read -d '' -a files <<< "$(get_reversed_backups)"

  # Assert
  assert_equals "backup-test-backup-20210101155704.tgz" "${files[0]}"
  assert_equals "backup-test-backup-20210101155701.tgz" "${files[3]}"
  assert_equals "4" "${#files[@]}"
}


# common/parse_time

testspec__parse_time__outputs_correct_unixtime() {
  test_begin "parse_time outputs correct unixtime"

  # Arrange
  backup_filename="backup-test-backup-20140517223556.tgz"
  expected_unixtime=$(date --date "2014-05-17 22:35:56" +"%s")

  # Act
  result="$(parse_time "$backup_filename")"

  # Assert
  assert_equals "$expected_unixtime" "$result"
}


# common/contains_numeric_date

testspec__contains_numeric_date__returns_false_if_too_short_date() {
  test_begin "contains_numeric_date returns false if bad date"

  # Arrange
  backup_filename="backup-test-backup-201405172235.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

testspec__contains_numeric_date__returns_false_if_old_year() {
  test_begin "contains_numeric_date returns false if old year"

  # Arrange
  backup_filename="backup-test-backup-19690522143556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

testspec__contains_numeric_date__returns_false_if_bad_month() {
  test_begin "contains_numeric_date returns false if bad month"

  # Arrange
  backup_filename="backup-test-backup-19891322143556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

testspec__contains_numeric_date__returns_false_if_bad_day() {
  test_begin "contains_numeric_date returns false if bad day"

  # Arrange
  backup_filename="backup-test-backup-19891132143556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

testspec__contains_numeric_date__returns_false_if_bad_hour() {
  test_begin "contains_numeric_date returns false if bad hour"

  # Arrange
  backup_filename="backup-test-backup-19891131243556.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

testspec__contains_numeric_date__returns_false_if_bad_minute() {
  test_begin "contains_numeric_date returns false if bad minute"

  # Arrange
  backup_filename="backup-test-backup-19891131236056.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}

testspec__parse_time__returns_false_if_bad_second() {
  test_begin "parse_time returns false if bad second"

  # Arrange
  backup_filename="backup-test-backup-19891131235960.tgz"
  result=false

  # Act
  contains_numeric_date "$backup_filename" && result=true

  # Assert
  assert_false "$result"
}


# Integration tests

testspec__backup_two_volumes_creates_two_backups() {
  local backup_count

  test_begin "Backup two volumes and get two backups"

  # Act
  prepare second-test
  backup

  # Assert
  backup_count="$(get_backup_count)"
  assert_equals "2" "$backup_count"
}

testspec__backup_volume_with_correct_name() {
  local backup_count

  test_begin "Backup a volume with the correct backup filename"

  # Act
  backup

  # Assert
  backup_name="$(get_latest_backup test)"
  assert_file_starts_with "$backup_name" "backup-test-"
}

testspec__backup_remove_restore() {
  local file_to_restore

  test_begin "Backup, remove and then restore file"

  # Arrange
  file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"

  # Act
  restore "$(get_latest_backup test)"

  # Assert
  assert_file_exists "$file_to_restore"
}

testspec__backup_remove_restore_encrypted() {
  local file_to_restore latest_backup

  test_begin "Backup, remove and then restore file (with encryption)"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  latest_backup="$(get_latest_backup test)"
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"

  # Act
  restore "$latest_backup"

  # Assert
  assert_file_exists "$file_to_restore"
}

testspec__restore_encrypted_with_bad_password() {
  local file_to_restore latest_backup

  test_begin "Restore encrypted backup with bad password"

  # Arrange
  ENCRYPT_ARCHIVES=true
  ENCRYPTION_PASSWORD=abc123
  file_to_restore="$VOLUME_PATH/test/test_file_2"
  assert_file_exists "$file_to_restore"
  backup
  latest_backup="$(get_latest_backup test)"
  rm -f "$file_to_restore"
  assert_file_does_not_exist "$file_to_restore"
  assert_file_ends_with "$latest_backup" ".enc"

  # Act
  ENCRYPTION_PASSWORD=badpassword
  restore "$latest_backup"

  # Assert
  assert_file_does_not_exist "$file_to_restore"
}
