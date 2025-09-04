module("lora.concentrator", package.seeall)

function action_overview()
  local m = require("lora.concentrator_overview")
  m.render()
end

function action_udp()
  local m = require("lora.concentrator_udp")
  m.render()
end

function action_mqtt()
  local m = require("lora.concentrator_mqtt")
  m.render()
end

function action_mesh()
  local m = require("lora.concentrator_mesh")
  m.render()
end
