#!/bin/bash

# Log a message to stdout + log file
# Params: <string>
log() { echo -e "[$COMPONENT] $*" | tee -a "$LOG_PATH"; }

# Logs a message to stdout + log file without trailing newline
# Params: <string>
logn() {
  if is_set "$1"; then
    echo -n "[$COMPONENT] $*" | tee -a "$LOG_PATH"
  else
    echo | tee -a "$LOG_PATH"
  fi
}

# Logs a message if verbose mode is enabled
# Params: <string>
logv() { log1 "$*"; }

# Logs a message if debug mode is enabled
# Params: <string>
logd() { log5 "$*"; }

# Verbose logging (with log levels)
log1() { [ "$LOG_LEVEL" -ge 1 ] && log "$*"; } # The least verbose
log2() { [ "$LOG_LEVEL" -ge 2 ] && log "$*"; }
log3() { [ "$LOG_LEVEL" -ge 3 ] && log "$*"; }
log4() { [ "$LOG_LEVEL" -ge 4 ] && log "$*"; }
logd() { [ "$LOG_LEVEL" -ge 5 ] && log "$*"; } # Most verbose

# Throws an error (exits the current shell). Will also pause containers if that functionality is enabled.
# Params: [error message]
error() {
  is_set "$1" && log "ERROR: $*"
  unpause_containers "$PAUSE_CONTAINERS"
  log "Exiting script"
  exit 1
}

# Create a file lock to prevent simultaneous operations
lock() {
  log4 "Attempting to aquire lock (timeout: ${LOCK_TIMEOUT}s)"
  flock -w "$LOCK_TIMEOUT" -e 200 || error "Could not aquire lock"
  logd "Aquired lock"
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
