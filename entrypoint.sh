#!/bin/sh

. /lib.subr

set -e

create_user

chown -R noroot:noroot /data

exec su-exec noroot mailpit "$@"
