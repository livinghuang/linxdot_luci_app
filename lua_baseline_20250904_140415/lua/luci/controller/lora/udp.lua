-- /usr/lib/lua/luci/controller/lora/udp.lua
local fs     = require "nixio.fs"
local sys    = require "luci.sys"
local uci    = require "luci.model.uci".cursor()
local http   = require "luci.http"
local tpl    = require "luci.template"

local LOGTAG = "[udp]"

local function log(msg)
  sys.syslog("notice", LOGTAG .. " " .. msg)
end

local M = {}

-- 只掃描 /etc/lora/ 且只匹配 global_conf.json.sx1250.<REGION>
function M.get_udp_regions()
  log("G: enter get_udp_regions")
  local regions = {}

  if fs.stat("/etc/lora/", "type") ~= "dir" then
    log("G: /etc/lora/ not found")
    return regions
  end

  for f in fs.dir("/etc/lora/") do
    log("G: scan file: " .. f)
    local region = f:match("^global_conf%.json%.sx1250%.(.+)$")
    if region then
      log("G: matched region: " .. region)
      regions[#regions + 1] = region
    end
  end

  table.sort(regions)
  log("G: total regions: " .. tostring(#regions))
  return regions
end

function M.action_udp()
  log("A: enter action_udp")

  local info      = {}
  info.mac_eth    = sys.exec("cat /sys/class/net/eth0/address 2>/dev/null"):gsub("\n", "")
  info.mac_wlan   = sys.exec("cat /sys/class/net/wlan0/address 2>/dev/null"):gsub("\n", "")

  info.region     = uci:get("linxdot_lora", "forwarder", "region") or "AS923_1"
  info.server     = uci:get("linxdot_lora", "forwarder", "server") or "127.0.0.1"
  info.port_up    = uci:get("linxdot_lora", "forwarder", "port_up") or "1700"
  info.port_down  = uci:get("linxdot_lora", "forwarder", "port_down") or "1700"
  info.gateway_id = uci:get("linxdot_lora", "forwarder", "gateway_id")

  if not info.gateway_id or #info.gateway_id == 0 then
    local mac = (info.mac_eth or ""):gsub(":", ""):upper()
    if #mac >= 12 then
      info.gateway_id = mac:sub(1, 6) .. "FFFE" .. mac:sub(7)
    end
  end

  local cf         = "/etc/lora/global_conf.json.sx1250." .. info.region
  info.config_file = fs.access(cf) and cf or "(not found)"

  local status     = sys.call("/etc/init.d/linxdot-lora-pkt-fwd status >/dev/null 2>&1")
  info.lora_status = (status == 0) and "Running" or "Stopped"

  local regions    = M.get_udp_regions()
  log("B: after get_udp_regions, n=" .. tostring(#regions))
  for _, r in ipairs(regions) do
    log("B: region item: " .. r)
  end

  tpl.render("lora/udp", { info = info, regions = regions })
  log("C: after render")
end

function M.action_udp_config()
  local region     = http.formvalue("region")
  local server     = http.formvalue("server")
  local port_up    = http.formvalue("port_up")
  local port_down  = http.formvalue("port_down")
  local gateway_id = http.formvalue("gateway_id")

  if region and #region > 0 then uci:set("linxdot_lora", "forwarder", "region", region) end
  if server and #server > 0 then uci:set("linxdot_lora", "forwarder", "server", server) end
  if port_up and #port_up > 0 then uci:set("linxdot_lora", "forwarder", "port_up", port_up) end
  if port_down and #port_down > 0 then uci:set("linxdot_lora", "forwarder", "port_down", port_down) end
  if gateway_id and #gateway_id > 0 then uci:set("linxdot_lora", "forwarder", "gateway_id", gateway_id) end

  uci:commit("linxdot_lora")
  sys.call("/etc/init.d/linxdot-lora-pkt-fwd restart >/dev/null 2>&1")

  http.prepare_content("application/json")
  http.write_json({
    result = "Configuration updated and forwarder restarted",
    region = region or "",
    server = server or "",
    port_up = port_up or "",
    port_down = port_down or "",
    gateway_id = gateway_id or ""
  })
end

function M.action_udp_log()
  http.prepare_content("text/plain")
  http.write(sys.exec("tail -n 50 /var/log/lora_pkt_fwd.log 2>/dev/null"))
end

function M.action_udp_info()
  local info       = {}
  info.mac_eth     = sys.exec("cat /sys/class/net/eth0/address 2>/dev/null"):gsub("\n", "")
  info.mac_wlan    = sys.exec("cat /sys/class/net/wlan0/address 2>/dev/null"):gsub("\n", "")
  info.region      = uci:get("linxdot_lora", "forwarder", "region") or "AS923_1"
  info.server      = uci:get("linxdot_lora", "forwarder", "server") or "127.0.0.1"
  info.port_up     = uci:get("linxdot_lora", "forwarder", "port_up") or "1700"
  info.port_down   = uci:get("linxdot_lora", "forwarder", "port_down") or "1700"
  info.gateway_id  = uci:get("linxdot_lora", "forwarder", "gateway_id")

  local cf         = "/etc/lora/global_conf.json.sx1250." .. info.region
  info.config_file = fs.access(cf) and cf or "(not found)"

  local status     = sys.call("/etc/init.d/linxdot-lora-pkt-fwd status >/dev/null 2>&1")
  info.lora_status = (status == 0) and "Running" or "Stopped"

  http.status(200, "OK")
  http.prepare_content("application/json")
  http.write_json(info)
end

function M.action_udp_service()
  local cmd    = http.formvalue("service")
  local result = "unknown"

  if cmd == "start" then
    sys.call("/etc/init.d/linxdot-lora-pkt-fwd start >/dev/null 2>&1"); result = "started"
  elseif cmd == "stop" then
    sys.call("/etc/init.d/linxdot-lora-pkt-fwd stop >/dev/null 2>&1"); result = "stopped"
  elseif cmd == "restart" then
    sys.call("/etc/init.d/linxdot-lora-pkt-fwd restart >/dev/null 2>&1"); result = "restarted"
  end

  http.status(200, "OK")
  http.prepare_content("application/json")
  http.write_json({ status = "ok", action = result })
end

return M
