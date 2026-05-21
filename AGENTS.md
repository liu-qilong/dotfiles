# Repository Guidelines

## Project Structure & Module Organization

This repository stores personal dotfiles, editor configuration, and reusable agent skills. Top-level files configure shell and terminal tools: `.zshrc`, `.tmux.conf`, `starship.toml`, and `alacritty.toml`. Machine-specific zsh profiles live in `local/.zshrc.<profile>`; `setup.sh` discovers those files and prompts for one when creating the local selector. Neovim configuration lives in `nvim/`: `init.lua` is the entry point, `lua/config/` holds core LazyVim options, `lua/plugins/` holds plugin specs, and `snippets/` holds language snippets. Agent skills live in `skills/<skill-name>/`; each skill uses `SKILL.md` as its entry point and keeps helper scripts beside it. `setup.sh` creates home-directory symlinks.

## Build, Test, and Development Commands

There is no build step. Use targeted validation:

- `bash setup.sh`: install symlinks and, on first run, choose from profiles discovered in `local/.zshrc.*`.
- `nvim --headless "+Lazy! sync" +qa`: sync and validate LazyVim plugin configuration.
- `nvim --headless "+checkhealth" +qa`: run Neovim health checks.
- `stylua nvim/lua`: format Lua files using `nvim/stylua.toml`.
- `python -m py_compile skills/read-pdf/*.py`: syntax-check Python helper scripts.

## Coding Style & Naming Conventions

Lua files use StyLua with 2-space indentation, spaces, and a 120-column width. Keep plugin specs small under `nvim/lua/plugins/`; name files after the plugin or feature, for example `copilot.lua` or `multi-cursor.lua`. Keep snippets in `nvim/snippets/<language>.json`. Zsh profile files use the `local/.zshrc.<profile>` pattern so setup can discover them automatically. Skill directories use lowercase kebab-case names, for example `read-pdf`, and concise task-oriented `SKILL.md` files. Clean up editor backup files ending in `#`.

## Testing Guidelines

This repository has no formal test suite. Validate changes by launching the affected tool and running the narrow checks above. For Neovim changes, run headless commands first, then open Neovim interactively. For shell changes, start `zsh -i` and verify aliases, prompts, and environment changes. For skills, review trigger conditions and run helper scripts against a small local sample.

## Commit & Pull Request Guidelines

The repository currently has no commit history, so no local convention is established. Use concise imperative commit messages such as `Add tmux status config` or `Update Neovim completion plugin`. Pull requests should describe the affected tool, list validation commands, and mention manual steps or local dependencies. Include screenshots only for visible UI changes.

## Security & Configuration Tips

Do not commit secrets, machine-specific tokens, or private hostnames. Prefer environment variables or ignored local files. Before changing `setup.sh`, make destructive operations explicit and keep symlink targets relative to this checkout where possible.
