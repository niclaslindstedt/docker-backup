#!/bin/bash

set_result() {
  /bin/echo "$1" > /tmp/test_result
}

get_result() {
  /bin/cat /tmp/test_result
}

test_begin() {
  reset_tests
  log "${YELLOW}*** TEST: $* ***${EC}"
}

reset_tests() {
  log "Cleaning up."
  rm -rf "${BACKUP_PATH:?}"/* "${LTS_PATH:?}"/* "${VOLUME_PATH:?}"/* /tmp/test_result
  echo > "$LOG_PATH"
  prepare test
}

prepare() {
  mkdir -p "$BACKUP_PATH" "$LTS_PATH" "$VOLUME_PATH/$1"
  echo "this" >> "$VOLUME_PATH/${1:-test}/test_file_1"
  echo "is a way" >> "$VOLUME_PATH/${1:-test}/test_file_2"
  echo "to test" >> "$VOLUME_PATH/${1:-test}/test_file_3"
  echo "that backup" >> "$VOLUME_PATH/${1:-test}/test_file_4"
  echo "actually works" >> "$VOLUME_PATH/${1:-test}/test_file_5"
}
