# ChurchCRM on Railway

Railway builds `railway/Dockerfile` (set as the service's Dockerfile path),
which wraps the official `churchcrm/crm` release image.

Service variables:

| Variable | Value |
| --- | --- |
| `CHURCHCRM_DB_HOST` | `${{MySQL.MYSQLHOST}}` |
| `CHURCHCRM_DB_PORT` | `${{MySQL.MYSQLPORT}}` |
| `CHURCHCRM_DB_USER` | `${{MySQL.MYSQLUSER}}` |
| `CHURCHCRM_DB_PASSWORD` | `${{MySQL.MYSQLPASSWORD}}` |
| `CHURCHCRM_DB_NAME` | `${{MySQL.MYSQLDATABASE}}` |
| `CHURCHCRM_URL` | `https://<public domain>/` (trailing slash required) |
| `PORT` | `8080` |
| `CHURCHCRM_TRUSTED_PROXIES` | `100.64.0.0/10` (Railway edge, so session cookies get the Secure flag) |

A volume mounted at `/data` holds person and family photos. The database
schema is installed automatically on first boot when the database is empty.

To upgrade, change the image tag at the top of `railway/Dockerfile` after
backing up the MySQL database.

`security.conf` and `php-security.ini` harden the public site: no directory
listings or version banners, `/mysql` blocked, HSTS on HTTPS requests.
