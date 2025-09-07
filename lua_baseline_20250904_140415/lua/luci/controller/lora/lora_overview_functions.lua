-- /usr/lib/lua/luci/controller/lora/lora_overview_functions.lua
-- 專門放 LoRa Overview 相關功能

local M = {}

-- Overview page
function M.action_overview()
    local uci = require "luci.model.uci".cursor()
    local mode = uci:get("linxdot_lora", "forwarder", "mode") or "udp"
    luci.template.render("lora/overview", { mode = mode })
end

-- Update mode
function M.action_overview_set()
    local http = require "luci.http"
    local uci  = require "luci.model.uci".cursor()

    local mode = http.formvalue("mode")
    if mode == "udp" or mode == "concentratord" then
        uci:set("linxdot_lora", "forwarder", "mode", mode)
        uci:commit("linxdot_lora")
    end

    http.redirect(luci.dispatcher.build_url("admin/lora/overview"))
end

return M
