#!/usr/bin/env bash

set -euo pipefail

dependabot_file=".github/dependabot.yml"

# Dependabot cooldown configuration (applies to version updates only)
# Docs: https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#cooldown-
dependabot_cooldown_default_days="${DEPENDABOT_COOLDOWN_DEFAULT_DAYS:-7}"

if ! [[ "$dependabot_cooldown_default_days" =~ ^[0-9]+$ ]]; then
  echo "ERROR: DEPENDABOT_COOLDOWN_DEFAULT_DAYS must be an integer (days), got: '$dependabot_cooldown_default_days'" >&2
  exit 1
fi

if (( dependabot_cooldown_default_days < 1 || dependabot_cooldown_default_days > 90 )); then
  echo "ERROR: DEPENDABOT_COOLDOWN_DEFAULT_DAYS must be between 1 and 90 (inclusive), got: '$dependabot_cooldown_default_days'" >&2
  exit 1
fi

echo "Generating dependabot.yml..."

cat > "$dependabot_file" << 'EOF'
---
# This file is auto-generated, do not manually amend.
# scripts/generate-dependabot-file.sh

version: 2

updates:
  # Dependency management strategy:
  # ministryofjustice/modernisation-platform#8211
  #
  # Major and minor/patch version updates are grouped separately, with both
  # checked monthly to reduce routine Dependabot PR noise.
  #
  # Monthly is a compromise, not the ticket's proposed fortnightly major
  # and six-monthly minor/patch cadence.
  #
  # Dependabot alerts and security updates must be enabled separately in
  # repository/org settings; security updates do not wait for this schedule.
EOF

# GitHub Actions (single root)
cat >> "$dependabot_file" << EOF
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "monthly"
    cooldown:
      default-days: $dependabot_cooldown_default_days
    groups:
      action-major:
        update-types:
          - "major"
      action-minor-patch:
        update-types:
          - "minor"
          - "patch"

EOF

# Bundler (only if Gemfile.lock is found at root)
[[ -f Gemfile.lock ]] && cat >> "$dependabot_file" << EOF
  - package-ecosystem: "bundler"
    directory: "/"
    schedule:
      interval: "monthly"
    cooldown:
      default-days: $dependabot_cooldown_default_days
EOF

# Docker
docker_files=$(find . -name Dockerfile)
if [[ -n "$docker_files" ]]; then
  docker_dirs=$(echo "$docker_files" | sed 's|^\./||' | xargs -n1 dirname | awk -F/ '{print $1}' | sort -u)
  if [[ -n "$docker_dirs" ]]; then
    {
      echo "  - package-ecosystem: \"docker\""
      echo "    directories:"
      echo "$docker_dirs" | while read -r dir; do
        echo "      - \"/$dir/**/*\""
      done
      echo "    schedule:"
      echo "      interval: \"monthly\""
      echo "    cooldown:"
      echo "      default-days: $dependabot_cooldown_default_days"
      echo "    groups:"
      echo "      docker-major:"
      echo "        update-types:"
      echo "          - \"major\""
      echo "      docker-minor-patch:"
      echo "        update-types:"
      echo "          - \"minor\""
      echo "          - \"patch\""
    } >> "$dependabot_file"
  fi
fi

# Terraform
tf_files=$(find . -name '*.tf' ! -path '*/.terraform/*')
if [[ -n "$tf_files" ]]; then
  tf_dirs=$(echo "$tf_files" | sed 's|^\./||' | xargs -n1 dirname | sort -u | awk -F/ '{print $1}' | sort -u)
  if [[ -n "$tf_dirs" ]]; then
    {
      echo "  - package-ecosystem: \"terraform\""
      echo "    directories:"
      echo "$tf_dirs" | while read -r dir; do
        echo "      - \"/$dir/**/*\""
      done
      echo "    schedule:"
      echo "      interval: \"monthly\""
      echo "    cooldown:"
      echo "      default-days: $dependabot_cooldown_default_days"
      echo "    groups:"
      echo "      terraform-major:"
      echo "        update-types:"
      echo "          - \"major\""
      echo "      terraform-minor-patch:"
      echo "        update-types:"
      echo "          - \"minor\""
      echo "          - \"patch\""
    } >> "$dependabot_file"
  fi
fi

# Go Modules
gomod_files=$(find . -name 'go.mod' ! -path '*/.terraform/*')
if [[ -n "$gomod_files" ]]; then
  gomod_dirs=$(echo "$gomod_files" | sed 's|^\./||' | xargs -n1 dirname | sort -u | awk -F/ '{print $1}' | sort -u)
  if [[ -n "$gomod_dirs" ]]; then
    {
      echo "  - package-ecosystem: \"gomod\""
      echo "    directories:"
      echo "$gomod_dirs" | while read -r dir; do
        echo "      - \"/$dir/**/*\""
      done
      echo "    schedule:"
      echo "      interval: \"monthly\""
      echo "    cooldown:"
      echo "      default-days: $dependabot_cooldown_default_days"
      echo "    groups:"
      echo "      gomod-major:"
      echo "        update-types:"
      echo "          - \"major\""
      echo "      gomod-minor-patch:"
      echo "        update-types:"
      echo "          - \"minor\""
      echo "          - \"patch\""
    } >> "$dependabot_file"
  fi
fi

# Python (pip)
py_files=$(find . \( -name 'requirements.txt' -o -name 'pyproject.toml' \))
if [[ -n "$py_files" ]]; then
  pip_dirs=$(echo "$py_files" | sed 's|^\./||' | xargs -n1 dirname | sort -u | awk -F/ '{print $1}' | sort -u)
  if [[ -n "$pip_dirs" ]]; then
    {
      echo "  - package-ecosystem: \"pip\""
      echo "    directories:"
      echo "$pip_dirs" | while read -r dir; do
        echo "      - \"/$dir/**/*\""
      done
      echo "    schedule:"
      echo "      interval: \"monthly\""
      echo "    cooldown:"
      echo "      default-days: $dependabot_cooldown_default_days"
      echo "    groups:"
      echo "      pip-major:"
      echo "        update-types:"
      echo "          - \"major\""
      echo "      pip-minor-patch:"
      echo "        update-types:"
      echo "          - \"minor\""
      echo "          - \"patch\""
    } >> "$dependabot_file"
  fi
fi

# Node (npm)
npm_files=$(find . -name 'package.json' ! -path '*/node_modules/*')
if [[ -n "$npm_files" ]]; then
  npm_dirs=$(echo "$npm_files" | sed 's|^\./||' | xargs -n1 dirname | sort -u | awk -F/ '{print $1}' | sort -u)
  if [[ -n "$npm_dirs" ]]; then
    {
      echo "  - package-ecosystem: \"npm\""
      echo "    directories:"
      echo "$npm_dirs" | while read -r dir; do
        echo "      - \"/$dir/**/*\""
      done
      echo "    schedule:"
      echo "      interval: \"monthly\""
      echo "    cooldown:"
      echo "      default-days: $dependabot_cooldown_default_days"
      echo "    groups:"
      echo "      npm-major:"
      echo "        update-types:"
      echo "          - \"major\""
      echo "      npm-minor-patch:"
      echo "        update-types:"
      echo "          - \"minor\""
      echo "          - \"patch\""
    } >> "$dependabot_file"
  fi
fi

echo "✅ dependabot.yml has been generated at $dependabot_file"
