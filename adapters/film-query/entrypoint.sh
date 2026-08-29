#!/usr/bin/env bash
set -euo pipefail

if [[ -f /run/secrets/db-password ]]; then
  FILM_DB_PASSWORD="$(< /run/secrets/db-password)"
  export FILM_DB_PASSWORD
fi

exec ttyd \
  --writable \
  --check-origin \
  --max-clients 8 \
  --ping-interval 15 \
  --terminal-type xterm-256color \
  java -XX:MaxRAMPercentage=70 -cp '/app/demo.jar:/app/lib/*' \
  com.skilldistillery.filmquery.app.FilmQueryApp
