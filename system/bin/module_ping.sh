#!/system/bin/sh

LOG_FILE="/sdcard/Module-log.txt"
MAX_LOG_SIZE=200000  # Max size 200KB
PING_URL=${1:-"8.8.8.8"}  # Default ping URL if not provided
SIM_CHECK_INTERVAL=10
SIGNAL_CHECK_INTERVAL=5
PING_RETRY_COUNT=0

log() {
  if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_FILE")
    if [ "$LOG_SIZE" -ge "$MAX_LOG_SIZE" ]; then
      > "$LOG_FILE"  # Truncate log file
    fi
  fi
  echo "$(date +'%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

check_sim() {
  # Check SIM card slot 1
  while ! getprop | grep -q 'ril.sim.state=READY'; do
    log "Menunggu SIM card terdeteksi"
    sleep $SIM_CHECK_INTERVAL
  done
  log "SIM card terdeteksi, melanjutkan"
}

check_signal() {
  # Check signal availability
  while ! getprop | grep -q 'gsm.operator.iso-country'; do
    log "Menunggu sinyal operator"
    sleep $SIGNAL_CHECK_INTERVAL
  done
  log "Sinyal operator tersedia, mengunci ke LTE dan mengaktifkan data"
  svc data enable
  svc wifi disable
}

ping_url() {
  for i in {1..3}; do
    if ping -c 1 -W 2 "$PING_URL"; then
      log "Ping berhasil ke $PING_URL"
      return 0
    fi
    log "Ping gagal, percobaan $i"
  done
  return 1
}

airplane_mode_toggle() {
  svc airplane_mode enable
  sleep 2
  svc airplane_mode disable
  log "Mode pesawat diaktifkan dan dinonaktifkan"
}

main_loop() {
  check_sim
  check_signal
  while true; do
    if ping_url; then
      PING_RETRY_COUNT=0
      sleep 10
      continue
    fi

    PING_RETRY_COUNT=$((PING_RETRY_COUNT + 1))

    if [ "$PING_RETRY_COUNT" -lt 5 ]; then
      log "Ping gagal, melakukan reset mode pesawat"
      airplane_mode_toggle
    else
      log "Ping gagal 5 kali berturut-turut, menunggu 40 menit dan mengaktifkan hotspot"
      svc wifi tethering on
      setprop wifi.supplicant.wpa_supplicant.conf "Modem Wifi"
      sleep 2400  # 40 minutes
      svc wifi tethering off
      PING_RETRY_COUNT=0
    fi
    sleep 10
  done
}

main_loop
