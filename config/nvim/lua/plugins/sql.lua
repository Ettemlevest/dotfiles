-- SQL tooling: sqlfluff only runs in repositories that have a .sqlfluff
-- config (in the file's directory or any parent directory). The lang.sql
-- extra would otherwise lint and format every .sql file with the generic
-- "ansi" dialect, rewriting e.g. MySQL schema dumps on save.
-- The database UI (vim-dadbod) from the extra is not affected.

-- True when a .sqlfluff exists in the buffer's directory or above it
local function has_sqlfluff_config(dirname)
  return vim.fs.find({ ".sqlfluff" }, { path = dirname, upward = true })[1] ~= nil
end

return {
  -- Formatting: run from the directory holding .sqlfluff, so the dialect and
  -- rules come from that config. require_cwd = true means no .sqlfluff,
  -- no formatting.
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.sqlfluff = {
        args = { "format", "-" },
        cwd = require("conform.util").root_file({ ".sqlfluff" }),
        require_cwd = true,
      }
    end,
  },

  -- Linting: same rule
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        sqlfluff = {
          condition = function(ctx)
            return has_sqlfluff_config(ctx.dirname)
          end,
        },
      },
    },
  },
}
