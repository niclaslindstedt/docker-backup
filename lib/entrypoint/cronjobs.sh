#!/bin/bash

create_cronjobs() {
  {
    echo "# /etc/cron.d/docker-backup"
    echo
    echo "SHELL=/bin/bash"
    echo "PATH=$PATH"
    echo
    echo "$CRON_BACKUP   docker-backup   backup"
    [ "$ENABLE_LTS" = "true" ] && echo "$CRON_LTS   docker-backup   store"
    [ "$ENABLE_PRUNE" = "true" ] && echo "$CRON_PRUNE   docker-backup   prune"
  } | sudo tee /etc/cron.d/docker-backup >/dev/null

  sudo cron
}
