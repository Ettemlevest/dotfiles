#!/bin/bash

# Config
MAX_BRANCH_LENGTH=20

# Read JSON input once
input=$(cat)

# Extract current directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Extract context percentage
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Git information
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  # Get repo name (just the directory name)
  repo_name=$(basename "$cwd")

  # Get branch (truncate if too long)
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ ${#branch} -gt $MAX_BRANCH_LENGTH ]; then
    branch="${branch:0:$MAX_BRANCH_LENGTH}…"
  fi

  # Count staged files
  staged=$(git -C "$cwd" --no-optional-locks diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')

  # Count unstaged files (modified + deleted, not untracked)
  unstaged=$(git -C "$cwd" --no-optional-locks diff --name-only 2>/dev/null | wc -l | tr -d ' ')

  # Count untracked files
  untracked=$(git -C "$cwd" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

  # Color the context percentage based on usage
  if [ "$ctx_pct" -ge 60 ]; then
    ctx_color='\033[01;31m' # red
  elif [ "$ctx_pct" -ge 40 ]; then
    ctx_color='\033[01;33m' # yellow
  else
    ctx_color='\033[01;32m' # green
  fi

  printf '\033[01;36m%s\033[00m | \033[01;32m%s\033[00m | S: \033[01;33m%s\033[00m | U: \033[01;33m%s\033[00m | A: \033[01;33m%s\033[00m | %b%s%%\033[00m' \
    "$repo_name" "$branch" "$staged" "$unstaged" "$untracked" "$ctx_pct"
else
  printf '\033[01;36m%s\033[00m | %s%%' "$cwd" "$ctx_pct"
fi
