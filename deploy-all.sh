#!/bin/bash
set -e

APPS=("redash" "keycloak" "rocket-chat" "outline" "taiga" "zulip" "openproject" "graylog" "posthog" "wso2")

for app in "${APPS[@]}"; do
  echo "=== Deploying $app ==="
  cd "$app" || { echo "Failed to enter $app directory"; exit 1; }
  
  # Generate secrets for Outline dynamically
  if [[ "$app" == "outline" ]]; then
    sed -i "s/^SECRET_KEY=.*/SECRET_KEY=$(openssl rand -hex 32)/" .env
    sed -i "s/^UTILS_SECRET=.*/UTILS_SECRET=$(openssl rand -hex 32)/" .env
  fi

  # Generate secret for Redash
  if [[ "$app" == "redash" ]]; then
    sed -i "s/^REDASH_SECRET_KEY=.*/REDASH_SECRET_KEY=$(openssl rand -hex 32)/" .env
  fi

  # Generate secret for Graylog
  if [[ "$app" == "graylog" ]]; then
    sed -i "s/^GRAYLOG_PASSWORD_SECRET=.*/GRAYLOG_PASSWORD_SECRET=$(openssl rand -base64 64)/" .env
  fi

  docker-compose up -d
  sleep 5
  cd ..
done

echo "=== All services deployed ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
