# PowerShell Script: add-all-apps.ps1

$appNames = @(
    "kong", "wordpress", "matomo", "gitlab", "umami", "wso2",
    "apiman", "plausible", "airflow", "posthog", "drupal", "elasticsearch",
    "nextcloud", "redash", "superset", "hasura", "keycloak", "sonarqube",
    "rocket-chat", "outline", "taiga", "zulip", "glpi", "presto", "openproject",
    "graylog", "kibana"
)

foreach ($app in $appNames) {
    $appPath = ".\$app"
    if (-not (Test-Path $appPath)) {
        Write-Host "Creating folder: $appPath"
        New-Item -ItemType Directory -Path $appPath | Out-Null
    }

    $composePath = Join-Path $appPath "docker-compose.yml"
    $envPath = Join-Path $appPath ".env"

    if (-not (Test-Path $composePath)) {
        Write-Host "Creating $composePath"
        @"
version: '3.8'
services:
  $app
    image: <ADD_IMAGE_HERE>
    ports:
      - "80:80"
    env_file:
      - .env
"@ | Out-File -Encoding utf8 $composePath
    }

    if (-not (Test-Path $envPath)) {
        Write-Host "Creating $envPath"
        "# Add environment variables for $app here" | Out-File -Encoding utf8 $envPath
    }
}

Write-Host "`n✅ All service folders and base files created."
