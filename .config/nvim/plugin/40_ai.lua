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
      -- {
      --   source = "Davidyz/VectorCode",
      --   hooks = {
      --     post_checkout = function()
      --       local command = { "uv", "tool", "upgrade", "vectorcode" }
      --       local output = vim.fn.system(command)
      --       local bufnr = vim.api.nvim_create_buf(false, true)
      --
      --       -- Set buffer options using vim.bo[bufnr]
      --       vim.api.nvim_buf_set_name(bufnr, "VectorCode_Build_Log")
      --       vim.bo[bufnr].buftype = "nofile" -- Not associated with a file
      --       vim.bo[bufnr].bufhidden = "wipe" -- Close on hide
      --       vim.bo[bufnr].swapfile = false -- No swap file
      --       vim.bo[bufnr].modifiable = false -- Make it read-only
      --       vim.bo[bufnr].readonly = true -- Make it read-only
      --
      --       local lines = vim.split(output, "\n", { plain = true })
      --       vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      --
      --       -- Open the new buffer in a split window
      --       vim.cmd("split")
      --       vim.api.nvim_win_set_buf(0, bufnr) -- 0 refers to the current window
      --     end,
      --   },
      -- },
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
    extensions = {},
  })

  vim.keymap.set({ "n" }, "<leader>cc", "<CMD>CodeCompanionChat<CR>", {
    desc = "Open [C]odeCompanion [C]hat",
  })
end)
