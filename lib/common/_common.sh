#!/bin/bash

# Log a message to stdout + log file
# Params: <string>
log() { echo -e "[$COMPONENT] $*" | tee -a "$LOG_PATH"; }

# Logs a message to stdout + log file without trailing newline
# Params: <string>
logn() { echo -n "[$COMPONENT] $*" | tee -a "$LOG_PATH"; }

# Logs a message if verbose mode is enabled
# Params: <string>
logv() { is_verbose && log "$*"; }

# Logs a message if debug mode is enabled
# Params: <string>
logd() { is_debug && log "$*"; }

# Throws an error (exits the current shell). Will also pause containers if that functionality is enabled.
# Params: [error message]
error() {
  is_set "$1" && log "ERROR: $*"
  unpause_containers "$PAUSE_CONTAINERS"
  log "Exiting script"
  exit 1
}

# Checks if running image is alpine build
is_alpine() { [ "$IS_ALPINE" = "true" ]; }

# Checks if debug mode is enabled
is_debug() { [ "$DEBUG" = "$TRUE" ]; }

# Checks if verbose mode is enabled
is_verbose() { [ "$VERBOSE" = "$TRUE" ]; }

# Returns output device depending on debug mode
get_output() { is_debug && echo "/dev/stdout" || echo "/dev/null"; }

# shellcheck disable=SC2034
OUTPUT="$(get_output)" # output variable used for debug output
