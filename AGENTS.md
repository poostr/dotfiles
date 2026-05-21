# AGENTS.md — Dotfiles Repository

This file provides guidance for agentic coding assistants working in this repository.

## Internet Search

When you need to search for information on the internet, always use the `exa` MCP tool.

---

## Repository Overview

A personal dotfiles repo managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory corresponds to a tool; stow symlinks its contents into `~/.config`.

**Primary language**: Lua (Neovim and WezTerm configs)
**Config formats**: TOML (yazi), YAML (k9s), JSON (opencode, snippets), plus tmux/skhd/i3/ghostty DSLs
**Platform**: macOS primary (yabai, skhd), Linux secondary (i3config)

---

## Deployment

```bash
# Install stow
brew install stow

# Symlink a tool's config into ~/.config
stow nvim       # ~/.config/nvim -> dotfiles/nvim/.config/nvim
stow tmux
stow wezterm
stow ghostty
stow yazi
stow skhd
stow yabai
stow k9s
stow opencode

# Remove a symlink
stow -D nvim
```

There is **no build system**, no CI, and no test suite for the dotfiles themselves.

---

## Project Structure

```
dotfiles/
├── AGENTS.md               # This file
├── Readme.md               # Brief stow usage instructions
├── .gitignore              # Ignores .DS_Store and /iterm2
├── nvim/                   # Neovim config (Lua) — most complex
│   └── .config/nvim/
│       ├── init.lua        # Entry: require("postr.core") + require("postr.lazy")
│       ├── lazy-lock.json  # Pinned plugin versions
│       ├── after/lsp/      # LSP override stubs
│       ├── snippets/       # VS Code-format JSON snippets
│       └── lua/postr/      # All authored Lua code lives here
│           ├── lazy.lua
│           ├── lsp.lua
│           ├── core/       # options.lua, remap.lua, init.lua
│           └── plugins/    # One file per plugin or plugin group
├── tmux/                   # Tmux config + vendored plugins
├── wezterm/                # WezTerm terminal emulator config
├── ghostty/                # Ghostty terminal emulator config
├── yazi/                   # Yazi file manager (TOML)
├── k9s/                    # Kubernetes TUI (YAML + custom skins)
├── skhd/                   # macOS hotkey daemon config
├── yabai/                  # macOS tiling window manager config
├── i3config/               # i3 window manager config (Linux)
└── opencode/               # opencode AI tool model config (JSON)
```

---

## Build / Lint / Test Commands

### There are no repo-level test commands.

Formatters and linters are configured in Neovim and triggered manually or on
buffer events inside the editor — they are **not** run from the shell CLI on
the dotfiles repo itself.

### Neovim-managed tools (installed via Mason)

| Tool        | Language  | Trigger                        |
|-------------|-----------|--------------------------------|
| `stylua`    | Lua       | `<leader>gf` inside Neovim     |
| `ruff`      | Python    | `<leader>gf` / lint on save    |
| `yamllint`  | YAML      | lint on BufEnter/BufWritePost  |
| `yamlfix`   | YAML      | `<leader>gf`                   |
| `jq`        | JSON      | `<leader>gf`                   |
| `prettier`  | misc      | `<leader>gf`                   |
| `codespell` | all files | `<leader>gf`                   |

### Running formatters from the CLI (if tools are installed globally)

```bash
# Format a Lua file
stylua path/to/file.lua

# Lint/format Python
ruff check path/to/file.py
ruff format path/to/file.py

# Format JSON
jq . file.json > file.json.tmp && mv file.json.tmp file.json

# Lint YAML
yamllint file.yaml
```

### Running vendored tmux plugin tests (third-party, not dotfiles tests)

```bash
# From inside a vendored plugin directory
bash tests/test_plugin_installation.sh
```

---

## Lua Code Style (Neovim config)

### Module / Namespace

All authored Lua lives under the `postr` namespace:

```lua
require("postr.core")           -- loads lua/postr/core/init.lua
require("postr.core.remap")
require("postr.core.options")
require("postr.lazy")           -- lazy.nvim bootstrap
```

Plugin configs are loaded via lazy.nvim's import mechanism:

```lua
require("lazy").setup({
    { import = "postr.plugins" },
    { import = "postr.plugins.lsp" },
    { import = "postr.plugins.python" },
})
```

### Imports / Requires

```lua
-- Prefer local aliased requires at the top of each file
local telescope = require("telescope")
local actions   = require("telescope.actions")

-- Use pcall for optional or potentially-absent modules
local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
    -- use wf
end

-- Inline require inside callbacks is acceptable for lazy loading
vim.keymap.set("n", "<leader>tr", function()
    require("neotest").run.run()
end)
```

### Naming Conventions

| Kind              | Convention    | Example                          |
|-------------------|---------------|----------------------------------|
| Plugin config files | `kebab-case.lua` | `blink-cmp.lua`, `copilot-chat.lua` |
| Local variables   | `snake_case`  | `local lint_augroup`             |
| Functions         | `snake_case`  | `function get_schema()`          |
| Lua module root   | `postr`       | `require("postr.core")`          |
| Tool directories  | lowercase     | `nvim/`, `tmux/`, `wezterm/`     |
| TOML/YAML keys    | `snake_case`  | `sort_by`, `show_hidden`         |

### Formatting / Indentation

- **Formatter**: `stylua` (configured in Neovim's `conform.lua`; no `stylua.toml` in repo)
- **Indentation**: Tabs for Lua files (stylua default); `tabstop/shiftwidth = 2` set in Neovim options
- **Quotes**: Double-quoted strings (`"string"`) throughout Lua
- **Semicolons**: None (Lua does not use them)
- **Column limit**: 88 characters (set via `vim.opt.colorcolumn = "88"`)
- **No trailing whitespace**: Enforced by `trim_whitespace` fallback formatter

### Error Handling

```lua
-- 1. pcall for protected calls (preferred for require and risky operations)
local ok, result = pcall(vim.loop.fs_stat, path)
if ok and result then
    -- use result
end

-- 2. Nil-guard chaining for nested optional values
local name = schema and schema.result and schema.result[1] and schema.result[1].name or ""

-- 3. Early return in callbacks
vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, _)
    if err or not result or vim.tbl_isempty(result) then
        return
    end
    -- handle result
end)

-- 4. Filesystem existence checks before access
if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
end
```

---

## Shell Scripts (yabai, tmux plugins)

- Shebang: `#!/usr/bin/env sh` (POSIX sh, not bash)
- Self-contained — no sourcing of other dotfile scripts
- Imperative style; no `set -e` or explicit error handling
- Vendored tmux plugin scripts use `#!/usr/bin/env bash`

---

## Configuration File Conventions

### TOML (yazi)

```toml
# snake_case keys
sort_by = "modified"
show_hidden = true
```

### YAML (k9s)

```yaml
# snake_case keys in authored files
liveViewAutoRefresh: false  # camelCase comes from k9s itself — preserve as-is
```

### JSON (opencode, snippets)

- Formatted with `jq` (2-space indent)
- Snippets follow VS Code snippet format

### Ghostty / tmux / skhd

- These use tool-specific DSLs — follow the existing file's style exactly
- tmux: prefix is `C-f` (not the default `C-b`)
- skhd: bindings control yabai window management

---

## Neovim-Specific Notes

- **Leader key**: `Space`
- **Color theme**: Nord (used across all tools: Neovim, WezTerm, Ghostty, tmux, k9s)
- **Font**: JetBrains Mono, bold, no ligatures (`JetBrainsMonoNL Nerd Font Mono`)
- **LSP servers**: gopls, basedpyright, ty (Python), lua_ls, yamlls, jsonls, taplo, ltex, sourcekit
- **Python test runner**: pytest via neotest (`<leader>tr` nearest, `<leader>tf` file, `<leader>td` debug)
- **Format on save**: Disabled (`format_on_save = false`) — trigger manually with `<leader>gf`
- **Completion**: blink-cmp
- **Fuzzy finder**: Telescope
- **File explorer**: oil.nvim
- **AI in editor**: GitHub Copilot + CopilotChat (model: claude-opus-4.5)

---

## AI / Agent Tools

This repo is used by the [opencode](https://opencode.ai) AI coding tool.
The opencode config at `opencode/.config/opencode/opencode.json` defines available models:

- `antigravity-claude-sonnet-4-6` (default)
- `antigravity-claude-opus-4-6-thinking`
- Various Gemini 3.x models

No `.cursorrules`, `.github/copilot-instructions.md`, or `CLAUDE.md` files exist in this repo.
