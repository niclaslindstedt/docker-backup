#!/bin/bash

# Create cronjobs
{
  env
  echo "$CRON_BACKUP   root   backup"
  [ "$ENABLE_LTS" = "true" ] && echo "$CRON_LTS   root   store"
  [ "$ENABLE_PRUNE" = "true" ] && echo "$CRON_PRUNE   root   prune"
  echo
} | sudo tee /etc/cron.d/docker-backup >/dev/null

sudo ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
echo "$TZ" | sudo tee /etc/timezone >/dev/null

sudo cron

echo "*** SETTINGS ***"
echo "APP_PATH => $APP_PATH"
echo "LOG_PATH => $LOG_PATH"
echo "VOLUME_PATH => $VOLUME_PATH"
echo "BACKUP_PATH => $BACKUP_PATH"
echo "LTS_PATH => $LTS_PATH"
echo "ENABLE_LTS => $ENABLE_LTS"
echo "ENABLE_PRUNE => $ENABLE_PRUNE"
echo "CRON_BACKUP => $CRON_BACKUP"
echo "CRON_LTS => $CRON_LTS"
echo "CRON_PRUNE => $CRON_PRUNE"
echo "VERBOSE => $VERBOSE"
echo "DEBUG => $DEBUG"
echo "ASSUME_YES => $ASSUME_YES"
echo "ARCHIVE_TYPE => $ARCHIVE_TYPE"
echo "ENCRYPT_ARCHIVES => $ENCRYPT_ARCHIVES"
printf "ENCRYPTION_PASSWORD => " && echo "$ENCRYPTION_PASSWORD" | sed -r "s/./\*/g"
echo "KEEP_BACKUPS_FOR_DAYS => $KEEP_BACKUPS_FOR_DAYS days"
echo "KEEP_LTS_FOR_MONTHS => $KEEP_LTS_FOR_MONTHS months"
echo "KEEP_DAILY_AFTER_HOURS => $KEEP_DAILY_AFTER_HOURS hours"
echo "KEEP_WEEKLY_AFTER_DAYS => $KEEP_WEEKLY_AFTER_DAYS days"
echo "KEEP_MONTHLY_AFTER_WEEKS => $KEEP_MONTHLY_AFTER_WEEKS weeks"
echo "MINIMUM_FREE_SPACE => $MINIMUM_FREE_SPACE GB"
echo "CREATE_CHECKSUMS => $CREATE_CHECKSUMS"
echo "VERIFY_CHECKSUMS => $VERIFY_CHECKSUMS"
echo "PROJECT_NAME => $PROJECT_NAME"
echo "PAUSE_CONTAINERS => $PAUSE_CONTAINERS"
echo "TZ => $TZ"
echo

echo "tail -f $LOG_PATH:"
touch "$LOG_PATH"
tail -f "$LOG_PATH"
