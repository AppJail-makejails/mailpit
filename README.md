# Mailpit

Mailpit is a multi-platform email testing tool & API for developers.

It acts as both an SMTP server, and provides a web interface to view all captured emails.

mailpit.axllent.org

<img src="https://camo.githubusercontent.com/5c194f92f50b12496a8836090aba2dbcff5379937606f4fa220490610c4a8d14/68747470733a2f2f696d6775722e636f6d2f57576d467349302e706e67" width="30%" height="auto" alt="Mailpit logo">

## How to use this Makejail

### Standalone

A basic example of running Mailpit within AppJail:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=8025:8025 \
    -o expose=1025:1025 \
    ghcr.io/appjail-makejails/mailpit mailpit
```

You need to ensure you map the correct ports (default Web UI on 8025 and SMTP on 1025).

### Setting Mailpit options

View all [runtime options](https://mailpit.axllent.org/docs/configuration/runtime-options/) (flags & environment variables). Environment variables can be set using the `-e` flag when starting your container, for instance:

```console
$ mkdir -p /var/appjail-volumes/mailpit/data
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/var/appjail-volumes/mailpit/data /data" \
    -e MP_DATABASE="/data/mailpit.db" \
    -e MP_UI_AUTH_FILE="/data/authfile" \
    -e TZ=America/Caracas \
    ghcr.io/appjail-makejails/mailpit mailpit
```

### AppJail Director example

The following example exposes both the web UI port (8025) and SMTP port (1025) to external hosts. If your `appjail-director.yml` is running multi-container applications and does not require (for instance) 1025 to be open to the host, then you can omit - `expose: '1025:1025'` which will then only expose it to the other containers.

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  mailpit:
    name: mailpit
    makejail: gh+AppJail-makejails/mailpit
    volumes:
      - data: /data
    options:
      - expose: '8025:8025'
      - expose: '1025:1025'
      - container: 'args:--pull'
    oci:
      environment:
        - MP_MAX_MESSAGES: 5000
        - MP_DATABASE: /data/mailpit.db
        - MP_SMTP_AUTH_ACCEPT_ANY: 1
        - MP_SMTP_AUTH_ALLOW_INSECURE: 1

volumes:
  data:
    device: /var/appjail-volumes/mailpit/data
```

### Arguments (stage: build)

* `mailpit_from` (default: `ghcr.io/appjail-makejails/mailpit`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `mailpit_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-263aca83a3-data | `${PUID}` | `${PGID}` | - | - | /data |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
