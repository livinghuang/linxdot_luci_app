-- /usr/lib/lua/luci/controller/lora.lua
module("luci.controller.lora", package.seeall)

-- Robust loader: handles modules that use module(..., package.seeall) and don't return a table
local function _load(name)
  local M = package.loaded[name]
  if not M then
    require(name)
    M = package.loaded[name]
  end
  if type(M) ~= "table" then
    error(("module '%s' did not return a table (got %s)"):format(name, type(M)))
  end
  return M
end

function index()
  entry({ "admin", "lora" }, firstchild(), "LoRa", 50).dependent = false

  -- Overview (legacy)
  entry({ "admin", "lora", "overview" }, call("overview_dispatch", "action_overview"), "Overview", 1)
  entry({ "admin", "lora", "overview_set" }, post("overview_dispatch", "action_overview_set")).leaf = true

  -- UDP Forwarder (legacy)
  entry({ "admin", "lora", "udp" }, call("udp_dispatch", "action_udp"), "UDP Forwarder", 2)
  entry({ "admin", "lora", "udp_config" }, post("udp_dispatch", "action_udp_config")).leaf = true
  entry({ "admin", "lora", "udp_log" }, call("udp_dispatch", "action_udp_log")).leaf = true
  entry({ "admin", "lora", "udp_info" }, call("udp_dispatch", "action_udp_info")).leaf = true
  entry({ "admin", "lora", "udp_service" }, call("udp_dispatch", "action_udp_service")).leaf = true

  -- Concentrator (tabs)
  entry({ "admin", "lora", "concentrator" }, firstchild(), "Concentrator", 3).dependent = false
  entry({ "admin", "lora", "concentrator", "overview" }, call("concentrator_dispatch", "action_overview"), "Overview", 1)
  entry({ "admin", "lora", "concentrator", "udp" }, call("concentrator_dispatch", "action_udp"), "UDP Forwarder", 2)
  entry({ "admin", "lora", "concentrator", "mqtt" }, call("concentrator_dispatch", "action_mqtt"), "MQTT Forwarder", 3)
  entry({ "admin", "lora", "concentrator", "mesh" }, call("concentrator_dispatch", "action_mesh"), "Mesh", 4)
end

function overview_dispatch(func)
  local M = _load("lora.overview")
  assert(type(M[func]) == "function", "overview." .. func .. " not found")
  return M[func]()
end

function udp_dispatch(func)
  local M = _load("lora.udp")
  assert(type(M[func]) == "function", "udp." .. func .. " not found")
  return M[func]()
end

function concentrator_dispatch(func)
  local M = _load("lora.concentrator")
  assert(type(M[func]) == "function", "concentrator." .. func .. " not found")
  return M[func]()
end
