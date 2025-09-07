#!/usr/bin/env bash
# Linxdot Semtech UDP config 同步工具（純 ssh/scp/tar 版）
# 本機固定資料夾：semtech_udp_config/
# 遠端固定資料夾：/etc/lora
#
# 用法：
#   ./sync_freq_plans.sh pull              # 取回遠端 /etc/lora 的 global_conf.json* 到本機 semtech_udp_config/
#   ./sync_freq_plans.sh push              # 上傳本機 semtech_udp_config/ 的 global_conf.json* 到遠端（不刪除舊檔）
#   ./sync_freq_plans.sh push --prune      # 先刪除遠端符合 PATTERN 的檔，再上傳
#   ./sync_freq_plans.sh list              # 列出遠端符合 PATTERN 的檔案
#   ./sync_freq_plans.sh diff              # 對比本機與遠端檔名差異
#   ./sync_freq_plans.sh backup            # 打包遠端 /etc/lora 並下載到本機 _backup/
#
# 自訂環境變數：
#   LINXDOT_USER（預設：root）
#   LINXDOT_HOST（預設：192.168.0.186）
#   LINXDOT_PORT（預設：22）
#   PATTERN     （預設：global_conf.json*）

set -euo pipefail

# ===== 連線參數 =====
LINXDOT_USER="${LINXDOT_USER:-root}"
LINXDOT_HOST="${LINXDOT_HOST:-192.168.0.186}"
LINXDOT_PORT="${LINXDOT_PORT:-22}"

# ===== 路徑與模式 =====
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_DIR="${SCRIPT_DIR}/semtech_udp_config"
REMOTE_DIR="/etc/lora"
PATTERN="${PATTERN:-global_conf.json*}"

# ===== 小工具 =====
log() { printf "[%s] %s\n" "$(date +'%F %T')" "$*"; }
err() { printf "[ERROR] %s\n" "$*" >&2; }
die() { err "$*"; exit 1; }
ensure_local_dir() { mkdir -p "$LOCAL_DIR"; }

confirm() {
  read -r -p "$1 (y/N): " ans
  case "$ans" in y|Y) return 0 ;; *) return 1 ;; esac
}

remote_ls() {
  ssh -p "$LINXDOT_PORT" "$LINXDOT_USER@$LINXDOT_HOST" "ls -1 ${REMOTE_DIR}/${PATTERN} 2>/dev/null || true"
}

local_ls() {
  (cd "$LOCAL_DIR" && ls -1 ${PATTERN} 2>/dev/null || true)
}

# ===== 動作實作 =====
do_pull() {
  ensure_local_dir
  log "Pull: ${LINXDOT_USER}@${LINXDOT_HOST}:${REMOTE_DIR}/${PATTERN} -> ${LOCAL_DIR}/"
  # scp 遇到無檔案會报錯；用 subshell 嘗試先列出，有才 scp
  files=$(remote_ls || true)
  if [ -z "$files" ]; then
    log "遠端無符合 ${PATTERN} 的檔案。"
    return 0
  fi
  scp -P "$LINXDOT_PORT" ${LINXDOT_USER}@${LINXDOT_HOST}:"${REMOTE_DIR}/${PATTERN}" "${LOCAL_DIR}/" 2>/dev/null || true
  log "完成。"
}

do_push() {
  ensure_local_dir
  shopt -s nullglob
  local files=( "${LOCAL_DIR}"/${PATTERN} )
  shopt -u nullglob
  [ ${#files[@]} -gt 0 ] || die "本機 ${LOCAL_DIR}/ 下沒有 ${PATTERN} 可上傳。"

  if [ "${1:-}" = "--prune" ]; then
    log "刪除遠端符合 ${PATTERN} 的檔案（不清空整個資料夾）"
    confirm "確認刪除遠端 ${REMOTE_DIR}/${PATTERN}？" || { log "已取消"; exit 0; }
    ssh -p "$LINXDOT_PORT" "$LINXDOT_USER@$LINXDOT_HOST" "rm -f ${REMOTE_DIR}/${PATTERN} 2>/dev/null || true"
  fi

  log "Push: ${LOCAL_DIR}/${PATTERN} -> ${LINXDOT_USER}@${LINXDOT_HOST}:${REMOTE_DIR}/"
  # 直接 scp 上去；若要原子性更好，可改用 tar 串流到臨時目錄後再 mv
  scp -P "$LINXDOT_PORT" "${LOCAL_DIR}"/${PATTERN} "${LINXDOT_USER}@${LINXDOT_HOST}:${REMOTE_DIR}/"
  log "完成。需要時請自行重啟 packet forwarder。"
}

do_list() {
  log "Remote list ${REMOTE_DIR}/${PATTERN}:"
  remote_ls | sed 's/^/  /' || true
}

do_diff() {
  ensure_local_dir
  log "Compare LOCAL vs REMOTE (${PATTERN})"
  tmp_local=$(mktemp); tmp_remote=$(mktemp)
  local_ls | sort > "$tmp_local"
  remote_ls | xargs -n1 basename 2>/dev/null | sort > "$tmp_remote" || true

  log "Only in LOCAL (${LOCAL_DIR}/):"
  comm -23 "$tmp_local" "$tmp_remote" | sed 's/^/  /' || true
  log "Only in REMOTE (${REMOTE_DIR}/):"
  comm -13 "$tmp_local" "$tmp_remote" | sed 's/^/  /' || true

  rm -f "$tmp_local" "$tmp_remote"
}

do_backup() {
  ensure_local_dir
  local bname="etc_lora_$(date +'%Y%m%d_%H%M%S').tar.gz"
  local rpath="/tmp/${bname}"
  local ldst="${LOCAL_DIR}/_backup"
  mkdir -p "$ldst"

  log "遠端打包 ${REMOTE_DIR} -> ${rpath}"
  ssh -p "$LINXDOT_PORT" "$LINXDOT_USER@$LINXDOT_HOST" "tar czf ${rpath} -C / etc/lora"
  log "下載備份 -> ${ldst}/${bname}"
  scp -P "$LINXDOT_PORT" "${LINXDOT_USER}@${LINXDOT_HOST}:${rpath}" "${ldst}/${bname}"
  ssh -p "$LINXDOT_PORT" "$LINXDOT_USER@$LINXDOT_HOST" "rm -f ${rpath}" || true
  log "備份完成：${ldst}/${bname}"
}

usage() {
  cat <<EOF
用法：
  $0 pull              從遠端拉回 ${PATTERN} 到 ${LOCAL_DIR}/
  $0 push [--prune]    推送 ${LOCAL_DIR}/${PATTERN} 到遠端；--prune 先刪除遠端符合 PATTERN 的檔
  $0 list              列出遠端符合 PATTERN 的檔
  $0 diff              對比本機與遠端有哪些檔缺/多
  $0 backup            打包遠端 ${REMOTE_DIR} 並下載到 ${LOCAL_DIR}/_backup/
環境變數：
  LINXDOT_USER（預設：${LINXDOT_USER}）
  LINXDOT_HOST（預設：${LINXDOT_HOST}）
  LINXDOT_PORT（預設：${LINXDOT_PORT}）
  PATTERN     （預設：${PATTERN}）
說明：
  本腳本只用 ssh/scp/tar，適合沒有 rsync 的 Linxdot/OpenWrt 裝置。
EOF
}

ACTION="${1:-}"
case "$ACTION" in
  pull)   do_pull ;;
  push)   do_push "${2:-}" ;;
  list)   do_list ;;
  diff)   do_diff ;;
  backup) do_backup ;;
  *)      usage; exit 1 ;;
esac