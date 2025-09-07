-- /usr/lib/lua/luci/controller/lora/concentrator_overview.lua
local M = {}

function M.render()
  local uci                 = require("luci.model.uci").cursor()
  local sys                 = require("luci.sys")

  local mode                = uci:get("linxdot_lora", "forwarder", "mode") or "udp"
  local backend_udp         = uci:get("linxdot_lora", "forwarder", "backend_udp") or "0"
  local backend_mqtt        = uci:get("linxdot_lora", "forwarder", "backend_mqtt") or "0"
  local backend_mesh_border = uci:get("linxdot_lora", "forwarder", "backend_mesh_border") or "0"
  local backend_mesh_relay  = uci:get("linxdot_lora", "forwarder", "backend_mesh_relay") or "0"

  -- 組合 key → 決定圖片
  local key                 = {}
  if backend_udp == "1" then table.insert(key, "udp") end
  if backend_mqtt == "1" then table.insert(key, "mqtt") end
  if backend_mesh_border == "1" then table.insert(key, "border") end
  if backend_mesh_relay == "1" then table.insert(key, "relay") end
  local key_str = table.concat(key, "+")

  local arch_map = {
    ["udp"]             = "lora_concentratord_udp.png",
    ["mqtt"]            = "lora_concentratord_mqtt.png",
    ["border"]          = "lora_concentratord_meshBorder.png",
    ["relay"]           = "lora_concentratord_meshRelay.png",
    ["udp+mqtt"]        = "lora_concentratord_udp_mqtt.png",
    ["udp+border"]      = "lora_concentratord_udp_meshBorder.png",
    ["mqtt+border"]     = "lora_concentratord_mqtt_meshBorder.png",
    ["udp+relay"]       = "lora_concentratord_udp_meshRelay.png",
    ["mqtt+relay"]      = "lora_concentratord_mqtt_meshRelay.png",
    ["udp+mqtt+border"] = "lora_concentratord_udp_mqtt_meshBorder.png",
    ["udp+mqtt+relay"]  = "lora_concentratord_udp_mqtt_meshRelay.png"
  }

  local arch_img = arch_map[key_str] or "lora_concentratord.png"

  luci.template.render("lora/concentrator_overview", {
    gateway_id          = sys.exec("cat /tmp/gateway_id 2>/dev/null"):gsub("%s+", ""),
    status              = "Running", -- TODO: 可加 ubus 判斷
    firmware            = sys.exec("cat /etc/linxdot_version 2>/dev/null"):gsub("%s+", ""),
    region              = uci:get("linxdot_lora", "forwarder", "region") or "N/A",
    backend_udp         = backend_udp,
    backend_mqtt        = backend_mqtt,
    backend_mesh_border = backend_mesh_border,
    backend_mesh_relay  = backend_mesh_relay,
    arch_img            = arch_img
  })
end

return M
