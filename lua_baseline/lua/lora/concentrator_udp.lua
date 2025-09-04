module("lora.concentrator_udp", package.seeall)

function render()
  local data = {
    server = "PLACEHOLDER_SERVER",
    port   = "PLACEHOLDER_PORT",
    status = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_udp", data)
end

