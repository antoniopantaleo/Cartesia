#!/bin/zsh

set -euo pipefail
set -x

export TUIST_STATS_OPT_OUT=1
export TUIST_CONFIG_CLOUD_ANALYTICS_OPT_OUT=1

curl https://mise.run | MISE_VERSION=$(MISE_VERSION) sh
echo "eval \"\$(/Users/local/.local/bin/mise activate zsh)\"" >>"/Users/local/.zshrc"
source /Users/local/.zshrc
mise settings experimental=true
mise install

mise exec -- tuist generate --no-open -p ..
