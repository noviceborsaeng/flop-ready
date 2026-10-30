#!/usr/bin/env bash
# FLOP miner readiness check for Linux (unofficial community tool).
#
# Checks whether this machine meets the known FLOP miner requirement (an NVIDIA
# GPU with at least 16 GB VRAM) and prints some extra system info.
# It only reads system information. It installs nothing and sends nothing.
#
# Usage:
#   bash check.sh         # English
#   bash check.sh --tr    # Türkçe

MIN_VRAM_GB=16
LANG_CODE=en
[ "$1" = "--tr" ] && LANG_CODE=tr

if [ "$LANG_CODE" = tr ]; then
  T_TITLE="FLOP miner hazırlık kontrolü (resmi değil)"
  T_OS="İşletim sistemi"
  T_GPU="Ekran kartı"
  T_DRIVER="NVIDIA sürücüsü"
  T_CUDA="CUDA (sürücünün desteklediği)"
  T_RAM="Sistem RAM"
  T_DISK="Boş disk alanı"
  T_NET="flop.finance erişilebilir"
  T_NONVIDIA="NVIDIA ekran kartı bulunamadı (nvidia-smi yok)"
  T_NEED="en az $MIN_VRAM_GB GB gerekli"
  T_YES="evet"; T_NO="hayır"
  T_READY="HAZIR: $MIN_VRAM_GB GB+ VRAM'li bir ekran kartın var."
  T_NOTREADY="HAZIR DEĞİL: FLOP için $MIN_VRAM_GB GB+ VRAM'li ekran kartı gerekli."
  T_NOTE="Resmi şart sadece $MIN_VRAM_GB GB VRAM. Diğer satırlar bilgi amaçlı."
  T_CLIENT="Resmi miner yazılımı henüz yayınlanmadı. Sadece flop.finance üzerinden indirin."
else
  T_TITLE="FLOP miner readiness check (unofficial)"
  T_OS="Operating system"
  T_GPU="GPU"
  T_DRIVER="NVIDIA driver"
  T_CUDA="CUDA (supported by driver)"
  T_RAM="System RAM"
  T_DISK="Free disk space"
  T_NET="flop.finance reachable"
  T_NONVIDIA="No NVIDIA GPU found (nvidia-smi missing)"
  T_NEED="needs $MIN_VRAM_GB GB+"
  T_YES="yes"; T_NO="no"
  T_READY="READY: you have a GPU with $MIN_VRAM_GB GB+ VRAM."
  T_NOTREADY="NOT READY: FLOP needs a GPU with $MIN_VRAM_GB GB+ VRAM."
  T_NOTE="Only the $MIN_VRAM_GB GB VRAM rule is official. Other lines are info only."
  T_CLIENT="There is no public miner client yet. Only download it from flop.finance."
fi

if [ -t 1 ]; then
  GREEN=$'\e[32m'; RED=$'\e[31m'; YELLOW=$'\e[33m'; GRAY=$'\e[90m'; CYAN=$'\e[36m'; RESET=$'\e[0m'
fi

line() {
  local color
  case "$1" in
    PASS) color=$GREEN ;; FAIL) color=$RED ;; WARN) color=$YELLOW ;; *) color=$GRAY ;;
  esac
  printf '%s[%s]%s %s: %s\n' "$color" "$1" "$RESET" "$2" "$3"
}

echo
echo "${CYAN}${T_TITLE}${RESET}"
echo "-----------------------------------------"

os_name=$( (. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME") || uname -sr )
line INFO "$T_OS" "$os_name ($(uname -m))"

ready=0
if command -v nvidia-smi >/dev/null 2>&1; then
  driver=""
  while IFS=',' read -r name mib driver; do
    name=$(echo "$name" | xargs); mib=$(echo "$mib" | xargs); driver=$(echo "$driver" | xargs)
    gb=$(awk -v m="$mib" 'BEGIN { printf "%.1f", m / 1024 }')
    if awk -v g="$gb" -v min="$MIN_VRAM_GB" 'BEGIN { exit !(g >= min - 0.5) }'; then
      ready=1
      line PASS "$T_GPU" "$name, $gb GB VRAM"
    else
      line FAIL "$T_GPU" "$name, $gb GB VRAM ($T_NEED)"
    fi
  done < <(nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader,nounits)
  line INFO "$T_DRIVER" "$(nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1)"

  cuda=$(nvidia-smi | grep -oP 'CUDA Version:\s*\K[\d.]+')
  [ -n "$cuda" ] && line INFO "$T_CUDA" "$cuda"
else
  line FAIL "$T_GPU" "$T_NONVIDIA"
  command -v lspci >/dev/null 2>&1 && lspci | grep -iE 'vga|3d|display' | sed 's/^/       - /'
fi

ram_gb=$(awk '/MemTotal/ { printf "%.1f", $2 / 1024 / 1024 }' /proc/meminfo)
line INFO "$T_RAM" "$ram_gb GB"

disk_gb=$(df -Pk / | awk 'NR==2 { printf "%.1f", $4 / 1024 / 1024 }')
line INFO "$T_DISK" "$disk_gb GB (/)"

if curl -sSfI --max-time 10 https://flop.finance >/dev/null 2>&1; then
  line PASS "$T_NET" "$T_YES"
else
  line WARN "$T_NET" "$T_NO"
fi

echo
if [ "$ready" = 1 ]; then
  echo "${GREEN}${T_READY}${RESET}"
else
  echo "${RED}${T_NOTREADY}${RESET}"
fi
echo "${GRAY}${T_NOTE}${RESET}"
echo "${GRAY}${T_CLIENT}${RESET}"
echo

[ "$ready" = 1 ] && exit 0 || exit 1
