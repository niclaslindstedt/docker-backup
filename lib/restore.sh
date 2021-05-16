#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

COMPONENT="RESTORE"

main() {
  (
    lock
    log "+++ Starting restore process"
    run_restore "$1"
    log "--- Finished restore process"
  ) 200>"$FILELOCK_PATH"
  logd "Lock released"
}

. /.env
for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/restore/*; do . "$f"; done

main "$1"
