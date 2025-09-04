local M = {}

-- 顯示 Overview 頁面
function M.action_overview()
    local uci = require "luci.model.uci".cursor()

    local mode                = uci:get("linxdot_lora", "forwarder", "mode") or "udp"
    local backend_udp         = uci:get("linxdot_lora", "forwarder", "backend_udp") or "0"
    local backend_mqtt        = uci:get("linxdot_lora", "forwarder", "backend_mqtt") or "0"
    local backend_mesh_border = uci:get("linxdot_lora", "forwarder", "backend_mesh_border") or "0"
    local backend_mesh_relay  = uci:get("linxdot_lora", "forwarder", "backend_mesh_relay") or "0"

    luci.template.render("lora/overview", {
        mode                = mode,
        backend_udp         = backend_udp,
        backend_mqtt        = backend_mqtt,
        backend_mesh_border = backend_mesh_border,
        backend_mesh_relay  = backend_mesh_relay
    })
end

-- 更新設定
function M.action_overview_set()
    local http = require "luci.http"
    local uci  = require "luci.model.uci".cursor()

    local mode                = http.formvalue("mode")
    local backend_udp         = http.formvalue("backend_udp")
    local backend_mqtt        = http.formvalue("backend_mqtt")
    local backend_mesh_border = http.formvalue("backend_mesh_border")
    local backend_mesh_relay  = http.formvalue("backend_mesh_relay")

    -- 儲存模式
    if mode == "udp" or mode == "concentratord" then
        uci:set("linxdot_lora", "forwarder", "mode", mode)
    end

    if mode == "concentratord" then
        uci:set("linxdot_lora", "forwarder", "backend_udp",         backend_udp and "1" or "0")
        uci:set("linxdot_lora", "forwarder", "backend_mqtt",        backend_mqtt and "1" or "0")
        uci:set("linxdot_lora", "forwarder", "backend_mesh_border", backend_mesh_border and "1" or "0")
        uci:set("linxdot_lora", "forwarder", "backend_mesh_relay",  backend_mesh_relay and "1" or "0")
    else
        -- UDP 模式下全部清空
        uci:set("linxdot_lora", "forwarder", "backend_udp",         "0")
        uci:set("linxdot_lora", "forwarder", "backend_mqtt",        "0")
        uci:set("linxdot_lora", "forwarder", "backend_mesh_border", "0")
        uci:set("linxdot_lora", "forwarder", "backend_mesh_relay",  "0")
    end

    uci:commit("linxdot_lora")

    http.prepare_content("application/json")
    http.write_json({
        result              = "Configuration updated",
        mode                = mode,
        backend_udp         = backend_udp or "0",
        backend_mqtt        = backend_mqtt or "0",
        backend_mesh_border = backend_mesh_border or "0",
        backend_mesh_relay  = backend_mesh_relay or "0"
    })
end

return M
