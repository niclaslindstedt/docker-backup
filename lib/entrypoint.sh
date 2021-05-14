#!/bin/bash

# shellcheck disable=SC1090,SC2034

COMPONENT="ENTRYPOINT"

main() {
  verify_settings
  echo_settings
  create_cronjobs
  set_timezone
  check_permissions
  write_environment
  trail_log
}

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/entrypoint/*; do . "$f"; done

main
