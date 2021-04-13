#!/bin/bash

set_result() {
  /bin/echo "$1" > /tmp/test_result
}

get_result() {
  /bin/cat /tmp/test_result
}

test_begin() {
  reset_tests
  /bin/echo -e "${YELLOW}*** TEST: $* ***${EC}"
}

reset_tests() {
  /bin/rm -rf "${BACKUP_PATH:?}"/* "${LTS_PATH:?}"/* "${VOLUME_PATH:?}"/* /tmp/test_result
  /bin/echo > "$LOG_PATH"
  prepare test
}

prepare() {
  /bin/mkdir -p "$BACKUP_PATH" "$LTS_PATH" "$VOLUME_PATH/$1"
  /bin/echo "this" >> "$VOLUME_PATH/${1:-test}/test_file_1"
  /bin/echo "is a way" >> "$VOLUME_PATH/${1:-test}/test_file_2"
  /bin/echo "to test" >> "$VOLUME_PATH/${1:-test}/test_file_3"
  /bin/echo "that backup" >> "$VOLUME_PATH/${1:-test}/test_file_4"
  /bin/echo "actually works" >> "$VOLUME_PATH/${1:-test}/test_file_5"
}
