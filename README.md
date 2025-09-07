# this document to explain how to make lora luci app 

# Reflash uhttpd
```bash
rm -rf /tmp/luci* & /etc/init.d/uhttpd restart
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