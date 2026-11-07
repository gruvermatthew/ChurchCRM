#!/bin/sh
set -e

# Railway's runtime can resurrect module symlinks that earlier image layers
# deleted, leaving mpm_event enabled next to mpm_prefork. mod_php needs
# prefork only, so enforce that on every start.
for m in mpm_event mpm_worker; do
  rm -f "/etc/apache2/mods-enabled/$m.load" "/etc/apache2/mods-enabled/$m.conf"
done
[ -e /etc/apache2/mods-enabled/mpm_prefork.load ] || a2enmod mpm_prefork >/dev/null

for d in Person Family; do
  mkdir -p "/data/$d"
  cp -a "/opt/churchcrm-defaults/$d/." "/data/$d/"
done
chown -R 33:33 /data

exec docker-php-entrypoint "$@"
