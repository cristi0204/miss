# MISP Docker image

[MISP](https://github.com/misp/misp/) container (Docker) image focused on high performance and security based on CentOS Stream 8.

This image contains the latest version of MISP and the required dependencies. Image is intended as immutable, which means that it is not possible
to update MISP from the user interface and instead, an admin should download a newer image.

## Why to use this image?

* ✅ Image is based on CentOS 8 Stream, so perfectly fits your infrastructure if you use CentOS or RHEL as a host system
* ✅ Modern MISP features are enabled by default (like advanced audit log or storing setting in the database)
* ✅ Integrated support for OpenID Connect (OIDC) authentication
* ✅ PHP is by default protected by Snuffleupagus extensions with [rules](snuffleupagus-misp.rules) tailored to MISP
* ✅ Optional extensions and configurations that will make MISP faster are enabled
* ✅ Integrated support for logging exceptions to Sentry and forwarding logs to syslog server
* ✅ Final image is automatically tested, so every release should work as expected
 
## Usage

First, you have to install Docker. Follow [these manuals](https://docs.docker.com/engine/install/) how to install Docker on your machine. Windows, macOS, or Linux are supported.

### Usage for testing

Docker Compose file defines MISP itself, [MISP Modules](https://github.com/NUKIB/misp-modules), MariaDB and Redis, so everything you need to run MISP. Just run:

    curl --proto '=https' --tlsv1.2 -O https://raw.githubusercontent.com/NUKIB/misp/main/docker-compose.yml
    docker compose up -d

Then you can access MISP in your browser by accessing `http://localhost:8080`. Default user after installation is `admin@admin.test` with password `admin`.

### Updating

When a new MISP is released, also new container image is created. For updating MISP and MISP Modules, just run these commands in the folder that contains `docker-compose.yml` file.
These commands will download the latest images and recreate containers:

    docker compose pull
    docker compose up -d

### Usage in a production environment

For production usage, please:
* change passwords for MariaDB and Redis,
* modify environment variables to requested values,
* set volumes location, so stored files will survive,
* deploy reverse proxy (for example `nginx`) before MISP to handle HTTPS connections.

### Usage in air-gapped environment

MISP by default does not require access to Internet. So it is possible to use MISP in air-gapped environment or with blocked outgoing connections. Easies way how to
do that is export container images to compressed tar and transfer them to air-gapped system.

### Image building

If you don't trust image built by GitHub Actions and stored in GitHub Container Registry or you want to build a different MISP version, you can build this image by yourself:

    docker build --build-arg MISP_VERSION=v2.4.152 -t ghcr.io/nukib/misp https://github.com/NUKIB/misp.git#main

If you don't like CentOS Stream, you can use as a base image different distribution that is compatible with CentOS, like [AlmaLinux](https://hub.docker.com/_/almalinux) or [Rocky Linux](https://hub.docker.com/r/rockylinux/rockylinux):

    docker build --build-arg BASE_IMAGE=almalinux -t ghcr.io/nukib/misp https://github.com/NUKIB/misp.git#main

### Automation

Automation tasks are run by [jobber](https://github.com/dshearer/jobber) application, which is managed by `supervisor`. Check `.jobber` file for tasks definition.

Default tasks:
* `CacheFeeds` - cache feeds with caching enabled every day at 7, 9, 11, 13, 15, 17, 19
* `FetchFeeds` - fetch enabled feeds every day at 7, 9, 11, 13, 15, 17, 19
* `PullServers` - pull events from remote servers every day at 7, 11, 16
* `ScanAttachment` - every day at 6
* `LogRotate` - rotate logs every day at 5

## Environment variables

By changing or defining these container environment variables, you can change container behavior.

### Database connection

MISP requires MySQL or MariaDB database.

* `MYSQL_HOST` (required, string)
* `MYSQL_LOGIN` (required, string) - database user
* `MYSQL_PASSWORD` (optional, string)
* `MYSQL_DATABASE` (required, string) - database name

### Redis

By default, MISP requires Redis. MISP will connect to Redis defined in `REDIS_HOST` variable on port `6379`.

* `REDIS_HOST` (required, string)
* `REDIS_PASSWORD` (optional, string)

#### Default Redis databases

* `10` - ZeroMQ connector
* `11` - SimpleBackgroundJobs
* `12` - session data if `PHP_SESSIONS_IN_REDIS` is enabled
* `13` - MISP app

### E-mail setting

* `SMTP_HOST` (optional, string) - SMTP server that will be used for sending e-mails
* `SMTP_USERNAME` (optional, string)
* `SMTP_PASSWORD` (optional, string)
* `MISP_EMAIL` (required, string) - the e-mail address that MISP should use for all notifications
* `MISP_EMAIL_REPLY_TO` (optional, string) - the e-mail address that will be used in `Reply-To` header

### PGP for e-mail encryption and signing

* `GNUPG_SIGN` (optional, boolean, default `false`) - sign outgoing e-mails by PGP
* `GNUPG_PRIVATE_KEY_PASSWORD` (optional, string) - password for PGP key that is used to sign e-mails send by MISP
* `GNUPG_BODY_ONLY_ENCRYPTED` (optional, boolean, default `false`)

If you want to generate new PGP keys for e-mail signing, you can do it by running this command inside the container:

    gpg --homedir /var/www/MISP/.gnupg --full-generate-key --pinentry-mode=loopback --passphrase "password"

### Application

* `MISP_BASEURL` (required, string) - whole URL with https:// or http://
* `MISP_UUID` (required, string) - MISP instance UUID (can be generated by `uuidgen` command)
* `MISP_ORG` (required, string) - MISP default organisation name
* `MISP_HOST_ORG_ID` (optional, int, default `1`) - MISP default organisation ID
* `MISP_MODULE_URL` (optional, string) - URL to MISP modules
* `MISP_DEBUG` (optional, boolean, default `false`) - enable debug mode (do not enable on production environment)

### Security

* `SECURITY_SALT` (required, string) - random string (recommended at least 32 chars) used for salting hashed values (you can use `openssl rand -base64 32` output)
* `SECURITY_ADVANCED_AUTHKEYS` (optional, boolean, default `false`) - enable advanced auth keys support
* `SECURITY_HIDE_ORGS` (optional, boolean, default `false`) - hide org names for normal users
* `SECURITY_ENCRYPTION_KEY` (optional, string) - encryption key with at least 32 chars that will be used to encrypt sensitive information stored in database

### Outgoing proxy

For pulling events from another MISP or fetching feeds MISP requires access to Internet. Set these variables to use HTTP proxy for outgoing connections from MISP.

* `PROXY_HOST` (optional, string) - The hostname of an HTTP proxy for outgoing sync requests. Leave empty to not use a proxy.
* `PROXY_PORT` (optional, int) - The TCP port for the HTTP proxy.
* `PROXY_METHOD` (optional, string) - The authentication method for the HTTP proxy. Currently, supported are Basic or Digest. Leave empty for no proxy authentication.
* `PROXY_USER` (optional, string) - The authentication username for the HTTP proxy.
* `PROXY_PASSWORD` (optional, string) - The authentication password for the HTTP proxy.

### OpenID Connect (OIDC) login

This Docker image is prepared to use OIDC for login into MISP. To enhance security, OIDC is implemented right into Apache by [mod_auth_openidc](https://github.com/zmartzone/mod_auth_openidc) and then in MISP itself.   
That means that unauthenticated users will stop right on Apache.

If a request to MISP is made with  `Authorization` header, that contains an authentication key in MISP format, OIDC is not used. Instead, Apache checks if a key is valid.

* `OIDC_LOGIN` (optional, bool, default `false`)
* `OIDC_PROVIDER` (optional, string) - URL for OIDC provider in Apache
* `OIDC_CLIENT_ID` (optional, string)
* `OIDC_CLIENT_SECRET` (optional, string)
* `OIDC_PASSWORD_RESET` (optional, string) - URL to password reset page
* `OIDC_CLIENT_CRYPTO_PASS` (optional, string) - password for cookie encryption used by Apache
* `OIDC_DEFAULT_ORG` (optional, bool, default `false`) - for new user without use `MISP_ORG`

#### Inner

You can use a different provider for authentication in MISP. If you don't provide these variables, they will be set to the same as for Apache.

* `OIDC_PROVIDER_INNER` (optional, string) - URL for OIDC provider in MISP
* `OIDC_CLIENT_ID_INNER` (optional, string)
* `OIDC_CLIENT_SECRET_INNER` (optional, string)

### Sentry

[Sentry](https://sentry.io/) is a tool for error tracking and support for this tool is integrated into this image. If configured, unhandled exceptions will be logged in Sentry.

* `SENTRY_DSN` (optional, string) - Sentry DSN to catch exceptions
* `SENTRY_ENVIRONMENT` (optional, string) - Sentry environment

### ZeroMQ

* `ZEROMQ_ENABLED` (optional, boolean, default `false`) - enable ZeroMQ integration, server will listen at `*:50000`
* `ZEROMQ_USERNAME` (optional, string) - ZeroMQ username
* `ZEROMQ_PASSWORD` (optional, string) - ZeroMQ password

### PHP config

* `PHP_SESSIONS_IN_REDIS` (optional, boolean, default `true`) - when enabled, sessions information are stored in Redis. That provides better performance and sessions survives container restart
* `PHP_SNUFFLEUPAGUS` (optional, boolean, default `true`) - enable PHP hardening by using [Snuffleupagus](https://snuffleupagus.readthedocs.io) PHP extension
* `PHP_TIMEZONE` (optional, string, default `UTC`) - sets [date.timezone](https://www.php.net/manual/en/datetime.configuration.php#ini.date.timezone)
* `PHP_MEMORY_LIMIT` (optional, string, default `2048M`) - sets [memory_limit](https://www.php.net/manual/en/ini.core.php#ini.memory-limit)
* `PHP_MAX_EXECUTION_TIME` (optional, int, default `300`) - sets [max_execution_time](https://www.php.net/manual/en/info.configuration.php#ini.max-execution-time) (in seconds)
* `PHP_UPLOAD_MAX_FILESIZE` (optional, string, default `50M`) - sets [upload_max_filesize](https://www.php.net/manual/en/ini.core.php#ini.upload-max-filesize) and [post_max_size](https://www.php.net/manual/en/ini.core.php#ini.post-max-size)
* `PHP_XDEBUG_ENABLED` (optional, boolean, default `false`) - enable [Xdebug](https://xdebug.org) PHP extension for debugging purposes (do not enable on production environment)
* `PHP_XDEBUG_PROFILER_TRIGGER` (optional, string) - secret value for `XDEBUG_PROFILE` GET/POST variable

### Syslog

If enabled, all logs from the container are forwarded to a defined syslog server.

* `SYSLOG_TARGET` (optional, string)
* `SYSLOG_PORT` (optional, integer, default `601`)
* `SYSLOG_PROTOCOL` (optional, string, default `tcp`)

## Log locations

* `/var/log/messages` - all logs captured by rsyslog (see `rsyslog.conf` for definition)
* `/var/log/httpd/` - Apache logs
* `/var/log/php-fpm/` - PHP-FPM logs
* `/var/www/MISP/app/tmp/logs/` - application logs (PHP)

`X-Request-ID` HTTP header is logged in Apache, PHP-FPM and Sentry logs, so you can use this value to correlate requests between logs.

## Container volumes

* `/var/www/MISP/app/tmp/logs/` - application logs
* `/var/www/MISP/app/files/certs/` - uploaded certificates used for accessing remote feeds and servers
* `/var/www/MISP/app/attachments/` - uploaded attachments and malware samples
* `/var/www/MISP/.gnupg/` - GPG homedir

## License

This software is licensed under GNU General Public License version 3. MISP is licensed under GNU Affero General Public License version 3.

* Copyright (C) 2022 [National Cyber and Information Security Agency of the Czech Republic (NÚKIB)](https://www.nukib.cz/en/)
