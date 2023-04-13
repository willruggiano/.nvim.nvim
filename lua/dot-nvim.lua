local ffi = require "ffi"
local lfs = require "lfs"

ffi.cdef [[
  int getuid(void);
]]

local M = {}

function M.exists(filepath)
  return lfs.attributes(filepath) ~= nil
end

function M.owned_by_me(filepath)
  return ffi.C.getuid() == lfs.attributes(filepath).uid
end

function M.is_lua(filepath)
  return vim.fn.fnamemodify(filepath, ":e") == "lua"
end

---Checks that a given file is safe to load.
---That is, it (1) exists, and (2) is owned by the current user.
---@param filepath string the file in question
---@return boolean ok whether the file is safe to load
function M.check(filepath)
  return M.exists(filepath) and M.is_lua(filepath) and M.owned_by_me(filepath)
end

local default_opts = {
  dir = ".nvim",
}

function M.load(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  if M.exists(opts.dir) then
    local cwd = lfs.currentdir()
    for file in vim.fs.dir(opts.dir) do
      local filename = cwd .. "/" .. opts.dir .. "/" .. file
      if M.check(filename) then
        if not pcall(dofile, filename) then
          print(file .. " failed to load")
        end
      end
    end
  end
end

return M
