# Docker Backup

[![Docker Pulls](https://img.shields.io/docker/pulls/niclaslindstedt/docker-backup)](https://hub.docker.com/r/niclaslindstedt/docker-backup)
[![GitHub Repo stars](https://img.shields.io/github/stars/niclaslindstedt/docker-backup)](https://github.com/niclaslindstedt/docker-backup/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/niclaslindstedt/docker-backup)](https://github.com/niclaslindstedt/docker-backup/issues)
[![Tests](https://github.com/niclaslindstedt/docker-backup/actions/workflows/test.yml/badge.svg)](https://github.com/niclaslindstedt/docker-backup/actions/workflows/test.yml)
[![CD](https://github.com/niclaslindstedt/docker-backup/actions/workflows/cd.yml/badge.svg)](https://github.com/niclaslindstedt/docker-backup/actions/workflows/cd.yml)

Backup your Docker volumes and/or data folders and store them both short-term and long-term. Prune unwanted backups according to precise pruning settings, or when free space gets tight.

**CAUTION: Do not use this for production environments. It has not been thorougly tested yet.**

## Features

- Backup any Docker volume or folder on your host machine.
- Easily restore backups with one command.
- Encrypt your backups for safe storage in the cloud.
- Verify your backups' integrity with sfv checksums.
- Cron scheduling for precise backup schedules.
- Pause your other Docker containers during backup/restoration to prevent invalid states
  - Note: _This is only supported on the `-docker` tagged images._

## Instructions

1. Mount all volumes you want backed up in `/volumes`
2. Mount the short-term backup location in `/backup`
3. Mount the long-term storage location in `/lts`

See the [Use cases wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Use-cases) for more advanced use cases.

## Getting help

See the [Frequently asked questions wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Frequently-asked-questions) for a list of common questions.

Ask questions in the [Discussions](https://github.com/niclaslindstedt/docker-backup/discussions) section if your question hasn't been answered in the FAQ.

## Environment variables

| Variable                     | Default     | Description                                                                                                                      |
| ---------------------------- | ----------- | -------------------------------------------------------------------------------------------------------------------------------- |
| `ENABLE_LTS`                 | `true`      | Set to 'false' to disable long-term storage.                                                                                     |
| `ENABLE_PRUNE`               | `true`      | Set to 'false' to disable purging of old backups.                                                                                |
| `CRON_BACKUP`                | `0 5 * * *` | Cron schedule for creating backups of all volumes.                                                                               |
| `CRON_LTS`                   | `0 9 * * *` | Cron schedule for copying backups to the long-term storage folder.                                                               |
| `CRON_PRUNE`                 | `0 3 * * *` | Cron schedule for pruning backups.                                                                                               |
| `VERBOSE`                    | `false`     | Set to 'true' to enable extra verbose logging.                                                                                   |
| `ARCHIVE_TYPE`               | `tgz`       | Use this archive type for storage, one of: `tgz` `zip` `rar` `7z`                                                                |
| `ENCRYPT_ARCHIVES`           | `false`     | Encrypt archives after compressing them.                                                                                         |
| `ENCRYPTION_PASSWORD`        |             | Set a password (symmetric key) to encrypt (and decrypt) files with.                                                              |
| `ENCRYPT_ALGORITHM`          | `AES256`    | The encryption algorithm used when encrypting backups, one of: `IDEA` `CAST5` `BLOWFISH` `AES256` `TWOFISH` `CAMELLIA256`.       |
| `SKIP_PASSWORD_LENGTH_CHECK` | `false`     | Skips the password length control on startup. Don't use this in production environments.                                         |
| `KEEP_BACKUPS_FOR_DAYS`      | `30`        | Set to how many days you want to keep backups in the short-term backup folder.                                                   |
| `KEEP_LTS_FOR_MONTHS`        | `6`         | Set to how long you want to keep long-term storage backups.                                                                      |
| `KEEP_DAILY_AFTER_HOURS`     | `24`        | The breakpoint (in hours) for when hourly backups turn into daily.                                                               |
| `KEEP_WEEKLY_AFTER_DAYS`     | `14`        | The breakpoint (in days) for when daily backups turn into weekly.                                                                |
| `KEEP_MONTHLY_AFTER_WEEKS`   | `4`         | The breakpoint (in weeks) for when weekly backups turn into monthly.                                                             |
| `MINIMUM_FREE_SPACE`         | `30`        | Set to how many gigabytes of storage you want to keep free.                                                                      |
| `CREATE_CHECKSUMS`           | `true`      | Set to 'false' to disable creation of checksums (sfv).                                                                           |
| `VERIFY_CHECKSUMS`           | `true`      | Set to 'false' to disable checksum (sfv) verification before restoring a backup and after copying a backup to long-term storage. |
| `LOCK_TIMEOUT`               | `600`       | How long the scripts should wait for other scripts to finish before giving up.                                                   |
| `PROJECT_NAME`               |             | The name of the project folder (used for naming containers with docker-compose).                                                 |
| `PAUSE_CONTAINERS`           |             | The names of the containers that should be stopped before backing up & restoring. Comma-separated list.                          |
| `TZ`                         | UTC         | The timezone used for setting timestamps (and comparing times) on backups.                                                       |

See the [Environment variables wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Environment-variables) for a full list of environment variables, and more information about them.

## Commands

You can use `docker-compose exec backup <command>` to run the following commands inside the container:

| Command                      | Description                                                  |
| ---------------------------- | ------------------------------------------------------------ |
| `backup [volume]`            | Creates backups of all (or specific) volumes.                |
| `store`                      | Copies the latest backups to the long-term storage location. |
| `prune`                      | Prunes old backups to save disk space.                       |
| `restore [volume \| backup]` | Restores volumes to their latest (or a specific) backup.     |

See the [Commands wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Commands) for a full list of commands, and more information about them.

## Contributing

Submit a [pull request](https://github.com/niclaslindstedt/docker-backup/pulls)! See the [Development wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Development) for information on how to get started with development.

If you're not a developer, you are more than welcome to [submit an issue](https://github.com/niclaslindstedt/docker-backup/issues/new) with a feature request or bug report.
