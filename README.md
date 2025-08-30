# this document to explain how to make lora luci app 

# reflash uhttpd
```bash
rm -rf /tmp/luci* & /etc/init.d/uhttpd restart
```
 # Path for Luci Controller

 /usr/lib/lua/luci/controller/lora.lua

 # Path for Luci View
```bash
/usr/lib/lua/luci/view/lora/udp.htm 
/usr/lib/lua/luci/view/overview.htm
```

```bash
rm /usr/lib/lua/luci/view/lora/udp.htm & vi /usr/lib/lua/luci/view/lora/udp.htm
```


 # Path for UCI Config file

 /etc/config/linxdot_lora 