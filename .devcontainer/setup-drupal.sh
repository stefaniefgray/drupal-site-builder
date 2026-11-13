#!/usr/bin/env bash
set -euo pipefail

cd "${CODESPACE_VSCODE_FOLDER:-$(git rev-parse --show-toplevel)}/my-project"

# The existing site's files and database are retained when an existing
# Codespace is rebuilt. Do not reinstall an initialized Drupal site.
if [ ! -f .ddev/config.yaml ]; then
  ddev config --project-type=drupal11 --docroot=web --php-version=8.4 --project-name=site-builder
fi

for attempt in $(seq 1 60); do
  if docker ps >/dev/null 2>&1; then break; fi
  sleep 2
done
docker ps >/dev/null 2>&1 || { echo "Docker did not become ready"; exit 1; }

ddev start
ddev composer install --no-interaction

if [ ! -f web/sites/default/settings.php ]; then
  echo "Installing a fresh Drupal Site Builder practice site..."
  ddev drush site:install standard --account-name=admin --site-name="Site Builder Practice" -y
else
  echo "Existing Drupal settings.php found; preserving your site and database."
fi

echo
echo "Open the private 'Drupal Site Builder' port 8080 link in the Codespaces PORTS tab."
echo "For an existing site, use its existing Drupal admin credentials."
echo "For a fresh site, the install command above outputs the admin password."
