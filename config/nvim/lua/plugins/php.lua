-- PHP tooling: use whatever the repository you are editing is set up for.
-- Each tool only runs when its config file is found in the file's directory
-- or any parent directory, so different repos get different tools.
-- Executables come from the repo's vendor/bin first, then from Mason.

-- True when one of `names` exists in the buffer's directory or above it
local function has_config(dirname, names)
  return vim.fs.find(names, { path = dirname, upward = true })[1] ~= nil
end

return {
  -- Formatting: Pint for repos with pint.json, php-cs-fixer for repos with
  -- a .php-cs-fixer config. The first one whose config exists is used.
  -- Neither found: LazyVim falls back to the LSP formatter (intelephense).
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.php = { "pint", "php_cs_fixer", stop_after_first = true }

      opts.formatters = opts.formatters or {}
      opts.formatters.pint = {
        condition = function(_, ctx)
          return has_config(ctx.dirname, { "pint.json" })
        end,
      }
      opts.formatters.php_cs_fixer = {
        condition = function(_, ctx)
          return has_config(ctx.dirname, { ".php-cs-fixer.php", ".php-cs-fixer.dist.php" })
        end,
      }
    end,
  },

  -- Linting: phpcs (enabled by the lang.php extra) only in repos that have
  -- a phpcs ruleset. Without one it would lint against its own default
  -- standard, which the repo never agreed to follow.
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        phpcs = {
          condition = function(ctx)
            return has_config(ctx.dirname, { "phpcs.xml", ".phpcs.xml", "phpcs.xml.dist", ".phpcs.xml.dist" })
          end,
        },
      },
    },
  },
}
