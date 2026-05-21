#!/usr/bin/env bash
set -euo pipefail

# Absolute path to this checkout. Symlinks should always point here, even when
# setup.sh is called from another directory.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Local, untracked selector read by .zshrc to choose local/.zshrc.<profile>.
HOST_ENV="$HOME/.zshrc.dotfiles-host"
FORCE=0

usage() {
  echo "Usage: $0 [--force]"
}

# --force allows replacing existing real files/directories. Without it, setup
# only creates missing links or updates existing symlinks.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
  shift
done

# Link one repo path into the home directory.
#
# Rules:
# - correct symlinks are left alone
# - stale symlinks are replaced
# - existing real files/directories are skipped unless --force is used
link_file() {
  local source="$1"
  local target="$2"

  # Ensure parent directories like ~/.config exist before linking into them.
  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" ]]; then
    # Idempotent reruns should be quiet and safe after git pull.
    if [[ "$(readlink "$target")" == "$source" ]]; then
      echo "Already linked: $target"
      return
    fi

    # A symlink exists but points somewhere else; replace it with this repo's
    # version. This does not remove real files.
    rm "$target"
  elif [[ -e "$target" ]]; then
    if [[ "$FORCE" -ne 1 ]]; then
      echo "Skipped existing file: $target"
      echo "  Run $0 --force to replace it."
      return
    fi

    # --force is intentionally required for real files/directories because this
    # can delete user-managed config.
    rm -rf "$target"
  fi

  ln -s "$source" "$target"
  echo "Linked: $target -> $source"
}

# Link every tracked skill into both Claude and Codex. The parent skills
# directories are kept as real directories so other installed skills can coexist.
link_skills() {
  local skill
  local skill_name

  for skill in "$DOTFILES_DIR"/skills/*; do
    [[ -d "$skill" ]] || continue
    skill_name="$(basename "$skill")"

    link_file "$skill" "$HOME/.claude/skills/$skill_name"
    link_file "$skill" "$HOME/.codex/skills/$skill_name"
  done
}

discover_host_profiles() {
  local profile_file
  local profile_name

  HOST_PROFILES=()
  shopt -s nullglob
  for profile_file in "$DOTFILES_DIR"/local/.zshrc.*; do
    [[ -f "$profile_file" ]] || continue
    profile_name="${profile_file##*/.zshrc.}"
    [[ -n "$profile_name" ]] || continue
    HOST_PROFILES+=("$profile_name")
  done
  shopt -u nullglob
}

join_profiles() {
  local IFS="/"
  echo "$*"
}

profile_exists() {
  local profile="$1"
  local known_profile

  for known_profile in "${HOST_PROFILES[@]}"; do
    [[ "$profile" == "$known_profile" ]] && return 0
  done

  return 1
}

# Create the untracked host profile selector on first setup. Existing selectors
# are preserved so rerunning setup does not silently change machine identity.
ensure_host_profile() {
  local profile
  local profile_prompt

  discover_host_profiles
  if [[ "${#HOST_PROFILES[@]}" -eq 0 ]]; then
    echo "No host profiles found in $DOTFILES_DIR/local/.zshrc.*" >&2
    exit 1
  fi
  profile_prompt="$(join_profiles "${HOST_PROFILES[@]}")"

  if [[ -f "$HOST_ENV" ]]; then
    echo "Using existing host profile selector: $HOST_ENV"
    return
  fi

  while true; do
    printf "Choose dotfiles host profile [%s]: " "$profile_prompt"
    read -r profile

    if profile_exists "$profile"; then
      # .zshrc sources this file and then loads local/.zshrc.$profile.
      printf 'export DOTFILES_HOST_PROFILE="%s"\n' "$profile" > "$HOST_ENV"
      chmod 600 "$HOST_ENV"
      echo "Wrote $HOST_ENV"
      return
    fi

    echo "Invalid profile. Expected one of: $profile_prompt."
  done
}

ensure_host_profile

# Install the tracked configs. The targets stay as symlinks, so normal edits
# after git pull are picked up without rerunning setup.
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/alacritty.toml" "$HOME/alacritty/alacritty.toml"
link_skills
