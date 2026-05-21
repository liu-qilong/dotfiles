# Shared zsh configuration.
#
# Keep settings here only if they should apply on every machine. Put paths,
# proxies, CUDA, keychain, app-specific setup, and other machine-specific
# details in local/.zshrc.<profile>

# Directory containing this file. %x is the zsh path for the file currently
# being sourced, and :A resolves symlinks, so ~/.zshrc still points back to this
# checkout.
DOTFILES_DIR="${${(%):-%x}:A:h}"

# Untracked file created by setup.sh. It should contain one line like:
#   export DOTFILES_HOST_PROFILE="macos"
DOTFILES_HOST_ENV="$HOME/.zshrc.dotfiles-host"

# Add a directory to the beginning of PATH, but only when it exists.
path_prepend() {
  [[ -d "$1" ]] && path=("$1" $path)
}

# Add a directory to the end of PATH, but only when it exists.
path_append() {
  [[ -d "$1" ]] && path+=("$1")
}

# Source optional files without failing shell startup when they are missing.
source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

# Check for optional commands before initializing integrations.
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Keep PATH entries unique while preserving order. zsh ties path and PATH
# together, so editing the path array also updates the exported PATH string.
typeset -U path PATH

# Make personal command-line tools available before loading profiles/plugins.
path_prepend "$HOME/.local/bin"

# Load the machine profile selector, then load the tracked profile it names.
# Example: DOTFILES_HOST_PROFILE=ubuntu1 loads local/.zshrc.ubuntu1.
source_if_exists "$DOTFILES_HOST_ENV"

if [[ -n "$DOTFILES_HOST_PROFILE" ]]; then
  DOTFILES_LOCAL_PROFILE="$DOTFILES_DIR/local/.zshrc.$DOTFILES_HOST_PROFILE"
  if [[ -f "$DOTFILES_LOCAL_PROFILE" ]]; then
    source "$DOTFILES_LOCAL_PROFILE"
  else
    print -P "%F{214}dotfiles: missing local profile $DOTFILES_LOCAL_PROFILE%f"
  fi
else
  print -P "%F{214}dotfiles: set DOTFILES_HOST_PROFILE in $DOTFILES_HOST_ENV%f"
fi

# Zinit manages zsh plugins. Bootstrap it on first use, then continue even if
# the clone fails so a network issue does not make every shell unusable.
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  print -P "%F{33}Installing Zinit plugin manager...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{34}Zinit installation successful.%f" || \
    print -P "%F{160}Zinit clone failed; continuing without plugins.%f"
fi

if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
  source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  # Interactive quality-of-life plugins:
  # - autosuggestions: gray inline suggestions from history/completions
  # - syntax highlighting: colors commands while typing
  # - completions: extra completion definitions
  # - substring search: up/down search matching any part of a command
  zinit light zsh-users/zsh-autosuggestions
  zinit light zdharma-continuum/fast-syntax-highlighting
  zinit light zsh-users/zsh-completions
  zinit light zsh-users/zsh-history-substring-search
fi

autoload -Uz compinit && compinit

# Core shell behavior and history storage.
setopt AUTO_CD
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

WORDCHARS=''
HISTORY_SUBSTRING_SEARCH_FUZZY=1
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Bind terminal up/down keys to substring search when the plugin is loaded.
# The multiple key sequences cover different terminal emulators.
if (( $+widgets[history-substring-search-up] && $+widgets[history-substring-search-down] )); then
  [[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" history-substring-search-up
  [[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^[OA' history-substring-search-up
  bindkey '^[OB' history-substring-search-down
fi

# Prompt. Machine profiles load before this, so they can add starship to PATH.
command_exists starship && eval "$(starship init zsh)"

# Conda. This assumes Miniconda lives at $HOME/miniconda3 on every machine.
# If it is absent, this block is skipped.
if [[ -x "$HOME/miniconda3/bin/conda" ]]; then
  __conda_setup="$("$HOME/miniconda3/bin/conda" shell.zsh hook 2>/dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$__conda_setup"
  elif [[ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
  else
    path_prepend "$HOME/miniconda3/bin"
  fi
  unset __conda_setup
fi

autoload -Uz zcalc

# Node Version Manager. These files are optional, so fresh machines without nvm
# still get a working shell.
export NVM_DIR="$HOME/.nvm"
source_if_exists "$NVM_DIR/nvm.sh"
source_if_exists "$NVM_DIR/bash_completion"

# Prefer Neovim when using vi/vim muscle memory.
alias vi='nvim'
alias vim='nvim'

# Export the final PATH after shared and machine-specific edits.
export PATH
