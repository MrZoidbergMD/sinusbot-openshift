#!/bin/bash
# Entrypoint to run in OpenShift
# Based on https://github.com/SinusBot/docker/blob/master/discord/entrypoint.sh

if [ -d "default_scripts" ]; then
  mv default_scripts/* scripts
  rm -r default_scripts
  echo "[entrypoint] Copied default scripts"
fi

if [ -f "config/config.ini" ]; then
  cp config/config.ini config.ini
  echo "[entrypoint] Copied config/config.ini"
else
  echo "[entrypoint] No config.ini found, using config.ini.configured"
  cp config.ini.configured config.ini
fi

PID=0

# graceful shutdown
kill_handler() {
  echo "[entrypoint] Shutting down..."
  kill -s SIGINT -$(ps -o pgid= $PID | grep -o '[0-9]*')
  while [ -e /proc/$PID ]; do
    sleep .5
  done
  exit 0
}

trap 'kill ${!}; kill_handler' SIGTERM # docker stop
trap 'kill ${!}; kill_handler' SIGINT  # CTRL + C

SINUSBOT="./sinusbot"

echo "[entrypoint] Starting SinusBot..."
if [[ -v OVERRIDE_PASSWORD ]]; then
  echo "[entrypoint] Overriding password..."
  $SINUSBOT --override-password="${OVERRIDE_PASSWORD}" &
else
  $SINUSBOT &
fi

PID=$!
echo "[entrypoint] PID: $PID"

while true; do
  tail -f /dev/null & wait ${!}
done
