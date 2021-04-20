#!/bin/bash

# This script will remove backups that are older than x days from
# the backup location and prune backups in the long-term storage
# to keep disks from overflowing.

# shellcheck disable=SC1091,SC2034

COMPONENT="PRUNE"

main() {
  log "Starting prune process"

  #purge_backups
  prune_lts

  log "Finished prune process"
}

source "$APP_PATH/common.sh"
source "$APP_PATH/prune_functions.sh"

main "$1"
