-- /usr/lib/lua/luci/controller/lora/overview.lua
local M = {}

-- 顯示 Overview 頁面
function M.action_overview()
    local uci               = require "luci.model.uci".cursor()

    -- 新結構：overview section
    local mode              = uci:get("linxdot_lora", "overview", "mode") or "udp"
    local concentrator_udp  = uci:get("linxdot_lora", "overview", "concentrator_udp") or "disable"
    local concentrator_mqtt = uci:get("linxdot_lora", "overview", "concentrator_mqtt") or "disable"
    local mesh              = uci:get("linxdot_lora", "overview", "mesh") or "disable"
    local mesh_role         = uci:get("linxdot_lora", "overview", "mesh_role") or "border"

    luci.template.render("lora/overview", {
        mode              = mode,
        concentrator_udp  = concentrator_udp,
        concentrator_mqtt = concentrator_mqtt,
        mesh              = mesh,
        mesh_role         = mesh_role
    })
end

-- 更新設定
function M.action_overview_set()
    local http              = require "luci.http"
    local uci               = require "luci.model.uci".cursor()

    local mode              = http.formvalue("mode")
    local concentrator_udp  = http.formvalue("concentrator_udp")
    local concentrator_mqtt = http.formvalue("concentrator_mqtt")
    local mesh              = http.formvalue("mesh")
    local mesh_role         = http.formvalue("mesh_role")

    -- 儲存模式
    if mode == "udp" or mode == "concentrator" then
        uci:set("linxdot_lora", "overview", "mode", mode)
    end

    if mode == "concentrator" then
        uci:set("linxdot_lora", "overview", "concentrator_udp", concentrator_udp or "disable")
        uci:set("linxdot_lora", "overview", "concentrator_mqtt", concentrator_mqtt or "disable")
        uci:set("linxdot_lora", "overview", "mesh", mesh or "disable")
        uci:set("linxdot_lora", "overview", "mesh_role", mesh_role or "border")
    else
        -- UDP 模式下，關閉所有 concentrator backend
        uci:set("linxdot_lora", "overview", "concentrator_udp", "disable")
        uci:set("linxdot_lora", "overview", "concentrator_mqtt", "disable")
        uci:set("linxdot_lora", "overview", "mesh", "disable")
        uci:set("linxdot_lora", "overview", "mesh_role", "border")
    end

    uci:commit("linxdot_lora")

    http.prepare_content("application/json")
    http.write_json({
        result            = "Configuration updated",
        mode              = mode,
        concentrator_udp  = concentrator_udp or "disable",
        concentrator_mqtt = concentrator_mqtt or "disable",
        mesh              = mesh or "disable",
        mesh_role         = mesh_role or "border"
    })
end

return M
