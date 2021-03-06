#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

COMPONENT="BACKUP"

main() {
  (
    lock
    log "+++ Starting backup process"
    run_backup "$1"
    log "--- Finished backup process"
  ) 200>"$FILELOCK_PATH"
  logd "Lock released"
}

. /.env
for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/backup/*; do . "$f"; done

main "$1"
