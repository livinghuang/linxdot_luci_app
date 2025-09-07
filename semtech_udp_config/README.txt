TTN Semtech global_conf.json.sx1250.* (generated)
=================================================
Generated: 2025-09-06T10:14:00.757038Z

These files map The Things Network frequency plans to Semtech UDP packet
forwarder configs for SX1302/SX1303 using SX1250 radios.

Included plans:
- EU863_870_TTN
- US902_928_FSB_2_TTN
- AU915_928_FSB_2_TTN
- AS923_AS1_TTN
- AS923_AS2_TTN
- CN470_510_FSB_1_TTN
- KR920_923_TTN
- IN865_867_TTN

Notes:
- LoRa std and FSK channels are enabled only when IF spans are safe and useful.
- RX2 settings are handled by the network server; devices may require matching RX2 DR.
- Verify local regulations (LBT/duty-cycle/etc) and adapt TX ranges and gains.

References:
- TTN Frequency Plans overview (uplink/downlink lists)
- TTN lorawan-frequency-plans repo (example radio centers for US FSB2)
