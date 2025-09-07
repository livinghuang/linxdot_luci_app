-- /usr/lib/lua/luci/controller/lora/concentrator_mqtt.lua
local M = {}

function M.render()
  local data = {
    broker = "PLACEHOLDER_BROKER",
    user   = "PLACEHOLDER_USER",
    status = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_mqtt", data)
end

return M
