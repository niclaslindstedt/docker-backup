FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install -y \
    cifs-utils \
    cksfv \
    cron \
    curl \
  && curl -sSL https://get.docker.com/ | sh
ENV APP_PATH=/usr/local/lib/docker-backup
COPY lib/* $APP_PATH/
RUN ln -s $APP_PATH/backup.sh /usr/local/bin/backup \
  && ln -s $APP_PATH/restore.sh /usr/local/bin/restore \
  && ln -s $APP_PATH/store.sh /usr/local/bin/store \
  && ln -s $APP_PATH/purge.sh /usr/local/bin/purge

ENV LOG_PATH=/var/log/output.log \
  VOLUME_PATH=/volumes \
  BACKUP_PATH=/backup \
  LTS_PATH=/lts \
  ENABLE_LTS=true \
  ENABLE_PURGE=true \
  CRON_BACKUP="0 5 * * *" \
  CRON_LTS="0 9 * * *" \
  CRON_PURGE="0 3 * * *" \
  KEEP_BACKUPS_FOR_DAYS=30 \
  KEEP_LTS_FOR_MONTHS=6 \
  KEEP_DAILY_AFTER_HOURS=24 \
  KEEP_WEEKLY_AFTER_DAYS=14 \
  KEEP_MONTHLY_AFTER_WEEKS=4 \
  MINIMUM_FREE_SPACE=30 \
  CREATE_CHECKSUMS=true \
  VERIFY_CHECKSUMS=true \
  DOCKER_STOP_TIMEOUT=30 \
  PROJECT_NAME= \
  STOP_CONTAINERS=

ENTRYPOINT ["sh", "-c", "$APP_PATH/entrypoint.sh"]
