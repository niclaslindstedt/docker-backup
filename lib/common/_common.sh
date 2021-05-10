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

is_debug() { [ "$DEBUG" = "true" ]; }
is_verbose() { [ "$VERBOSE" = "true" ]; }

get_output() { is_debug && echo "/dev/stdout" || echo "/dev/null"; }

# shellcheck disable=SC2034
OUTPUT="$(get_output)"
