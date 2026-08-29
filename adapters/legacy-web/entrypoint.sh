#!/usr/bin/env bash
set -euo pipefail

if [[ -f /run/secrets/db-password ]]; then
  SPRING_DATASOURCE_PASSWORD="$(< /run/secrets/db-password)"
  export SPRING_DATASOURCE_PASSWORD
fi

if [[ -n "${APP_MAIN_CLASS:-}" ]]; then
  exec java -XX:MaxRAMPercentage=70.0 \
    -cp '/app/WEB-INF/classes:/app/WEB-INF/lib/*:/app/WEB-INF/lib-provided/*' \
    "$APP_MAIN_CLASS" \
    --server.port=8080 \
    --server.servlet.context-path=/
fi

exec java -XX:MaxRAMPercentage=70.0 -jar /app/app.war --server.port=8080 --server.servlet.context-path=/
