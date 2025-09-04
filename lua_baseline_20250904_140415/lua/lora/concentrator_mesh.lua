module("lora.concentrator_mesh", package.seeall)

function render()
  local data = {
    mode     = "PLACEHOLDER_MODE",
    upstream = "PLACEHOLDER_UPSTREAM",
    status   = "PLACEHOLDER_STATUS"
  }
  luci.template.render("lora/concentrator_mesh", data)
end

