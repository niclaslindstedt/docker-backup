#!/bin/bash

# Create cronjobs in /etc/cron.d
create_cronjobs() {
  local cronfile

  cronfile="/etc/cron.d/docker-backup"

  {
    echo "# $cronfile"
    echo
    echo "SHELL=/bin/bash"
    echo
    echo "$CRON_BACKUP   $RUN_AS_USER   $APP_PATH/backup.sh"
    #[ "$ENABLE_LTS" = "true" ] &&
    echo "$CRON_LTS   $RUN_AS_USER   $APP_PATH/store.sh"
    #[ "$ENABLE_PRUNE" = "true" ] &&
    echo "$CRON_PRUNE   $RUN_AS_USER   $APP_PATH/prune.sh"
  } | sudo tee $cronfile >/dev/null

  sudo cron

  echo "Cronjob created"
}
