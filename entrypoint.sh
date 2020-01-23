#!/bin/bash
# Based on https://github.com/SinusBot/docker/blob/master/discord/entrypoint.sh

echo "Copy default scripts"
if [ -d "default_scripts" ]; then
  mv default_scripts/* scripts
  rm -r default_scripts
  echo "Copied default scripts"
fi

echo "Copy config"
if [ ! -f "config/config.ini" ]; then
  cp config/config.ini config.ini
  echo "Copied config/config.ini"
else
  echo "No config.ini found, using config.ini.configured"
  cp config.ini.configured config.ini
fi

PID=0

# graceful shutdown
kill_handler() {
  echo "Shutting down..."
  kill -s SIGINT -$(ps -o pgid= $PID | grep -o '[0-9]*')
  while [ -e /proc/$PID ]; do
    sleep .5
  done
  exit 0
}

trap 'kill ${!}; kill_handler' SIGTERM # docker stop
trap 'kill ${!}; kill_handler' SIGINT  # CTRL + C

SINUSBOT="./sinusbot"

echo "Starting SinusBot..."
if [[ -v OVERRIDE_PASSWORD ]]; then
  echo "Overriding password..."
  $SINUSBOT --override-password="${OVERRIDE_PASSWORD}" &
else
  $SINUSBOT &
fi

PID=$!
echo "PID: $PID"

while true; do
  tail -f /dev/null & wait ${!}
done
