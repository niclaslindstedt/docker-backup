#!/bin/bash

# Create cronjobs
{
  env
  echo "$CRON_BACKUP   root   backup"
  [ "$ENABLE_LTS" = "true" ] && echo "$CRON_LTS   root   store"
  [ "$ENABLE_PURGE" = "true" ] && echo "$CRON_PURGE   root   purge"
  echo
} > /etc/cron.d/docker-backup

cron

echo "*** SETTINGS ***"
echo "APP_PATH => $APP_PATH"
echo "LOG_PATH => $LOG_PATH"
echo "VOLUME_PATH => $VOLUME_PATH"
echo "BACKUP_PATH => $BACKUP_PATH"
echo "ENABLE_LTS => $ENABLE_LTS"
echo "ENABLE_PURGE => $ENABLE_PURGE"
echo "LTS_PATH => $LTS_PATH"
echo "CRON_BACKUP => $CRON_BACKUP"
echo "CRON_LTS => $CRON_LTS"
echo "CRON_PURGE => $CRON_PURGE"
echo "KEEP_BACKUPS_FOR_DAYS => $KEEP_BACKUPS_FOR_DAYS days"
echo "KEEP_LTS_FOR_MONTHS => $KEEP_LTS_FOR_MONTHS months"
echo "KEEP_DAILY_AFTER_HOURS => $KEEP_DAILY_AFTER_HOURS hours"
echo "KEEP_WEEKLY_AFTER_DAYS => $KEEP_WEEKLY_AFTER_DAYS days"
echo "KEEP_MONTHLY_AFTER_WEEKS => $KEEP_MONTHLY_AFTER_WEEKS weeks"
echo "MINIMUM_FREE_SPACE => $MINIMUM_FREE_SPACE GB"
echo "CREATE_CHECKSUMS => $CREATE_CHECKSUMS"
echo "VERIFY_CHECKSUMS => $VERIFY_CHECKSUMS"
echo "DOCKER_STOP_TIMEOUT => $DOCKER_STOP_TIMEOUT seconds"
echo "PROJECT_NAME => $PROJECT_NAME"
echo "STOP_CONTAINERS => $STOP_CONTAINERS"
echo

echo "*** OUTPUT ***"
touch "$LOG_PATH"
tail -f "$LOG_PATH"
