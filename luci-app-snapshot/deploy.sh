#!/bin/sh
# 部署 / 撤銷 luci-app-snapshot 到 Linxdot (開發模式)
# 用法:
#   ./deploy.sh deploy     # 部署
#   ./deploy.sh undeploy   # 撤銷
#   ./deploy.sh redeploy   # 先撤銷再部署

set -e

MODE=${1:-deploy}  # 預設是 deploy

# Source paths (專案內)
SRC_VIEW="root/usr/lib/lua/luci/view/snapshot"
SRC_MENU="root/usr/share/luci/menu.d/luci-app-snapshot.json"
SRC_PO="po"

# Target paths (Linxdot 系統內)
DST_VIEW="/usr/lib/lua/luci/view/snapshot"
DST_MENU="/usr/share/luci/menu.d/luci-app-snapshot.json"
DST_I18N="/usr/lib/lua/luci/i18n"

deploy() {
    echo "[INFO] 開始部署 luci-app-snapshot..."

    # 部署 view
    if [ -d "$SRC_VIEW" ]; then
        echo "[INFO] 部署 view → $DST_VIEW"
        mkdir -p "$DST_VIEW"
        cp -vr "$SRC_VIEW"/* "$DST_VIEW"/
    fi

    # 部署 menu.json
    if [ -f "$SRC_MENU" ]; then
        echo "[INFO] 部署 menu → $DST_MENU"
        cp -v "$SRC_MENU" "$DST_MENU"
    fi

    # 部署翻譯
    if command -v po2lmo >/dev/null 2>&1; then
        echo "[INFO] 編譯語言檔..."
        for f in $SRC_PO/*/*.po; do
            lang=$(basename "$(dirname "$f")")
            out="$DST_I18N/snapshot.$lang.lmo"
            echo " - $f → $out"
            po2lmo "$f" "$out"
        done
    else
        echo "[WARN] po2lmo 未安裝，跳過翻譯部署"
    fi

    restart_luci
    echo "[INFO] 部署完成！"
}

undeploy() {
    echo "[INFO] 撤銷 luci-app-snapshot..."

    rm -rf "$DST_VIEW"
    rm -f "$DST_MENU"
    rm -f "$DST_I18N"/snapshot.*.lmo

    restart_luci
    echo "[INFO] 撤銷完成！"
}

restart_luci() {
    echo "[INFO] 清除 LuCI cache..."
    rm -rf /tmp/luci-*

    echo "[INFO] 重啟 uhttpd..."
    /etc/init.d/uhttpd restart
}

case "$MODE" in
    deploy)   deploy ;;
    undeploy) undeploy ;;
    redeploy) undeploy; deploy ;;
    *)
        echo "用法: $0 {deploy|undeploy|redeploy}"
        exit 1
        ;;
esac