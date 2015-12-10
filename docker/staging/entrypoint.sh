#!/bin/bash
set -e

function start {
  # executed when container is run
  : # do nothing
}

if [ "$1" == "/sbin/my_init" ]; then
  start
fi

exec "$@"
