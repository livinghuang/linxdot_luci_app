module("lora.concentrator_mqtt", package.seeall)

function render()
  local data = {
    broker = "PLACEHOLDER_BROKER",
    user   = "PLACEHOLDER_USER",
    status = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_mqtt", data)
end
