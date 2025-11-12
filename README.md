# Neovim Configuration

Personal Neovim configuration with machine-specific settings support.

## Quick Setup on a New Machine

1. Clone this repository to `~/.config/nvim`

2. Copy the local configuration template:
   ```bash
   cd ~/.config/nvim
   cp lua/local.lua.example lua/local.lua
   ```

3. Edit `lua/local.lua` to customize for your machine:
   ```bash
   nvim lua/local.lua
   ```

4. Key settings to configure:
   - `use_colemak`: Set to `true` if you use Colemak keyboard layout, `false` for QWERTY
   - `python_path`: Adjust the Python interpreter path for your system
   - `copilot_enabled`: Enable/disable GitHub Copilot
   - `avante_provider`: Choose your AI provider ("qianwen", "ollama", etc.)
   - `avante_providers`: Configure API keys and endpoints for AI providers
   - `theme`: Customize theme settings (transparency, lualine theme)

5. Start Neovim and let plugins install:
   ```bash
   nvim
   ```

## Machine-Specific Configuration

The `lua/local.lua` file (gitignored) contains machine-specific settings:

- **Keyboard Layout**: Colemak vs QWERTY key mappings
- **Debug Paths**: Language-specific debugger paths (Python, etc.)
- **AI/Copilot**: API keys, endpoints, and provider preferences
- **Theme**: Transparency and color scheme preferences
- **Editor Settings**: Tab size, indentation preferences

See `lua/local.lua.example` for all available options and detailed comments.

## Features

- LSP support with Mason
- GitHub Copilot integration
- AI assistant (Avante.nvim) with multiple provider support
- Debug adapter protocol (DAP) for Python, Go, and Lua
- Telescope fuzzy finder
- Git integration
- File manager (Neo-tree)
- Auto-completion with nvim-cmp
- Treesitter syntax highlighting
- Colemak keyboard layout support (optional)

## Tips

- The configuration automatically falls back to sensible defaults if `lua/local.lua` is missing
- You can keep different `local.lua` files for different machines and copy the appropriate one when setting up
- Update `lua/local.lua.example` if you add new machine-specific options
