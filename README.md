# Docker Backup

Use this in your compose file to backup your volumes.

1. Mount all volumes you want backed up in `/volumes`
2. Mount the backup location in `/backup`
3. Mount the long-term storage in `/lts`

The backup location is the temporary place for backups, intended for
storing _all_ backups for a certain period of time. When the backups
start getting old, they will be copied to the long-term storage, and
the backup location will be purged of old files.

## Commands

You can use `docker exec` to run the following scripts inside the container:

Script | Description
--- | ---
`backup` | Backs up everything in the volume location to the backup location.
`store` | Copies backups to the long-term storage location.
`purge` | Purges old backups from the backup location.
`restore` | Restores the newest backup of the provided volume name.

The restore script takes an argument that should equal the volume name (folder name) of the volume you want to restore. E.g. if you have mounted a volume at `/volumes/anexample` you should type `docker-compose exec backup restore anexample` to restore it.

The store script will copy the *latest* backup of each volume to the long-term storage.
