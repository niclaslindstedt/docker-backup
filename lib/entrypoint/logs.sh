#!/bin/bash

trail_log() {
  echo
  echo "Trailing output log:"
  touch "$LOG_PATH"
  tail -f "$LOG_PATH"
}
