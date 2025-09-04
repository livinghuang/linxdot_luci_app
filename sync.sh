#!/bin/bash
# Linxdot LuCI 開發同步工具
# 用法：
#   ./sync.sh pull [custom_name]   # 從 Linxdot 拉回 /usr/lib/lua/ 到 ./lua_baseline_<custom_name>/
#   ./sync.sh push [name]          # 清空 Linxdot /usr/lib/lua/ 並推送 ./lua_baseline_<name>/ 上去

LINXDOT_USER=root
LINXDOT_HOST=192.168.0.186
LINXDOT_PORT=22

REMOTE_BASE="/usr/lib/lua/"
REMOTE_BASE_UPPER_FOLDER="/usr/lib/"
LOCAL_BASE="./lua_baseline"

if [ $# -lt 1 ]; then
  echo "用法: $0 {pull|push} [name]"
  exit 1
fi

ACTION=$1
NAME=$2

case "$ACTION" in
  pull)
    if [ -z "$NAME" ]; then
      NAME=$(date +"%Y%m%d_%H%M%S")
    fi
    LOCAL_DIR="${LOCAL_BASE}_${NAME}/"

    echo "[INFO] Pulling from Linxdot: $REMOTE_BASE -> $LOCAL_DIR"
    mkdir -p "$LOCAL_DIR"
    scp -r -P $LINXDOT_PORT $LINXDOT_USER@$LINXDOT_HOST:"$REMOTE_BASE" "$LOCAL_DIR"
    ;;
  push)
    if [ -z "$NAME" ]; then
      echo "[INFO] 可用的 baseline 版本："
      select DIR in ${LOCAL_BASE}_*/; do
        if [ -n "$DIR" ]; then
          LOCAL_DIR="$DIR"
          break
        else
          echo "無效選擇，請重新選擇。"
        fi
      done
    else
      LOCAL_DIR="${LOCAL_BASE}_${NAME}/"
    fi

    if [ ! -d "$LOCAL_DIR" ]; then
      echo "[ERROR] 找不到本地目錄: $LOCAL_DIR"
      exit 1
    fi

    echo "[INFO] 選擇的目錄: $LOCAL_DIR"
    read -p "⚠️ 確定要清空並覆蓋 Linxdot 的 $REMOTE_BASE ? (y/n): " CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
      echo "[INFO] 已取消推送。"
      exit 0
    fi

    echo "[INFO] 清空 Linxdot 端的 $REMOTE_BASE ..."
    ssh -p $LINXDOT_PORT $LINXDOT_USER@$LINXDOT_HOST "rm -rf ${REMOTE_BASE}*"

    echo "[INFO] Pushing to Linxdot: $LOCAL_DIR -> $REMOTE_BASE_UPPER_FOLDER"
    scp -r -P $LINXDOT_PORT "$LOCAL_DIR"* $LINXDOT_USER@$LINXDOT_HOST:"$REMOTE_BASE_UPPER_FOLDER"

    if [ $? -eq 0 ]; then
      echo "[INFO] Push 完成，正在清理快取並重啟 uhttpd..."
      ssh -p $LINXDOT_PORT $LINXDOT_USER@$LINXDOT_HOST "rm -rf /tmp/luci* && /etc/init.d/uhttpd restart"
    else
      echo "[ERROR] Push 失敗！"
    fi
    ;;
  *)
    echo "未知動作: $ACTION"
    echo "用法: $0 {pull|push} [name]"
    exit 1
    ;;
esac