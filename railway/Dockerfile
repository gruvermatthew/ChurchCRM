# Railway deployment of ChurchCRM.
#
# Wraps the official, published ChurchCRM release image (the source in this
# repository is not compiled here; the release image already contains the
# built application). Version is pinned; bump it deliberately to upgrade.
FROM churchcrm/crm:7.8.3-php8-apache

USER root

# mod_php needs the prefork MPM; make sure it is the only MPM enabled
# (Apache refuses to start with "More than one MPM loaded" otherwise).
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf && \
    a2enmod mpm_prefork >/dev/null && \
    apache2ctl -t

# Config.php reads database credentials and the public URL from environment
# variables, so the setup wizard is not needed and a redeploy never resets it.
COPY --chown=33:33 railway/Config.php /var/www/html/Include/Config.php

# Railway allows one volume per service. Mount it at /data and point both
# photo directories at it. The original .htaccess files (which deny direct
# HTTP access to photos) are kept and re-copied on every start.
RUN mkdir -p /opt/churchcrm-defaults/Person /opt/churchcrm-defaults/Family && \
    cp -a /var/www/html/Images/Person/. /opt/churchcrm-defaults/Person/ && \
    cp -a /var/www/html/Images/Family/. /opt/churchcrm-defaults/Family/ && \
    rm -rf /var/www/html/Images/Person /var/www/html/Images/Family && \
    ln -s /data/Person /var/www/html/Images/Person && \
    ln -s /data/Family /var/www/html/Images/Family

COPY railway/security.conf /etc/apache2/conf-enabled/zz-railway-security.conf
COPY railway/php-security.ini /usr/local/etc/php/conf.d/zz-railway-security.ini
RUN a2enmod headers >/dev/null

COPY railway/entrypoint.sh /usr/local/bin/churchcrm-railway-entrypoint
RUN chmod 0755 /usr/local/bin/churchcrm-railway-entrypoint

# Apache starts as root (to fix volume ownership) and serves requests as
# www-data, as in the standard php:apache image.
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/churchcrm-railway-entrypoint"]
CMD ["apache2-foreground"]
