#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

COMPONENT="LTS"

main() {
  (
    lock
    log "+++ Starting long-term storage process"
    run_store "$1"
    log "--- Finished long-term storage process"
  ) 200>"$FILELOCK_PATH"
  logd "Lock released"
}

. /.env
for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/store/*; do . "$f"; done

main "$1"
