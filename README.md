# Mailpit

Mailpit is a small, fast, low memory, zero-dependency, multi-platform email testing tool & API for developers.

It acts as an SMTP server, provides a modern web interface to view & test captured emails, and contains an API for automated integration testing.

mailpit.axllent.org

<img src="https://imgur.com/WWmFsI0.png" width="80%" height="auto">

## Features

* Runs entirely from a single [static binary](https://mailpit.axllent.org/docs/install/)
* Modern web UI to view emails (formatted HTML, highlighted HTML source, text, headers, raw source, and MIME attachments
including image thumbnails), including optional [HTTPS](https://mailpit.axllent.org/docs/configuration/https/)
* Optional [basic authentication](https://mailpit.axllent.org/docs/configuration/frontend-authentication/) for web UI & API
* [HTML check](https://mailpit.axllent.org/docs/usage/html-check/) to test & score mail client compatibility with HTML emails
* [Link check](https://mailpit.axllent.org/docs/usage/link-check/) to test message links (HTML & text) & linked images
* [Create screenshots](https://mailpit.axllent.org/docs/usage/html-screenshots/) of HTML messages via web UI
* Mobile and tablet HTML preview toggle in desktop mode
* Advanced [mail search](https://mailpit.axllent.org/docs/usage/search-filters/)
* [Message tagging](https://mailpit.axllent.org/docs/usage/tagging/)
* Real-time web UI updates using web sockets for new mail & optional browser notifications for new mail (when accessed
via either HTTPS or `localhost` only)
* SMTP server with optional [STARTTLS & SMTP authentication](https://mailpit.axllent.org/docs/configuration/smtp-authentication/) (including an
"accept any" mode)
* [SMTP relaying](https://mailpit.axllent.org/docs/configuration/smtp-relay/) (message release) - relay messages via a different SMTP server
including an optional allowlist of accepted recipients
* Fast SMTP processing & storing - approximately 70-100 emails per second depending on CPU, network speed & email size,
easily handling tens of thousands of emails
* Configurable automatic email pruning (default keeps the most recent 500 emails)
* A simple [REST API](https://mailpit.axllent.org/docs/api-v1/) for integration testing
* Optional [webhook](https://mailpit.axllent.org/docs/integration/webhook/) for received messages
* Multi-architecture [Docker images](https://mailpit.axllent.org/docs/install/docker/) & [AppJail Makejails](https://github.com/AppJail-makejails/mailpit)

## How to use this Makejail

## Standalone

```sh
appjail makejail \
    -j mailpit \
    -f gh+AppJail-makejails/mailpit \
    -o expose=8025 \
    -o expose=1025
appjail start mailpit
```

## Deploy using appjail-director

**appjail-director.yml**:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  mailpit:
    makejail: gh+AppJail-makejails/mailpit
    name: mailpit
    options:
      - expose: 1025
      - expose: 8025
    start-environment:
      - MP_MAX_MESSAGES: 5000
      - MP_DATA_FILE: /mailpit/db/mailpit.db
      - MP_SMTP_AUTH_ACCEPT_ANY: 1
      - MP_SMTP_AUTH_ALLOW_INSECURE: 1
    volumes:
      - mailpit-db: /mailpit/db

volumes:
  mailpit-db:
    device: .volumes/db
    owner: 1001
    group: 1001
```

Deploy Mailpit anywhere using `appjail-director up`.

### Arguments (stage: build):

* `mailpit_tag` (default: `13.4`): see [#tags](#tags).

### Check current status

The custom stage `mailpit_status` can be used to run `top(1)` to check the status of Mailprit.

```sh
appjail run -s mailpit_status mailpit
```

### Log

To view the log generated by the web application, run the custom stage `mailpit_log`.

```sh
appjail run -s mailpit_log mailpit
```

## Tags

| Tag    | Arch     | Version        | Type   |
| ------ | -------- | -------------- | ------ |
| `13.4` | `amd64`  | `13.4-RELEASE` | `thin` |
| `14.1` | `amd64`  | `14.1-RELEASE` | `thin` |
