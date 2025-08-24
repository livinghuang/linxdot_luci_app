#!/bin/sh
# 部署 luci-app-snapshot 到 Linxdot (開發模式)
# 用法: ./deploy.sh

set -e

echo "[INFO] 開始部署 luci-app-snapshot..."

# LuCI 目標目錄
LUCI_VIEW="/usr/lib/lua/luci/view"
LUCI_MENU="/usr/share/luci/menu.d"
LUCI_I18N="/usr/lib/lua/luci/i18n"

# 部署 view
if [ -d root/usr/lib/lua/luci/view ]; then
    echo "[INFO] 部署 view..."
    cp -vr root/usr/lib/lua/luci/view/* $LUCI_VIEW/
fi

# 部署 menu.json
if [ -d share/luci/menu.d ]; then
    echo "[INFO] 部署 menu..."
    cp -v share/luci/menu.d/*.json $LUCI_MENU/
fi

# 部署翻譯 (po 檔案要轉 lmo)
if command -v po2lmo >/dev/null 2>&1; then
    echo "[INFO] 編譯語言檔..."
    for f in po/*/*.po; do
        lang=$(basename "$(dirname "$f")")
        out="$LUCI_I18N/snapshot.$lang.lmo"
        echo " - $f → $out"
        po2lmo "$f" "$out"
    done
else
    echo "[WARN] po2lmo 未安裝，跳過翻譯部署"
fi

# 清快取 + 重啟 uhttpd
echo "[INFO] 清除 LuCI cache..."
rm -rf /tmp/luci-*

echo "[INFO] 重啟 uhttpd..."
/etc/init.d/uhttpd restart

echo "[INFO] 部署完成！請在瀏覽器測試 http://<Linxdot-IP>/cgi-bin/luci/admin/system/snapshot"