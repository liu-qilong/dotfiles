### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{32} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{32} %F{34}Installation successful.%f%b" || \
        print -P "%F{159} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# zinit plugins
zinit light zsh-users/zsh-autosuggestions  # fish-style inline suggestions
zinit light zdharma-continuum/fast-syntax-highlighting  # real-time syntax coloring
zinit light zsh-users/zsh-completions  # extra completions (conda, git, etc.)
zinit light zsh-users/zsh-history-substring-search  # history substring search
autoload -Uz compinit && compinit

setopt AUTO_CD  # type a dir name to cd into it
setopt EXTENDED_HISTORY  # save timestamp and duration of each command
setopt HIST_IGNORE_DUPS  # no duplicate history entries
setopt SHARE_HISTORY  # share history across terminals
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=20000

HISTORY_SUBSTRING_SEARCH_FUZZY=1
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A'  history-substring-search-up
bindkey '^[[B'  history-substring-search-down
bindkey '^[OA'  history-substring-search-up
bindkey '^[OB'  history-substring-search-down

WORDCHARS=''  # treat / - _ . as word boundaries 
HISTORY_SUBSTRING_SEARCH_FUZZY=1  # fuzzy match (looser)
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1  # only show unique matches

# starship prompt
eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/knpob/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/knpob/miniconda3/etc/profile.d/conda.sh" ]; then
       . "/users/knpob/miniconda3/etc/profile.d/conda.sh"
    else
        export path="/users/knpob/miniconda3/bin:$path"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# zcalc
autoload -Uz zcalc

# homebrew
export PATH=$PATH:/opt/homebrew/bin

# scripts
export PATH=$PATH:"/Users/knpob/Library/Mobile Documents/iCloud~md~obsidian/Documents/DeepSpace/scripts"

# proxy setting
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
export ALL_PROXY=$http_proxy  # for homebrew

# claude path
export PATH="$HOME/.local/bin:$PATH"

# npm path
export PATH=$PATH:$(npm config get prefix)/bin

# nvm path
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# windsurf path
export PATH="/Users/knpob/.codeium/windsurf/bin:$PATH"

# neovim path
export PATH=$PATH:$HOME/.local/bin/nvim-macos-arm64/bin
alias vi='nvim'
alias vim='nvim'
