FROM ubuntu:18.04

ENV RUN_AS_USER=docker-backup
RUN apt-get update \
  && apt-get install -y \
    cksfv \
    cron \
    curl \
    gnupg2 \
    p7zip \
    rar \
    sudo \
    tzdata \
    unrar \
    uuid-runtime \
    zip \
  && rm -rf /var/lib/apt/lists/* \
  && adduser --disabled-password --gecos "" ${RUN_AS_USER} \
  && adduser ${RUN_AS_USER} sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ARG INSTALL_DOCKER=true
RUN [ "$INSTALL_DOCKER" = "true" ] && curl -sSL https://get.docker.com/ | sh \
  && rm -rf /var/lib/apt/lists/* \
  && adduser ${RUN_AS_USER} docker \
  ; exit 0
ENV APP_PATH=/home/${RUN_AS_USER} \
  LOG_PATH=/var/log/output.log \
  VOLUME_PATH=/volumes \
  BACKUP_PATH=/backup \
  LTS_PATH=/lts \
  TMP_PATH=/tmp/backup \
  GPG_PATH=/gpg \
  FILELOCK_PATH=/var/lock/backup.lock \
  PATH=${PATH}:/home/${RUN_AS_USER}/.local/bin
COPY lib ${APP_PATH}
RUN mkdir -p /home/${RUN_AS_USER}/.local/bin ${VOLUME_PATH} ${BACKUP_PATH} ${LTS_PATH} ${TMP_PATH} ${GPG_PATH} \
  && ln -s ${APP_PATH}/backup.sh /home/${RUN_AS_USER}/.local/bin/backup \
  && ln -s ${APP_PATH}/restore.sh /home/${RUN_AS_USER}/.local/bin/restore \
  && ln -s ${APP_PATH}/store.sh /home/${RUN_AS_USER}/.local/bin/store \
  && ln -s ${APP_PATH}/prune.sh /home/${RUN_AS_USER}/.local/bin/prune \
  && touch ${LOG_PATH} \
  && chown -R ${RUN_AS_USER}:${RUN_AS_USER} ${APP_PATH} ${LOG_PATH} ${VOLUME_PATH} ${BACKUP_PATH} ${LTS_PATH} ${TMP_PATH} ${GPG_PATH}
USER ${RUN_AS_USER}

ENV ENABLE_LTS=true \
  ENABLE_PRUNE=true \
  CRON_BACKUP="0 5 * * *" \
  CRON_LTS="0 9 * * *" \
  CRON_PRUNE="0 3 * * *" \
  LOG_LEVEL=2 \
  DEBUG=false \
  ASSUME_YES=false \
  ARCHIVE_TYPE="tgz" \
  ENCRYPT_ARCHIVES=false \
  ENCRYPTION_PASSPHRASE= \
  ENCRYPTION_ALGORITHM=AES256 \
  VERIFY_ENCRYPTION=false \
  SKIP_PASSPHRASE_LENGTH_CHECK=false \
  CREATE_SIGNATURES=false \
  VERIFY_SIGNATURES=false \
  SIGNING_KEY=signing_key.asc \
  SIGNING_PASSPHRASE= \
  GENERATE_GPG_KEY=false \
  GPG_KEY_NAME=docker-backup \
  GPG_KEY_EMAIL=docker.backup@example.com \
  GPG_KEY_LENGTH=2048 \
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
  LOCK_TIMEOUT=600 \
  TZ=UTC

CMD ["sh", "-c", "${APP_PATH}/entrypoint.sh"]
