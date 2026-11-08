#!/bin/sh
set -e

# Railway's runtime can resurrect module symlinks that earlier image layers
# deleted, leaving mpm_event enabled next to mpm_prefork. mod_php needs
# prefork only, so enforce that on every start.
for m in mpm_event mpm_worker; do
  rm -f "/etc/apache2/mods-enabled/$m.load" "/etc/apache2/mods-enabled/$m.conf"
done
[ -e /etc/apache2/mods-enabled/mpm_prefork.load ] || a2enmod mpm_prefork >/dev/null
for m in headers remoteip; do
  [ -e "/etc/apache2/mods-enabled/$m.load" ] || a2enmod "$m" >/dev/null
done
# Apache builds its own redirects (e.g. /admin -> /admin/) from ServerName.
# Without it they point at the container's internal http://...:8080 address.
host=$(printf '%s' "${CHURCHCRM_URL:-}" | sed -E 's#^https?://([^/:]+).*#\1#')
# The virtual host takes its port from <VirtualHost *:8080>, so it is set there.
if [ -n "$host" ]; then
  sed -i -e '/^\tServerName https:\/\//d' -e '/^\tUseCanonicalName On$/d' \
    -e "s|^<VirtualHost \*:8080>\$|&\\n\\tServerName https://$host:443\\n\\tUseCanonicalName On|" \
    /etc/apache2/sites-available/000-default.conf
fi
apache2ctl -t

for d in Person Family; do
  mkdir -p "/data/$d"
  cp -a "/opt/churchcrm-defaults/$d/." "/data/$d/"
done
chown -R 33:33 /data

exec docker-php-entrypoint "$@"
