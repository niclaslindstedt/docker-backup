#!/bin/bash

# Print out the current settings
echo_settings() {
  echo "+--------------------------------------------------------+"
  echo "| SETTINGS                                               |"
  echo "+---------------------------+----------------------------+"
  [ "$DEBUG" = "true" ] && echo_setting "APP_PATH" "$APP_PATH"
  [ "$DEBUG" = "true" ] && echo_setting "LOG_PATH" "$LOG_PATH"
  [ "$DEBUG" = "true" ] && echo_setting "VOLUME_PATH" "$VOLUME_PATH"
  [ "$DEBUG" = "true" ] && echo_setting "BACKUP_PATH" "$BACKUP_PATH"
  [ "$DEBUG" = "true" ] && echo_setting "LTS_PATH" "$LTS_PATH"
  echo_setting "ENABLE_LTS" "$ENABLE_LTS"
  echo_setting "ENABLE_PRUNE" "$ENABLE_PRUNE"
  echo_setting "CRON_BACKUP" "$CRON_BACKUP"
  [ "$ENABLE_LTS" = "true" ] && echo_setting "CRON_LTS" "$CRON_LTS"
  [ "$ENABLE_PRUNE" = "true" ] && echo_setting "CRON_PRUNE" "$CRON_PRUNE"
  echo_setting "VERBOSE" "$VERBOSE"
  echo_setting "DEBUG" "$DEBUG"
  echo_setting "ASSUME_YES" "$ASSUME_YES"
  echo_setting "ARCHIVE_TYPE" "$ARCHIVE_TYPE"
  echo_setting "ENCRYPT_ARCHIVES" "$ENCRYPT_ARCHIVES"
  [ "$ENCRYPT_ARCHIVES" = "true" ] && echo_setting "ENCRYPTION_PASSWORD" "$(echo "$ENCRYPTION_PASSWORD" | sed -r "s/./\*/g")"
  [ "$ENABLE_PRUNE" = "true" ] && echo_setting "KEEP_BACKUPS_FOR_DAYS" "$KEEP_BACKUPS_FOR_DAYS days"
  [ "$ENABLE_PRUNE" = "true" ] && echo_setting "KEEP_LTS_FOR_MONTHS" "$KEEP_LTS_FOR_MONTHS months"
  [ "$ENABLE_PRUNE" = "true" ] && echo_setting "KEEP_DAILY_AFTER_HOURS" "$KEEP_DAILY_AFTER_HOURS hours"
  [ "$ENABLE_PRUNE" = "true" ] && echo_setting "KEEP_WEEKLY_AFTER_DAYS" "$KEEP_WEEKLY_AFTER_DAYS days"
  [ "$ENABLE_PRUNE" = "true" ] && echo_setting "KEEP_MONTHLY_AFTER_WEEKS" "$KEEP_MONTHLY_AFTER_WEEKS weeks"
  echo_setting "MINIMUM_FREE_SPACE" "$MINIMUM_FREE_SPACE GB"
  echo_setting "CREATE_CHECKSUMS" "$CREATE_CHECKSUMS"
  [ "$CREATE_CHECKSUMS" = "true" ] && echo_setting "VERIFY_CHECKSUMS" "$VERIFY_CHECKSUMS"
  [ -n "$PROJECT_NAME" ] && echo_setting "PROJECT_NAME" "$PROJECT_NAME"
  [ -n "$PAUSE_CONTAINERS" ] && echo_setting "PAUSE_CONTAINERS" "$PAUSE_CONTAINERS"
  echo_setting "TZ" "$TZ"
  echo "+---------------------------+----------------------------+"
  echo
}

# Print out a specific setting and format it
echo_setting() {
  echo "| $(printf '%-25s' "$1") | $(printf '%-26s' "$2") |"
}
