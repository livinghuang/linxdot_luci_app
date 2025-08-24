#!/bin/sh
# 移除 luci-app-snapshot (撤銷部署)
# 用法: ./undeploy.sh

set -e

echo "[INFO] 撤銷 luci-app-snapshot..."

LUCI_VIEW="/usr/lib/lua/luci/view/snapshot"
LUCI_MENU="/usr/share/luci/menu.d/luci-app-snapshot.json"
LUCI_I18N="/usr/lib/lua/luci/i18n/snapshot.*.lmo"

# 移除 view
if [ -d "$LUCI_VIEW" ]; then
    echo "[INFO] 移除 view: $LUCI_VIEW"
    rm -rf "$LUCI_VIEW"
fi

# 移除 menu.json
if [ -f "$LUCI_MENU" ]; then
    echo "[INFO] 移除 menu: $LUCI_MENU"
    rm -f "$LUCI_MENU"
fi

# 移除翻譯檔
if ls $LUCI_I18N >/dev/null 2>&1; then
    echo "[INFO] 移除語言檔: $LUCI_I18N"
    rm -f $LUCI_I18N
fi

# 清快取 + 重啟 uhttpd
echo "[INFO] 清除 LuCI cache..."
rm -rf /tmp/luci-*

echo "[INFO] 重啟 uhttpd..."
/etc/init.d/uhttpd restart

echo "[INFO] 撤銷完成！"