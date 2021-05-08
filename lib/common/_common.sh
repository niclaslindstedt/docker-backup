#!/bin/bash

log() { echo -e "[$COMPONENT] $*" | tee -a "$LOG_PATH"; }
loga() { echo -n "[$COMPONENT] $*" | tee -a "$LOG_PATH"; }
logv() { is_verbose && log "$*"; }
logd() { is_debug && log "$*"; }

error() {
  is_set "$1" && log "ERROR: $*"
  is_set "$PAUSE_CONTAINERS" && start_containers
  log "Exiting script"
  exit 1
}
