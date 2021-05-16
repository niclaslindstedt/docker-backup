#!/bin/bash

# Verify that settings are valid
verify_settings() {
  verify_writable_path APP_PATH
  verify_writable_path LOG_PATH
  verify_writable_path VOLUME_PATH
  verify_writable_path BACKUP_PATH
  verify_writable_path LTS_PATH
  verify_boolean ENABLE_LTS
  verify_boolean ENABLE_PRUNE
  verify_cron CRON_BACKUP
  verify_cron CRON_LTS
  verify_cron CRON_PRUNE
  verify_boolean VERBOSE
  verify_boolean DEBUG
  verify_boolean ASSUME_YES
  verify_archive ARCHIVE_TYPE
  verify_boolean ENCRYPT_ARCHIVES
  [ "$ENCRYPT_ARCHIVES" = "$TRUE" ] && [ "$SKIP_PASSWORD_LENGTH_CHECK" != "$TRUE" ] && verify_length ENCRYPTION_PASSWORD 30
  [ "$ENCRYPT_ARCHIVES" = "$TRUE" ] && verify_encryption_algo ENCRYPTION_ALGORITHM
  verify_number KEEP_BACKUPS_FOR_DAYS
  verify_number KEEP_LTS_FOR_MONTHS
  verify_number KEEP_DAILY_AFTER_HOURS
  verify_number KEEP_WEEKLY_AFTER_DAYS
  verify_number KEEP_MONTHLY_AFTER_WEEKS
  verify_number MINIMUM_FREE_SPACE
  verify_boolean CREATE_CHECKSUMS
  verify_boolean VERIFY_CHECKSUMS
  verify_number LOCK_TIMEOUT
}

# Print out the current settings
echo_settings() {
  echo
  echo "+--------------------------------------------------------+"
  echo "| SETTINGS                                               |"
  echo "+---------------------------+----------------------------+"
  [ "$DEBUG" = "$TRUE" ] && echo_setting APP_PATH
  [ "$DEBUG" = "$TRUE" ] && echo_setting LOG_PATH
  [ "$DEBUG" = "$TRUE" ] && echo_setting VOLUME_PATH
  [ "$DEBUG" = "$TRUE" ] && echo_setting BACKUP_PATH
  [ "$DEBUG" = "$TRUE" ] && echo_setting LTS_PATH
  echo_setting ENABLE_LTS
  echo_setting ENABLE_PRUNE
  echo_setting CRON_BACKUP
  [ "$ENABLE_LTS" = "$TRUE" ] && echo_setting CRON_LTS
  [ "$ENABLE_PRUNE" = "$TRUE" ] && echo_setting CRON_PRUNE
  echo_setting VERBOSE
  echo_setting DEBUG
  echo_setting ASSUME_YES
  echo_setting ARCHIVE_TYPE
  echo_setting ENCRYPT_ARCHIVES
  [ "$ENCRYPT_ARCHIVES" = "$TRUE" ] && echo_setting_masked ENCRYPTION_PASSWORD
  [ "$ENCRYPT_ARCHIVES" = "$TRUE" ] && echo_setting ENCRYPTION_ALGORITHM
  [ "$ENABLE_PRUNE" = "$TRUE" ] && echo_setting KEEP_BACKUPS_FOR_DAYS
  [ "$ENABLE_PRUNE" = "$TRUE" ] && echo_setting KEEP_LTS_FOR_MONTHS
  [ "$ENABLE_PRUNE" = "$TRUE" ] && echo_setting KEEP_DAILY_AFTER_HOURS
  [ "$ENABLE_PRUNE" = "$TRUE" ] && echo_setting KEEP_WEEKLY_AFTER_DAYS
  [ "$ENABLE_PRUNE" = "$TRUE" ] && echo_setting KEEP_MONTHLY_AFTER_WEEKS
  echo_setting MINIMUM_FREE_SPACE
  echo_setting CREATE_CHECKSUMS
  [ "$CREATE_CHECKSUMS" = "$TRUE" ] && echo_setting VERIFY_CHECKSUMS
  [ "$DOCKER_INSTALLED" = "$TRUE" ] && is_set "$PROJECT_NAME" && echo_setting PROJECT_NAME
  [ "$DOCKER_INSTALLED" = "$TRUE" ] && is_set "$PAUSE_CONTAINERS" && echo_setting PAUSE_CONTAINERS
  echo_setting TZ
  echo_setting LOCK_TIMEOUT
  echo "+---------------------------+----------------------------+"
  echo
}

# Prints a specific setting and format it
echo_setting() {
  echo "| $(printf '%-25s' "$1") | $(printf '%-26s' "${!1}") |"
}

# Prints a specific setting and masks it with stars (*), useful for passwords
echo_setting_masked() {
  echo "| $(printf '%-25s' "$1") | $(printf '%-26s' "$(echo "${!1}" | cut -c1-16 | sed -r "s/./\*/g")") |"
}

# Helpers
error() { echo "$*"; exit 1; }
verify_boolean() { [ "${!1}" = "$TRUE" ] || [ "${!1}" = "$FALSE" ] || error "$1 is not a valid boolean (${!1})"; }
verify_number() { [[ "${!1}" =~ ^[0-9]+$ ]] || error "$1 is not a number (${!1})"; }
verify_writable_path() { [ -w "${!1}" ] || error "$1 is not a writable path (${!1})"; }
verify_archive() {
  [[ "${!1}" =~ ^(tgz|7z|zip|rar)$ ]] || error "$1 is not a valid archive (${!1})"
  [ "${!1}" = "rar" ] && is_alpine && error "$1 cannot be set to rar on alpine build"
}

verify_length() {
  local tmp
  tmp="${!1}"
  [ "${#tmp}" -gt "$2" ] || error "$1 needs to be at least $2 characters long"
}

verify_encryption_algo() {
  [[ "${!1}" =~ ^(IDEA|CAST5|BLOWFISH|AES256|TWOFISH|CAMELLIA256)$ ]] || \
    error "$1 is not a valid gnupg encryption algorithm (${!1})";
}

verify_cron() {
  local cron_unit regex

  cron_unit="(\\*(\\/[1-9]?[0-9])?|((60|[1-5]?[0-9])(\\-[0-9]+)?((,[0-9])+)?))"
  regex="^($cron_unit\\s){4}$cron_unit$"

  if [ "$(echo "${!1}" | grep -c -E "$regex")" -eq "0" ]; then
    error "$1 is not a valid crontab string (${!1})";
  fi
  return 0
}
