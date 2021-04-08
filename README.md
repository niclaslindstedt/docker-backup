# Docker Backup

Backs up your Docker volumes and/or data folders and stores them both short-term and long-term. Purge old backups after X days or when free space gets tight.

**CAUTION: Do not use this for production environments. It has not been thorougly tested yet.**

## Features

* Cron for precise backup schedules.
* Backup any folder or Docker volume on your host machine.
* Easily restore a backup.
* Stop your other Docker containers during backup/restoration to prevent invalid states.

## Instructions

1. Mount all volumes you want backed up in `/volumes`
2. Mount the short-term backup location in `/backup`
3. Mount the long-term storage location in `/lts`

## Environment variables

Variable | Default | Description
--- | --- | ---
`ENABLE_LTS` | `true` | Set to 'false' to disable long-term storage.
`ENABLE_PURGE` | `true` | Set to 'false' to disable purging of old backups.
`CRON_BACKUP` | `0 5 * * *` | Cron schedule for creating backups of all volumes.
`CRON_LTS` | `0 9 * * *` | Cron schedule for copying backups to the long-term storage folder.
`CRON_PURGE` | `0 3 * * *` | Cron schedule for purging backups in the short-term backup folder.
`KEEP_BACKUPS_FOR_DAYS` | `30` | Set to how many days you want to keep backups in the short-term backup folder.
`KEEP_LTS_FOR_MONTHS` | `6` | Set to how long you want to keep long-term storage backups.
`KEEP_DAILY_AFTER_HOURS` | `24` | The breakpoint (in hours) for when hourly backups turn into daily.
`KEEP_WEEKLY_AFTER_DAYS` | `14` | The breakpoint (in days) for when daily backups turn into weekly.
`KEEP_MONTHLY_AFTER_WEEKS` | `4` | The breakpoint (in weeks) for when weekly backups turn into monthly.
`MINIMUM_FREE_SPACE` | `30` | Set to how many gigabytes of storage you want to keep free.
`CREATE_CHECKSUMS` | `true` | Set to 'false' to disable creation of checksums (sfv).
`VERIFY_CHECKSUMS` | `true` | Set to 'false' to disable checksum (sfv) verification before restoring a backup and after copying a backup to long-term storage.
`DOCKER_STOP_TIMEOUT` | `30` | The amount of seconds to wait for the containers to stop before killing them.
`PROJECT_NAME` | | The name of the project folder (used for naming containers with docker-compose).
`STOP_CONTAINERS` | | The names of the containers that should be stopped before backing up & restoring. Comma-separated list.

## Commands

You can use `docker-compose exec backup <command>` to run the following commands inside the container:

Command | Description
--- | ---
`backup` | Backup all volumes.
`backup <volume>` | Backup a specific volume.
`store` | Copies the latest backups to the long-term storage location.
`purge` | Purges old backups from the backup location.
`restore` | Restores all volumes to their latest backups.
`restore <volume>` | Restores the latest backup of the provided volume name.
`restore <backup filename>` | Restores a specific backup to its associated volume.
