-- /usr/lib/lua/luci/controller/lora/concentrator.lua
local M = {}

function M.action_overview()
  local m = require("luci.controller.lora.concentrator_overview")
  m.render()
end

function M.action_udp()
  local m = require("luci.controller.lora.concentrator_udp")
  m.render()
end

function M.action_mqtt()
  local m = require("luci.controller.lora.concentrator_mqtt")
  m.render()
end

function M.action_mesh()
  local m = require("luci.controller.lora.concentrator_mesh")
  m.render()
end

return M
