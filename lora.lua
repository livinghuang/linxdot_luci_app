module("luci.controller.lora", package.seeall)

function index()
  entry({ "admin", "lora" }, firstchild(), "LoRa", 50).dependent = false
  -- Overview
  entry({ "admin", "lora", "overview" }, call("action_overview"), "Overview", 1)
  entry({ "admin", "lora", "overview_set" }, post("action_overview_set")).leaf = true
  -- UDP Forwarder
  entry({ "admin", "lora", "udp" }, call("action_udp"), "UDP Forwarder", 2)
  entry({ "admin", "lora", "udp_config" }, post("action_udp_config")).leaf = true
  entry({ "admin", "lora", "udp_log" }, call("action_udp_log")).leaf = true
  entry({ "admin", "lora", "udp_info" }, call("action_udp_info")).leaf = true
  entry({ "admin", "lora", "udp_service" }, call("action_udp_service")).leaf = true
end

-- Overview page
function action_overview()
  local uci          = require "luci.model.uci".cursor()
  local mode         = uci:get("linxdot_lora", "forwarder", "mode") or "udp"
  local backend_udp  = uci:get("linxdot_lora", "forwarder", "backend_udp") or "0"
  local backend_mqtt = uci:get("linxdot_lora", "forwarder", "backend_mqtt") or "0"
  local backend_mesh = uci:get("linxdot_lora", "forwarder", "backend_mesh") or "0"

  luci.template.render("lora/overview", {
    mode         = mode,
    backend_udp  = backend_udp,
    backend_mqtt = backend_mqtt,
    backend_mesh = backend_mesh
  })
end

-- Update mode & backends
function action_overview_set()
  local http         = require "luci.http"
  local uci          = require "luci.model.uci".cursor()

  local mode         = http.formvalue("mode")
  local backend_udp  = http.formvalue("backend_udp")
  local backend_mqtt = http.formvalue("backend_mqtt")
  local backend_mesh = http.formvalue("backend_mesh")

  if mode == "udp" then
    uci:set("linxdot_lora", "forwarder", "mode", "udp")
    -- 清除 backend 選項，避免混淆
    uci:delete("linxdot_lora", "forwarder", "backend_udp")
    uci:delete("linxdot_lora", "forwarder", "backend_mqtt")
    uci:delete("linxdot_lora", "forwarder", "backend_mesh")
  elseif mode == "concentratord" then
    uci:set("linxdot_lora", "forwarder", "mode", "concentratord")
    uci:set("linxdot_lora", "forwarder", "backend_udp", backend_udp and "1" or "0")
    uci:set("linxdot_lora", "forwarder", "backend_mqtt", backend_mqtt and "1" or "0")
    uci:set("linxdot_lora", "forwarder", "backend_mesh", backend_mesh and "1" or "0")
  end

  uci:commit("linxdot_lora")

  http.prepare_content("application/json")
  http.write_json({
    result       = "Configuration updated",
    mode         = mode,
    backend_udp  = backend_udp or "0",
    backend_mqtt = backend_mqtt or "0",
    backend_mesh = backend_mesh or "0"
  })
end
