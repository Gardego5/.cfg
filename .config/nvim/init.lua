_G.Config = {}
_G.Config.path_package = vim.fn.stdpath("data") .. "/site"
_G.Config.mini_path = _G.Config.path_package .. "/pack/deps/start/mini.nvim"

-- bootstrap mini (including mini.deps)
if not vim.uv.fs_stat(_G.Config.mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local origin = "https://github.com/nvim-mini/mini.nvim"
  local clone_cmd = { "git", "clone", "--filter=blob:none", origin, _G.Config.mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- setup up plugin manager
require("mini.deps").setup({ path = { package = _G.Config.path_package } })

local group = vim.api.nvim_create_augroup("custom-config", {})
_G.Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = group, callback = callback, desc = desc }
  if pattern ~= nil then
    opts.pattern = pattern
  end
  return vim.api.nvim_create_autocmd(event, opts)
end

_G.Config.now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later
