#!/bin/sh
 while [ 1 ]
        do
            sleep 120 
            echo "Hello!!"
             cd /etc/lora/
             lora_pkt_fwd -c /etc/lora/global_conf.json.sx1250.US915
             sleep 20
        done

