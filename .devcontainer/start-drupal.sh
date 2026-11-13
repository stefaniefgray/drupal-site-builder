#!/usr/bin/env bash
set -euo pipefail

cd "${CODESPACE_VSCODE_FOLDER:-$(git rev-parse --show-toplevel)}/my-project"

# Re-expose the site after Codespaces resumes from sleep.
if [ -f .ddev/config.yaml ]; then
  ddev start
fi
