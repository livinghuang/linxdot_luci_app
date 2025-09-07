#!/bin/sh
# Update global_conf.json with values from UCI (linxdot_lora.forwarder)

REGION=$(uci get linxdot_lora.forwarder.region)
SERVER=$(uci get linxdot_lora.forwarder.server)
PORT_UP=$(uci get linxdot_lora.forwarder.port_up)
PORT_DOWN=$(uci get linxdot_lora.forwarder.port_down)
GATEWAY_ID=$(uci get linxdot_lora.forwarder.gateway_id)

GLOBAL_CONF="/etc/lora/global_conf.json.sx1250.$REGION"

if [ ! -f "$GLOBAL_CONF" ]; then
    echo "[ERROR] $GLOBAL_CONF not found!"
    exit 1
fi

# 用 sed 更新 (只改 server / ports / gateway_id)
sed -i "s/\"server_address\".*,/\"server_address\":\"$SERVER\",/" $GLOBAL_CONF
sed -i "s/\"serv_port_up\".*,/\"serv_port_up\": $PORT_UP,/" $GLOBAL_CONF
sed -i "s/\"serv_port_down\".*,/\"serv_port_down\": $PORT_DOWN,/" $GLOBAL_CONF
sed -i "s/\"gateway_ID\".*,/\"gateway_ID\": \"$GATEWAY_ID\",/" $GLOBAL_CONF

echo "[INFO] Updated $GLOBAL_CONF with:"
echo "  region     = $REGION"
echo "  server     = $SERVER"
echo "  port_up    = $PORT_UP"
echo "  port_down  = $PORT_DOWN"
echo "  gateway_id = $GATEWAY_ID"
