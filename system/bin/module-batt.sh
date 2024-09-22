#!/system/bin/sh

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> /sdcard/Module-log.txt
  log_size=$(stat -c%s /sdcard/Module-log.txt)
  if [ $log_size -gt 204800 ]; then
    echo "" > /sdcard/Module-log.txt
  fi
}

while true; do
  battery_level=$(cat /sys/class/power_supply/battery/capacity)
  if [ "$battery_level" -eq 100 ]; then
    echo 0 > /sys/class/power_supply/battery/charging_enabled
    log "Pengisian dihentikan di 100%."
  elif [ "$battery_level" -eq 60 ]; then
    echo 1 > /sys/class/power_supply/battery/charging_enabled
    log "Pengisian diaktifkan kembali di 60%."
  fi
  sleep 60
done
