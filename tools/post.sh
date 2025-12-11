#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Need to add a post title"
  exit 1
fi

TITLE="$1"

# Compose post
OUTPUT=$(bundle exec jekyll compose "$TITLE")

# Example output:
# "New post created at _posts/2025-12-11-my-title.md"
POST_PATH=$(echo "$OUTPUT" | grep -oE "_posts/.*\.md")

if [ -z "$POST_PATH" ]; then
  echo "Could not determine post output path."
  exit 1
fi

# Convert post path into a slug folder name (remove date + extension)
SLUG=$(basename "$POST_PATH" .md | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-//')

# Create assets directory for this post
ASSET_DIR="assets/post/$SLUG"
mkdir -p "$ASSET_DIR"

echo "Post created: $POST_PATH"
echo "Assets folder created: $ASSET_DIR"
