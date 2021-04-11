#!/bin/bash

test_begin() {
  reset_tests
  log "${YELLOW}*** TEST: $* ***${EC}"
}

reset_tests() {
  log "Cleaning up."
  rm -rf $BACKUP_PATH/* $LTS_PATH/* $TEST_VOLUME/*
  echo > $LOG_PATH
  prepare
}

prepare() {
  mkdir -p $BACKUP_PATH $LTS_PATH $TEST_VOLUME
  echo "this" >> $TEST_VOLUME/test_file_1
  echo "is a way" >> $TEST_VOLUME/test_file_2
  echo "to test" >> $TEST_VOLUME/test_file_3
  echo "that backup" >> $TEST_VOLUME/test_file_4
  echo "actually works" >> $TEST_VOLUME/test_file_5
}
