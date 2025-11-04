local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local new_autocmd = _G.Config.new_autocmd

local lsp_servers = {
  "gopls",
  "terraformls",
  "dockerls",
  "pyright",

  "clangd",
  "html",
  "rust_analyzer",
  "lua_ls",
}

now(function()
  add({ source = "tpope/vim-sleuth" })
end)

now(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
      post_checkout = function()
        vim.cmd("TSUpdate")
      end,
    },
  })
  add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

  local languages = {
    "bash",
    "c",
    "diff",
    "go",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "sql",
    "vimdoc",
    "yaml",
  }

  require("nvim-treesitter").setup({
    ensure_installed = languages,
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
    },
  })

  -- Enable tree-sitter after opening a file for a target language
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  new_autocmd("FileType", filetypes, function(ev)
    vim.treesitter.start(ev.buf)
  end, "Start tree-sitter")
end)

later(function()
  add({ source = "neovim/nvim-lspconfig" })
  add({ source = "mason-org/mason.nvim" })
  add({ source = "stevearc/conform.nvim" })
  add({ source = "LittleEndianRoot/mason-conform" })
  add({ source = "mason-org/mason-lspconfig.nvim" })
  add({ source = "zbirenbaum/copilot.lua" })
  add({ source = "saghen/blink.cmp", checkout = "v1.7.0", depends = {
    "fang2hou/blink-copilot",
  } })

  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  })

  require("mason").setup()

  local conform = require("conform")
  conform.setup({
    formatters_by_ft = {
      go = { "goimports", "gofmt" },
      hcl = { "terraform fmt" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      json = { "jq" },
      lua = { "stylua" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      sql = { "sqruff" },
      templ = { "templ" },
      yaml = { "yq" },
    },
  })

  new_autocmd("CursorHold", "*", function(event)
    local fmt = conform.list_formatters(event.buf)
    if fmt ~= nil or #fmt ~= 0 then
      conform.format({ async = false, bufnr = event.buf })
    end
  end, "Format on idle.")

  -- require("mason-conform").setup()
  require("mason-lspconfig").setup({
    ensure_installed = lsp_servers,
    automatic_installation = true,
  })

  require("blink.cmp").setup({
    cmdline = { sources = { "cmdline" } },
    signature = { enabled = true },
    sources = {
      default = { "copilot", "lsp", "path", "codecompanion" },
      providers = {
        codecompanion = { module = "codecompanion.providers.completion.blink" },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
  })

  new_autocmd("CursorHold", "*", vim.lsp.buf.document_highlight, "Document Highlight")
  new_autocmd("CursorHoldI", "*", vim.lsp.buf.document_highlight, "Document Highlight")
  new_autocmd("CursorMoved", "*", vim.lsp.buf.clear_references, "Clear Document Highlight")

  vim.keymap.set({ "n" }, "<leader>gD", vim.lsp.buf.declaration, { desc = "[G]o to [D]eclaration" })
  vim.keymap.set({ "n" }, "<leader>gd", vim.lsp.buf.definition, { desc = "[G]o to [D]efinition" })
  vim.keymap.set({ "n" }, "<leader>cf", conform.format, { desc = "[C]ode [F]ormat buffer" })
  vim.keymap.set({ "n" }, "<leader>cr", function()
    -- when renaming things... open them in a cmdline window, instead of just a
    -- cmdline... this supports vim motions etc...

    local cmd_id
    local function launch_cmdline_window(ev)
      local ctrl_f = vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
      vim.api.nvim_feedkeys(ctrl_f, "c", false)
      vim.api.nvim_feedkeys("0", "n", false)
      cmd_id = nil -- autocmd was triggered and so we can remove the ID and return true to delete the autocmd
    end
    local function clear_cmd_id()
      if cmd_id then
        vim.api.nvim_del_autocmd(cmd_id)
      end
    end

    cmd_id = vim.api.nvim_create_autocmd({ "CmdlineEnter" }, { callback = launch_cmdline_window })
    vim.lsp.buf.rename()
    vim.defer_fn(clear_cmd_id, 250)
  end, { desc = "[C]ode [R]ename symbol" })
  vim.keymap.set({ "n" }, "<leader>ca", function()
    vim.lsp.buf.code_action()
  end, { desc = "[C]ode [A]ction" })

  -- diagnostics (errors)
  -- global function we can make dot-repeatable
  _G._jump_to_next_diagnostic = function()
    -- jump to the next diagnostic
    local diagnostic = vim.diagnostic.jump({ count = 1 })
    if not diagnostic then
      -- try to jump backwards if nothing is there.
      vim.diagnostic.jump({ count = -1 })
    end
  end
  vim.keymap.set({ "n" }, "<leader>cd", function(ev)
    -- set this up to be dot-repeatable
    vim.o.operatorfunc = "v:lua._jump_to_next_diagnostic"
    vim.cmd.normal("g@l")
  end, { desc = "jump to next [C]ode [D]iagnostic" })
  vim.diagnostic.config({
    virtual_text = true,
    -- when we jump, open a virtual window to show what's up
    jump = { float = true },
  })
end)

later(function()
  add("zbirenbaum/neodim")
  require("neodim").setup({
    alpha = 0.75,
    blend_color = nil,
    hide = {
      underline = true,
      virtual_text = true,
      signs = true,
    },
    regex = {
      "[uU]nused",
      "[nN]ever [rR]ead",
      "[nN]ot [rR]ead",
    },
    priority = 128,
    disable = {},
  })
end)
