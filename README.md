# this document to explain how to make lora luci app 

# Reflash uhttpd
```bash
rm -rf /tmp/luci* & /etc/init.d/uhttpd restart
```
 # Path for Luci Controller
```
 /usr/lib/lua/luci/controller/lora.lua
```
 # Path for Luci View
```bash
  /usr/lib/lua/luci/view/lora/udp.htm 
  /usr/lib/lua/luci/view/lora/overview.htm
```
command to clear and edit udp.htm
```bash
  rm /usr/lib/lua/luci/view/lora/udp.htm 
  vi /usr/lib/lua/luci/view/lora/udp.htm
```

command to clear and edit lora.lua controller
```bash
  rm /usr/lib/lua/luci/controller/lora.lua
  vi /usr/lib/lua/luci/controller/lora.lua
```

command to clear and edit overview.lua controller
```bash
  rm /usr/lib/lua/lora/overview.lua
  vi /usr/lib/lua/lora/overview.lua
```
command to clear and edit overview.htm viewer
```bash
  rm /usr/lib/lua/luci/view/lora/overview.htm
  vi /usr/lib/lua/luci/view/lora/overview.htm
```

command to clear and edit udp.lua controller
```bash
  rm /usr/lib/lua/lora/udp.lua
  vi /usr/lib/lua/lora/udp.lua
```

command to clear and edit udp.htm viewer
```bash
  rm /usr/lib/lua/luci/view/lora/udp.htm
  vi /usr/lib/lua/luci/view/lora/udp.htm
```

command to clear and edit concentrator.lua controller
```bash
  rm /usr/lib/lua/lora/concentrator.lua
  vi /usr/lib/lua/lora/concentrator.lua
```


concentrator_overview.htm
```bash
rm /usr/lib/lua/luci/view/lora/concentrator_overview.htm
vi /usr/lib/lua/luci/view/lora/concentrator_overview.htm
```
command to clear and edit concentrator_overview.lua controller
```bash
  rm /usr/lib/lua/lora/concentrator_overview.lua
  vi /usr/lib/lua/lora/concentrator_overview.lua
```

concentrator_udp.htm
```bash
rm /usr/lib/lua/luci/view/lora/concentrator_udp.htm
vi /usr/lib/lua/luci/view/lora/concentrator_udp.htm
```
command to clear and edit concentrator_overview.lua controller
```bash
  rm /usr/lib/lua/lora/concentrator_udp.lua
  vi /usr/lib/lua/lora/concentrator_udp.lua
```

concentrator_mqtt.htm
```bash
rm /usr/lib/lua/luci/view/lora/concentrator_mqtt.htm
vi /usr/lib/lua/luci/view/lora/concentrator_mqtt.htm
```
command to clear and edit concentrator_overview.lua controller
```bash
  rm /usr/lib/lua/lora/concentrator_mqtt.lua
  vi /usr/lib/lua/lora/concentrator_mqtt.lua
```

concentrator_mesh.htm
```bash
rm /usr/lib/lua/luci/view/lora/concentrator_mesh.htm
vi /usr/lib/lua/luci/view/lora/concentrator_mesh.htm
```
command to clear and edit concentrator_overview.lua controller
```bash
  rm /usr/lib/lua/lora/concentrator_mesh.lua
  vi /usr/lib/lua/lora/concentrator_mesh.lua
```




# path for picture
```
/www/luci-static/lora/
```

 # Path for UCI Config file

```
 /etc/config/linxdot_lora 
```

# Path for Traditonal Semtech UDP Package forwarder Setting
## in this folder xxx.json.xxx, it could setting region freq and server address
```
/etc/lora
```

# Path for Chirpstack Concentratord Package forwarder Setting
## in this folder xxx.toml, it only set the region freq for all multi forwarder use and it will not set the server address

```
/etc/linxdot-opensource/chirpstack-software/chirpstack-concentratord-binary/config
```
# Path for Chirpstack MQTT Forwarder Configure
## in this folder xxx.toml it could set the mqtt server address,user name and password,QoS. client id ,CA  ,
## but backend should fixed as concentratord (no use semtech UDP forwarder)  

```
/etc/linxdot-opensource/chirpstack-software/chirpstack-mqtt-forwarder-binary/config/chirpstack-mqtt-forwarder.toml
```

# path for Chirpstack UDP Forwarder  

```
 /etc/linxdot-opensource/chirpstack-software/chirpstack-udp-forwarder-binary/config/chirpstack-udp-forwarder.toml
```

# path for Chirpstack Mesh Forwarder  

```
 /etc/linxdot-opensource/chirpstack-software/chirpstack-gateway-mesh-binary/config/chirpstack-gateway-mesh.toml
```