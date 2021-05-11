#!/bin/bash

# shellcheck disable=SC1090,SC1091,SC2034

COMPONENT="PRUNE"

main() {
  log "+++ Starting prune process"

  run_prune "$1"

  log "--- Finished prune process"
}

. /.env
for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/prune/*; do . "$f"; done

main "$1"
