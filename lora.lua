-- /usr/lib/lua/luci/controller/lora.lua
module("luci.controller.lora", package.seeall)

function index()
  entry({ "admin", "lora" }, firstchild(), "LoRa", 50).dependent = false

  -- Overview
  entry({ "admin", "lora", "overview" }, call("overview_dispatch", "action_overview"), "Overview", 1)
  entry({ "admin", "lora", "overview_set" }, post("overview_dispatch", "action_overview_set")).leaf = true

  -- UDP Forwarder (舊版用的配置頁，保留)
  entry({ "admin", "lora", "udp" }, call("udp_dispatch", "action_udp"), "UDP Forwarder", 2)
  entry({ "admin", "lora", "udp_config" }, post("udp_dispatch", "action_udp_config")).leaf = true
  entry({ "admin", "lora", "udp_log" }, call("udp_dispatch", "action_udp_log")).leaf = true
  entry({ "admin", "lora", "udp_info" }, call("udp_dispatch", "action_udp_info")).leaf = true
  entry({ "admin", "lora", "udp_service" }, call("udp_dispatch", "action_udp_service")).leaf = true

  -- Concentrator (新 tabs 架構)
  entry({ "admin", "lora", "concentrator" }, firstchild(), "Concentrator", 3).dependent = false
  entry({ "admin", "lora", "concentrator", "overview" }, call("concentrator_dispatch", "action_overview"), "Overview", 1)
  -- entry({ "admin", "lora", "concentrator", "udp" }, call("concentrator_dispatch", "action_udp"), "UDP Forwarder", 2)
  -- entry({ "admin", "lora", "concentrator", "mqtt" }, call("concentrator_dispatch", "action_mqtt"), "MQTT Forwarder", 3)
  -- entry({ "admin", "lora", "concentrator", "mesh" }, call("concentrator_dispatch", "action_mesh"), "Mesh", 4)
end

-- Dispatcher for overview.lua
function overview_dispatch(func)
  local overview = require("lora.overview")
  assert(type(overview[func]) == "function", "overview." .. func .. " not found")
  overview[func]()
end

-- Dispatcher for udp.lua
function udp_dispatch(func)
  local udp = require("lora.udp")
  assert(type(udp[func]) == "function", "udp." .. func .. " not found")
  udp[func]()
end

-- Dispatcher for concentrator.lua
function concentrator_dispatch(func)
  local concentrator = require("lora.concentrator")
  assert(type(concentrator[func]) == "function", "concentrator." .. func .. " not found")
  concentrator[func]()
end
