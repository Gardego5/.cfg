local MiniDeps = require("mini.deps")
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = _G.Config.now_if_args

vim.opt.signcolumn = "number"
vim.opt.colorcolumn = "80"
vim.opt.foldcolumn = "auto:9"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- clear highlights when exiting search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

now(function()
  add({ source = "catppuccin/nvim" })
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    term_colors = true,
    integrations = {
      cmp = true,
      mini = true,
      treesitter = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")
end)

now(function()
  add({ source = "j-hui/fidget.nvim" })
  require("fidget").setup({
    progress = {
      display = {
        render_limit = 16,
        done_ttl = 3,
        done_style = "Constant",
        progress_icon = { "dots" },
        overrides = {
          rust_analyzer = { name = "rust-analyzer" },
        },
      },
    },
    notification = {
      poll_rate = 10,
      history_size = 128,
      override_vim_notify = true,
      window = {
        winblend = 0,
      },
      configs = {
        default = require("fidget.notification").default_config,
      },
    },
  })
end)

now_if_args(function()
  local MiniFiles = require("mini.files")
  MiniFiles.setup({
    use_as_default_explorer = true,

    -- Customization of shown content
    content = {
      -- Predicate for which file system entries to show
      filter = nil,
      -- Highlight group to use for a file system entry
      highlight = nil,
      -- Prefix text and highlight to show to the left of file system entry
      prefix = nil,
      -- Order in which to show file system entries
      sort = nil,
    },

    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
    mappings = {
      close = "<ESC>",
      go_in = "l",
      go_in_plus = "L",
      go_out = "h",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = ":w",
      trim_left = "<",
      trim_right = ">",
    },

    -- Customization of explorer windows
    windows = {
      -- Maximum number of windows to show side by side
      max_number = math.huge,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      -- Width of focused window
      width_focus = 50,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 25,
    },
  })
  vim.keymap.set({ "n" }, "<leader>e", MiniFiles.open, { desc = "[E]dit [F]iles" })
end)

later(function()
  local minigit = require("mini.git")
  minigit.setup({})
end)

later(function()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
    },
    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)

later(function()
  local hipatterns = require("mini.hipatterns")
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      -- Highlight hex color strings (`#006688`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  local MiniIndentscope = require("mini.indentscope")
  MiniIndentscope.setup({
    draw = { animation = MiniIndentscope.gen_animation.none() },
    symbol = "╎",
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Textobjects
      object_scope = "ii",
      object_scope_with_border = "ai",

      -- Motions (jump to respective border line; if not present - body line)
      goto_top = "[i",
      goto_bottom = "]i",
    },
    options = { try_as_border = true },
  })
end)

now(function()
  require("mini.statusline").setup()
  require("mini.icons").setup()
end)

later(function()
  require("mini.comment").setup()
  require("mini.cursorword").setup({ delay = 100 })
  local minidiff = require("mini.diff")
  minidiff.setup({
    view = {
      style = "sign",
      signs = {
        add = "+",
        change = "~",
        delete = "-",
      },
    },
  })

  vim.keymap.set("n", "<leader>td", function()
    minidiff.toggle_overlay()
  end, { desc = "[T]oggle [D]iff" })
end)

later(function()
  MiniPick = require("mini.pick")
  MiniExtra = require("mini.extra")

  MiniPick.setup({
    -- Delays (in ms; should be at least 1)
    delay = {
      -- Delay between forcing asynchronous behavior
      async = 10,

      -- Delay between computation start and visual feedback about it
      busy = 50,
    },

    -- Keys for performing actions. See `:h MiniPick-actions`.
    mappings = {
      caret_left = "<Left>",
      caret_right = "<Right>",

      choose = "<CR>",
      choose_in_split = "<C-s>",
      choose_in_tabpage = "<C-t>",
      choose_in_vsplit = "<C-v>",
      choose_marked = "<M-CR>",

      delete_char = "<BS>",
      delete_char_right = "<Del>",
      delete_left = "<C-u>",
      delete_word = "<C-w>",

      mark = "<C-x>",
      mark_all = "<C-a>",

      move_down = "<C-n>",
      move_start = "<C-g>",
      move_up = "<C-p>",

      paste = "<C-r>",

      refine = "<C-Space>",
      refine_marked = "<M-Space>",

      scroll_down = "<C-f>",
      scroll_left = "<C-h>",
      scroll_right = "<C-l>",
      scroll_up = "<C-b>",

      stop = "<Esc>",

      toggle_info = "<S-Tab>",
      toggle_preview = "<Tab>",
    },

    -- General options
    options = {
      -- Whether to show content from bottom to top
      content_from_bottom = false,

      -- Whether to cache matches (more speed and memory on repeated prompts)
      use_cache = false,
    },

    -- Source definition. See `:h MiniPick-source`.
    source = {
      items = nil,
      name = nil,
      cwd = nil,

      match = nil,
      show = nil,
      preview = nil,

      choose = nil,
      choose_marked = nil,
    },

    -- Window related options
    window = {
      -- Float window config (table or callable returning it)
      config = nil,

      -- String to use as caret in prompt
      prompt_caret = "▏",

      -- String to use as prefix in prompt
      prompt_prefix = "> ",
    },
  })

  vim.keymap.set("n", "<leader>f<space>", MiniPick.builtin.resume, { desc = "[F]ind [R]esume" })
  vim.keymap.set("n", "<leader>ff", MiniPick.builtin.files, { desc = "[F]ind [F]iles" })
  vim.keymap.set("n", "<leader>fg", MiniPick.builtin.grep_live, { desc = "[F]ind [G]rep" })
  vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "[F]ind [B]uffers" })
  vim.keymap.set("n", "<leader>fq", function()
    MiniExtra.pickers.list({ scope = "quickfix" })
  end, { desc = "[F]ind [Q]uickfix" })
end)

later(function()
  add({
    source = "kristijanhusak/vim-dadbod-ui",
    depends = {
      { source = "tpope/vim-dadbod" },
      -- { source = "kristijanhusak/vim-dadbod-completion" },
    },
  })
end)
