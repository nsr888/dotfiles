local fn = vim.fn

local M = {}

function M.executable(name)
  if fn.executable(name) > 0 then
    return true
  end

  return false
end

M._if = function(bool, a, b)
    if bool then
        return a
    else
        return b
    end
end

function M.has_neovim_v05()
  if vim.fn.has('nvim-0.5') == 1 then
    return true
  end
  return false
end

function M.is_root()
  local output = vim.fn.systemlist "id -u"
  return ((output[1] or "") == "0")
end

return M
