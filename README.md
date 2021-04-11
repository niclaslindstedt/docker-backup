# Docker Backup

Backs up your Docker volumes and/or data folders and stores them both short-term and long-term. Prune old backups after X days or when free space gets tight.

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

### Backing up local folders

You can use this project to create backups of local folders (i.e. not Docker volumes) as well. Just mount in everything you want to backup in the /volumes folder.

```
version: '3.7'
services:
  backup:
    image: niclaslindstedt/docker-backup:latest
    restart: always
    environment:
      - ENABLE_LTS=false # turn off long-term storage
      - ENABLE_PRUNE=false # turn off purging of backups
    volumes:
      - /home/johndoe/Documents:/volumes/documents
      - /mnt/data/backups:/backup
      - /etc/localtime:/etc/localtime:ro
```

### Using S3 as long-term storage

See the `docker-compose.s3.yml` file on how to use an S3 bucket as long-term storage.

## Environment variables

Variable | Default | Description
--- | --- | ---
`ENABLE_LTS` | `true` | Set to 'false' to disable long-term storage.
`ENABLE_PRUNE` | `true` | Set to 'false' to disable purging of old backups.
`CRON_BACKUP` | `0 5 * * *` | Cron schedule for creating backups of all volumes.
`CRON_LTS` | `0 9 * * *` | Cron schedule for copying backups to the long-term storage folder.
`CRON_PRUNE` | `0 3 * * *` | Cron schedule for pruning backups.
`VERBOSE` | `false` | Set to 'true' to enable extra verbose logging.
`DEBUG` | `false` | Set to 'true' to enable debug logging.
`ASSUME_YES` | `false` | Set to 'true' to always assume yes when asking for confirmation.
`ARCHIVE_TYPE` | `tgz` | Use this archive type for storage, one of: `tgz` `zip` `rar` `7z`
`ENCRYPT_ARCHIVES` | `false` | Encrypt archives using AES-256 CBC.
`ENCRYPTION_PASSWORD` | | Set a password to encrypt (and decrypt) files with.
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
`prune` | Prunes old backups from the backup location.
`restore` | Restores all volumes to their latest backups.
`restore <volume>` | Restores the latest backup of the provided volume name.
`restore <backup filename>` | Restores a specific backup to its associated volume.
