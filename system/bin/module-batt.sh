#!/system/bin/sh

LOG_FILE="/sdcard/Module-log.txt"
MAX_LOG_SIZE=200000
CHARGE_STOP=100
CHARGE_START=60

log() {
  if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_FILE")
    if [ "$LOG_SIZE" -ge "$MAX_LOG_SIZE" ]; then
      > "$LOG_FILE"
    fi
  fi
  echo "$(date +'%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

check_battery() {
  while true; do
    BATTERY_LEVEL=$(dumpsys battery | grep level | awk '{print $2}')
    if [ "$BATTERY_LEVEL" -ge "$CHARGE_STOP" ]; then
      echo 0 > /sys/class/power_supply/battery/charging_enabled
      log "Pengisian dihentikan, baterai mencapai $CHARGE_STOP%"
    elif [ "$BATTERY_LEVEL" -le "$CHARGE_START" ]; then
      echo 1 > /sys/class/power_supply/battery/charging_enabled
      log "Pengisian dimulai kembali, baterai turun ke $CHARGE_START%"
    fi
    sleep 60
  done
}

check_battery
