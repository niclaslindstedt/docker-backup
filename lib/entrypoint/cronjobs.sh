#!/bin/bash

# Create cronjobs in /etc/cron.d
create_cronjobs() {
  local cronfile

  if is_alpine; then
    cronfile="/etc/crontabs/root"
  else
    cronfile="/etc/cron.d/docker-backup"
  fi

  {
    echo "# $cronfile"
    echo
    echo "SHELL=/bin/bash"
    echo
    echo "$(format_cron "$CRON_BACKUP") $APP_PATH/backup.sh"
    [ "$ENABLE_LTS" = "$TRUE" ] && echo "$(format_cron "$CRON_LTS") $APP_PATH/store.sh"
    [ "$ENABLE_PRUNE" = "$TRUE" ] && echo "$(format_cron "$CRON_PRUNE") $APP_PATH/prune.sh"
  } | sudo tee -a $cronfile >/dev/null

  if is_alpine; then
    sudo crond -b -l "$(get_debug_level)" -L /var/log/cron.log
  else
    sudo cron -L "$(get_debug_level)"
  fi

  echo "Cronjob created"
}

format_cron() {
  local minute hour day month dow

  minute="$(echo "$1" | awk '{ print $1 }')"
  hour="$(echo "$1" | awk '{ print $2 }')"
  day="$(echo "$1" | awk '{ print $3 }')"
  month="$(echo "$1" | awk '{ print $4 }')"
  dow="$(echo "$1" | awk '{ print $5 }')"

  printf '%-8s' "$minute"
  printf '%-8s' "$hour"
  printf '%-8s' "$day"
  printf '%-8s' "$month"
  printf '%-7s' "$dow"

  if ! is_alpine; then
    printf '%-7s' " $RUN_AS_USER"
  fi
}

get_debug_level() {
  if is_alpine; then
    if is_debug; then
      echo 0
    elif is_verbose; then
      echo 4
    else
      echo 8
    fi
  else
    if is_debug; then
      echo 15
    elif is_verbose; then
      echo 7
    else
      echo 1
    fi
  fi
}
