local MiniDeps = require("mini.deps")
local MiniExtra = require("mini.extra")
local MiniPick = require("mini.pick")
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
  "ts_ls",
}

now(function()
  add({ source = "tpope/vim-sleuth" })
end)

now(function()
  add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    -- hooks = {
    --   post_checkout = function()
    --     vim.cmd("TSUpdate")
    --   end,
    -- },
  })
  -- add({ source = "nvim-treesitter/nvim-treesitter-textobjects", checkout = "main" })

  -- local enabled_if_not_too_big = {
  --   enable = true,
  --   disable = function(lang, buf)
  --     local max_filesize = 30 * 1024 -- 30 KB
  --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  --     if ok and stats and stats.size > max_filesize then
  --       return true
  --     end
  --   end,
  -- }

  local nvim_treesitter = require("nvim-treesitter")

  nvim_treesitter.setup({
    -- Directory to install parsers and queries to
    install_dir = vim.fn.stdpath("data") .. "/site",
  })
  nvim_treesitter.install({
    "go",
    "yaml",
    "plsql",
  })

  -- highlighting
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      local parser = vim.treesitter.get_parser(ev.buf, nil, { error = false })
      if parser ~= nil then
        vim.treesitter.start()
      end
    end,
  })

  -- indentation
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  -- folding
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
    callback = function(ev)
      vim.cmd("normal zR") -- open all folds
    end,
  })
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
      hcl = { "terraform" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      json = { "jq" },
      lua = { "stylua" },
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
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

  require("mason-conform").setup({
    -- this ignores noisy errors due to `stop_after_first` and other incompatible
    -- options set for conform above.
    quiet_mode = true,
  })
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

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- this sets up highlighting of _lsp_ references when the cursor holds on an
  -- item.... but it should be registered only when an active lsp supports
  -- document highlight
  -- new_autocmd("CursorHold", "*", vim.lsp.buf.document_highlight, "Document Highlight")
  -- new_autocmd("CursorHoldI", "*", vim.lsp.buf.document_highlight, "Document Highlight")
  -- new_autocmd("CursorMoved", "*", vim.lsp.buf.clear_references, "Clear Document Highlight")

  local group = vim.api.nvim_create_augroup("GD-LSPActions", { clear = true })
  local function pick_lsp(scope)
    return function(ev)
      MiniExtra.pickers.lsp({ scope = scope })
    end
  end
  vim.keymap.set({ "n" }, "<leader>gD", pick_lsp("declaration"), { desc = "[G]o to [D]eclaration" })
  vim.keymap.set({ "n" }, "<leader>gd", pick_lsp("definition"), { desc = "[G]o to [D]efinition" })
  vim.keymap.set({ "n" }, "<leader>gi", pick_lsp("implementation"), { desc = "[G]o to [I]mplementation" })
  vim.keymap.set({ "n" }, "<leader>gr", pick_lsp("references"), { desc = "[G]o to [R]eferences" })
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
