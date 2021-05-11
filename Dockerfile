FROM ubuntu:18.04

ENV RUN_AS_USER=docker-backup
ENV APP_PATH=/home/${RUN_AS_USER} \
  LOG_PATH=/var/log/output.log \
  VOLUME_PATH=/volumes \
  BACKUP_PATH=/backup \
  LTS_PATH=/lts \
  PATH=${PATH}:/home/${RUN_AS_USER}/.local/bin
RUN apt-get update \
  && apt-get install -y \
    cksfv \
    cron \
    curl \
    p7zip \
    rar \
    sudo \
    tzdata \
    unrar \
    uuid-runtime \
    zip \
  && curl -sSL https://get.docker.com/ | sh \
  && rm -rf /var/lib/apt/lists/* \
  && adduser --disabled-password --gecos "" ${RUN_AS_USER} \
  && adduser ${RUN_AS_USER} docker \
  && adduser ${RUN_AS_USER} sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY lib ${APP_PATH}
RUN mkdir -p /home/${RUN_AS_USER}/.local/bin ${VOLUME_PATH} ${BACKUP_PATH} ${LTS_PATH} \
  && ln -s ${APP_PATH}/backup.sh /home/${RUN_AS_USER}/.local/bin/backup \
  && ln -s ${APP_PATH}/restore.sh /home/${RUN_AS_USER}/.local/bin/restore \
  && ln -s ${APP_PATH}/store.sh /home/${RUN_AS_USER}/.local/bin/store \
  && ln -s ${APP_PATH}/prune.sh /home/${RUN_AS_USER}/.local/bin/prune \
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
  PROJECT_NAME= \
  PAUSE_CONTAINERS= \
  TZ=UTC

CMD ["sh", "-c", "${APP_PATH}/entrypoint.sh"]
