local M = {}

local prefix = "[sql-runner] "

function M.run_selection(opts)
  local ts = os.time()
  local outfile = vim.fn.stdpath("data") .. string.format("/%d-sql.out", ts)
  local url = opts.database_url or vim.fn.getenv("DATABASE_URL")
  if not url or url == "" then
    vim.notify(prefix .. "DATABASE_URL is not set.", vim.log.levels.ERROR)
  elseif type(url) ~= "string" then
    vim.notify(prefix .. "SqlLoader.run_selection called with opts.database_url not string.", vim.log.levels.ERROR)
  end
end

return M
