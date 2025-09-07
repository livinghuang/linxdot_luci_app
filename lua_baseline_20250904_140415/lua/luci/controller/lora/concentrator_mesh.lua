-- /usr/lib/lua/luci/controller/lora/concentrator_mesh.lua
local M = {}

function M.render()
  local data = {
    mode     = "PLACEHOLDER_MODE",
    upstream = "PLACEHOLDER_UPSTREAM",
    status   = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_mesh", data)
end

return M
