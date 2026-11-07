#!/bin/sh
set -e
for d in Person Family; do
  mkdir -p "/data/$d"
  cp -a "/opt/churchcrm-defaults/$d/." "/data/$d/"
done
chown -R 33:33 /data
exec docker-php-entrypoint "$@"
