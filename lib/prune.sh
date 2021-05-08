#!/bin/bash

# This script will remove backups that are older than x days from
# the backup location and prune backups in the long-term storage
# to keep disks from overflowing.

# shellcheck disable=SC1090,SC1091,SC2034

COMPONENT="PRUNE"

main() {
  log "Starting prune process"

  purge_backups
  prune_lts

  log "Finished prune process"
}

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/prune/*; do . "$f"; done

main "$1"
