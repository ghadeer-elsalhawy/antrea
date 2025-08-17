#!/bin/bash

set -euo pipefail

VERSION1="$1"
VERSION2="$2" 
VERSION3="$3"

RENOVATE_CONFIG="../.github/renovate.json5"

if [[ ! -f "$RENOVATE_CONFIG" ]]; then
    echo "Error: Renovate config file not found at $RENOVATE_CONFIG"
    exit 1
fi

echo "Updating renovate configuration with versions: $VERSION1, $VERSION2, $VERSION3"

sed -i.bak "s/baseBranches: \[\"main\", \"[^\"]*\", \"[^\"]*\", \"[^\"]*\"\],/baseBranches: [\"main\", \"$VERSION1\", \"$VERSION2\", \"$VERSION3\"],/" "$RENOVATE_CONFIG"

# Update first matchBaseBranches occurrence that disables regular updates for active release branches
sed -i.bak2 "0,/matchBaseBranches: \[\"[^\"]*\", \"[^\"]*\", \"[^\"]*\"\],/{s/matchBaseBranches: \[\"[^\"]*\", \"[^\"]*\", \"[^\"]*\"\],/matchBaseBranches: [\"$VERSION1\", \"$VERSION2\", \"$VERSION3\"],/}" "$RENOVATE_CONFIG"

rm -f "$RENOVATE_CONFIG.bak" "$RENOVATE_CONFIG.bak2"

echo "Successfully updated $RENOVATE_CONFIG"