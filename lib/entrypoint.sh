#!/bin/bash

# shellcheck disable=SC1090,SC2034

COMPONENT="ENTRYPOINT"

for f in "$APP_PATH"/common/*; do . "$f"; done
for f in "$APP_PATH"/entrypoint/*; do . "$f"; done

create_cronjobs
set_timezone
echo_settings
trail_log
