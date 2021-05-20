# Docker Backup

[![Docker Pulls](https://img.shields.io/docker/pulls/niclaslindstedt/docker-backup)](https://hub.docker.com/r/niclaslindstedt/docker-backup)
[![GitHub Repo Stars](https://img.shields.io/github/stars/niclaslindstedt/docker-backup)](https://github.com/niclaslindstedt/docker-backup/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/niclaslindstedt/docker-backup)](https://github.com/niclaslindstedt/docker-backup/issues)
[![Tests](https://github.com/niclaslindstedt/docker-backup/actions/workflows/test.yml/badge.svg)](https://github.com/niclaslindstedt/docker-backup/actions/workflows/test.yml)
[![Release](https://github.com/niclaslindstedt/docker-backup/actions/workflows/release.yml/badge.svg)](https://github.com/niclaslindstedt/docker-backup/actions/workflows/release.yml)

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

For a list of commands, see the [Commands wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Commands).

See the [Use cases wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Use-cases) for more advanced use cases.

## Getting help

See the [Frequently asked questions wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Frequently-asked-questions) for a list of common questions.

Ask questions in the [Discussions](https://github.com/niclaslindstedt/docker-backup/discussions) section if your question hasn't been answered in the FAQ.

## Contributing

Submit a [pull request](https://github.com/niclaslindstedt/docker-backup/pulls)! See the [Development wiki page](https://github.com/niclaslindstedt/docker-backup/wiki/Development) for information on how to get started with development.

If you're not a developer, you are more than welcome to [submit an issue](https://github.com/niclaslindstedt/docker-backup/issues/new) with a feature request or bug report.
