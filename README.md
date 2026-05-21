# Dotfiles

Personal dotfiles for shell, terminal, Neovim, VS Code, tmux, starship, and reusable agent skills.

## Layout

- `.zshrc`: shared zsh setup used on every machine.
- `local/.zshrc.<profile>`: machine-specific zsh setup files discovered by `setup.sh`.
- `setup.sh`: installs symlinks into `$HOME` and creates the untracked zsh profile selector.
- `nvim/`: Neovim config, symlinked to `~/.config/nvim`.
- `.tmux.conf`, `starship.toml`, `alacritty.toml`: terminal-related configs.
- `skills/`: reusable agent skills, symlinked into Claude and Codex skill directories.

## Setup

Run:

```sh
bash setup.sh
```

On the first run, the script discovers files matching `local/.zshrc.*` and asks which zsh profile to use:

```text
Choose dotfiles host profile [macos/ubuntu1/ubuntu2]:
```

It writes the answer to this untracked file:

```sh
~/.zshrc.dotfiles-host
```

The file contains one environment variable:

```sh
export DOTFILES_HOST_PROFILE="macos"
```

Add a profile by creating another file with the same naming pattern, for example `local/.zshrc.work`. The next first-time setup run will include `work` in the prompt. This selector is intentionally outside the repo because it is local machine state.

## Updating After `git pull`

Usually, after pulling changes, you do not need to rerun setup because the installed files are symlinks into this repo.

Run setup again when new symlinked config files are added or paths change:

```sh
bash setup.sh
```

Normal setup is conservative:

- correct symlinks are left alone
- stale symlinks are updated
- existing real files or directories are skipped
- `~/.zshrc.dotfiles-host` is preserved if it already exists

To replace existing real files or directories with repo symlinks, run:

```sh
bash setup.sh --force
```

## What `setup.sh` Links

`setup.sh` creates these links:

```text
~/.zshrc                  -> .zshrc
~/.config/starship.toml   -> starship.toml
~/.config/nvim            -> nvim/
~/.tmux.conf              -> .tmux.conf
~/alacritty/alacritty.toml -> alacritty.toml
~/.claude/skills/<skill>  -> skills/<skill>
~/.codex/skills/<skill>   -> skills/<skill>
```

Skills are linked one directory at a time instead of replacing
`~/.claude/skills` or `~/.codex/skills`. This lets repo-managed skills coexist
with other installed skills.

## How `.zshrc` Works

The shared `.zshrc` starts by defining helper functions:

- `path_prepend DIR`: add an existing directory to the front of `PATH`.
- `path_append DIR`: add an existing directory to the end of `PATH`.
- `source_if_exists FILE`: source a file only when it exists.
- `command_exists CMD`: check whether an optional command is installed.

Then it loads the machine selector:

```sh
source ~/.zshrc.dotfiles-host
```

If `DOTFILES_HOST_PROFILE=macos`, it loads:

```sh
local/.zshrc.macos
```

The same pattern applies to any profile file named `local/.zshrc.<profile>`.

Machine-specific files are loaded early so they can add tools like Homebrew, Neovim, or CUDA to `PATH` before shared setup initializes plugins, prompt, Conda, or NVM.

The shared `.zshrc` then configures:

- Zinit and zsh plugins
- history behavior
- history substring search keybindings
- starship prompt
- Conda from `$HOME/miniconda3`
- zcalc
- NVM
- `vi` and `vim` aliases pointing to `nvim`

## Validation

Useful checks:

```sh
zsh -n .zshrc
zsh -n local/.zshrc.*
bash -n setup.sh
nvim --headless "+Lazy! sync" +qa
nvim --headless "+checkhealth" +qa
```
