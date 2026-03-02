local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

vim.o.autoread = true

-- later(function()
--   add({
--     source = 'sudo-tee/opencode.nvim',
--     depends = { "nvim-lua/plenary.nvim" }
--   })
--   require('opencode').setup({
--     preferred_picker = 'mini.pick',
--     preferred_completion = 'blink',
--   })
-- end)

later(function()
  add({
    source = "olimorris/codecompanion.nvim",
    depends = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
  })

  local helpers = require("codecompanion.adapters.acp.helpers")

  require("codecompanion").setup({
    ai_model = "gpt-4o-mini",
    chat = {
      keymaps = {
        close = "<C-c>",
      },
    },
    strategies = {
      chat = {
        adapter = {
          name = "copilot",
          model = "grok-code-fast-1",
        },
        opts = {
          prompt_decorator = function(message, adapter, context)
            return string.format([[<prompt>%s</prompt>]], message)
          end,
        },
      },
    },
    display = {
      chat = {
        auto_scroll = false,
        fold_context = true,
      },
    },
    extensions = {
      spinner = {},
    },
  })

  vim.keymap.set({ "n" }, "<leader>cc", "<CMD>CodeCompanionChat<CR>", {
    desc = "Open [C]odeCompanion [C]hat",
  })
end)
