#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-$HOME/.codex}"
target_dir="$codex_home/skills"

mkdir -p "$target_dir"

for skill_dir in "$repo_root"/codex-skills/*; do
  [ -d "$skill_dir" ] || continue
  name="$(basename "$skill_dir")"
  rm -rf "$target_dir/$name"
  cp -R "$skill_dir" "$target_dir/$name"
  printf 'Installed Codex skill: %s\n' "$target_dir/$name"
done

