FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install -y curl \
  && curl -sSL https://get.docker.com/ | sh
RUN apt-get install -y \
    cksfv \
    cron \
    curl \
    p7zip \
    rar \
    unrar \
    zip \
  && rm -rf /var/lib/apt/lists/*
ARG RUN_AS_USER=docker-backup
RUN adduser --disabled-password --gecos "" ${RUN_AS_USER} \
  && adduser ${RUN_AS_USER} docker
ENV APP_PATH=/home/${RUN_AS_USER} \
  LOG_PATH=/var/log/output.log \
  VOLUME_PATH=/volumes \
  BACKUP_PATH=/backup \
  LTS_PATH=/lts
ENV PATH=${PATH}:/home/${RUN_AS_USER}/.local/bin
COPY lib ${APP_PATH}
RUN mkdir -p /home/${RUN_AS_USER}/.local/bin ${VOLUME_PATH} ${BACKUP_PATH} ${LTS_PATH} \
  && ln -s ${APP_PATH}/backup.sh /home/${RUN_AS_USER}/.local/bin/backup \
  && ln -s ${APP_PATH}/restore.sh /home/${RUN_AS_USER}/.local/bin/restore \
  && ln -s ${APP_PATH}/store.sh /home/${RUN_AS_USER}/.local/bin/store \
  && ln -s ${APP_PATH}/prune.sh /home/${RUN_AS_USER}/.local/bin/prune \
  && ln -s ${APP_PATH}/test.sh /home/${RUN_AS_USER}/.local/bin/test \
  && chmod -R +x ${APP_PATH} \
  && touch ${LOG_PATH} \
  && chown -R ${RUN_AS_USER}:${RUN_AS_USER} ${APP_PATH} ${LOG_PATH} ${VOLUME_PATH} ${BACKUP_PATH} ${LTS_PATH}
USER ${RUN_AS_USER}

ENV ENABLE_LTS=true \
  ENABLE_PRUNE=true \
  CRON_BACKUP="0 5 * * *" \
  CRON_LTS="0 9 * * *" \
  CRON_PRUNE="0 3 * * *" \
  VERBOSE=false \
  DEBUG=false \
  ASSUME_YES=false \
  ARCHIVE_TYPE="tgz" \
  ENCRYPT_ARCHIVES=false \
  ENCRYPTION_PASSWORD= \
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

CMD ["sh", "-c", "${APP_PATH}/entrypoint.sh"]
