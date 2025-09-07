-- /usr/lib/lua/luci/controller/lora/concentrator_udp.lua
local M = {}

function M.render()
  local data = {
    server = "PLACEHOLDER_SERVER",
    port   = "PLACEHOLDER_PORT",
    status = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_udp", data)
end

return M
