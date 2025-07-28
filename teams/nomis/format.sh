#!/bin/bash
# Formats code in the same way as the code-formatter GitHub action
# See https://github.com/ministryofjustice/modernisation-platform-github-actions/tree/main/format-code
# Use this to avoid code-formatter commits during a PR

for binary in terraform npx; do
  if ! command -v $binary > /dev/null; then
      echo "Please install $binary"
      exit 1     
  fi
done

extensions='*.yaml *.yml *.md *.html.md *.json'
for extension in $extensions; do 
  files=$(find . -name "$extension")
  if [[ -n $files ]]; then
    npx prettier --print-width=150 --write $files
  fi
done

projects=$(find . -name backend.tf | grep -v '/.terra' | sed -r 's|/[^/]+$||' | sort -u)
for project in $projects; do 
  echo "terraform fmt $project"
  terraform fmt "$project"
done
