-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- PHP language server for the lang.php extra (default: phpactor).
-- Licence key is read from ~/intelephense/licence.txt
vim.g.lazyvim_php_lsp = "intelephense"

-- TypeScript language server for the lang.typescript extra (default: vtsls).
-- tsc = TypeScript 7's native server (`tsc --lsp`), taken from the project's
-- node_modules/.bin when it is TS 7+, otherwise from $PATH.
vim.g.lazyvim_ts_lsp = "tsc"
