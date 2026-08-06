#!/bin/sh

. /lib.subr

set -e

create_user

change_owner /data

exec su-exec noroot mailpit "$@"
