module("lora.concentrator_overview", package.seeall)

function index()
  -- 不需要 entry，因為 dispatcher 已經處理
end

function render()
  local data = {
    gateway_id = "PLACEHOLDER_GATEWAY_ID",
    status = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_overview", data)
end
