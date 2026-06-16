#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="$HOME/.claude/commands"

mkdir -p "$target_dir"

for command_file in "$repo_root"/claude-commands/*.md; do
  [ -f "$command_file" ] || continue
  cp "$command_file" "$target_dir/$(basename "$command_file")"
  printf 'Installed Claude command: %s\n' "$target_dir/$(basename "$command_file")"
done

