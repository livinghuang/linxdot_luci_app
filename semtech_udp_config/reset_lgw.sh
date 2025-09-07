#!/bin/sh

# This script is intended to be used on SX1302 CoreCell platform, it performs
# the following actions:
#       - export/unpexort GPIO(s) used to reset the SX1302 chip and to enable the LDOs
#       - export/unexport GPIO used to reset the optional SX1261 radio used for LBT/Spectral Scan
#
# Usage examples:
#       ./reset_lgw.sh stop
#       ./reset_lgw.sh start

# GPIO mapping has to be adapted with HW
#

SX1261_POWER_EN_PIN=23  # SX1261 power enable [GPIO0 RK_PC7]
SX1302_RESET_PIN=15     # SX1302 reset [GPIO0 RK_PB7]
SX1261_RESET_PIN=17     # SX1261 reset (LBT / Spectral Scan) [GPIO0 RK_PC1]

WAIT_GPIO() {
    /usr/bin/perl -e "select(undef, undef, undef, $1)"
}

init() {
    gpioctl dirout-low $SX1261_POWER_EN_PIN;
    gpioctl dirout-low $SX1302_RESET_PIN;
#    gpioctl dirout-low $SX1261_RESET_PIN;
}

reset() {
    echo "CoreCell reset through GPIO$SX1302_RESET_PIN..."
    echo "SX1261 reset through GPIO$SX1302_RESET_PIN..."
    echo "CoreCell power enable through GPIO$SX1261_POWER_EN_PIN..."

    # write output for SX1302 CoreCell power_enable and reset
    gpioctl dirout-high $SX1261_POWER_EN_PIN; WAIT_GPIO 0.1

    gpioctl dirout-high $SX1302_RESET_PIN; WAIT_GPIO 0.3
    gpioctl dirout-low $SX1302_RESET_PIN; WAIT_GPIO 0.1

    gpioctl dirout-high $SX1261_RESET_PIN; WAIT_GPIO 0.3
    gpioctl dirout-low $SX1261_RESET_PIN; WAIT_GPIO 0.1
}

term() {
    gpioctl dirin $SX1261_POWER_EN_PIN;
    gpioctl dirin $SX1302_RESET_PIN;
#    gpioctl dirin $SX1261_RESET_PIN;
}

case "$1" in
    start)
    term # just in case
    init
    reset
    ;;
    stop)
    reset
    term
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac

exit 0