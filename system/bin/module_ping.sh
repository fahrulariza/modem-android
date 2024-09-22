#!/system/bin/sh

# Log function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> /sdcard/Module-log.txt
  log_size=$(stat -c%s /sdcard/Module-log.txt)
  if [ $log_size -gt 204800 ]; then
    echo "" > /sdcard/Module-log.txt
  fi
}

# Start checking SIM card
log "Memulai pengecekan SIM card..."
while [ -z "$(getprop gsm.sim.state)" ]; do
  sleep 5
done
log "SIM card terdeteksi."

# Check signal
while [ -z "$(getprop gsm.network.type)" ]; do
  log "Menunggu sinyal..."
  sleep 5
done
log "Sinyal terdeteksi, mengunci jaringan LTE dan mengaktifkan data."

svc data enable
settings put global preferred_network_mode 11

# Ping function
ping_monitor() {
  ping_address=$(cat /sdcard/modem.txt 2>/dev/null || echo "8.8.8.8")
  for i in {1..3}; do
    if ping -c 1 -W 2 $ping_address > /dev/null; then
      log "Ping berhasil ke $ping_address"
      return 0
    else
      log "Ping gagal ke $ping_address"
    fi
  done
  return 1
}

attempt=0
while [ $attempt -lt 5 ]; do
  if ping_monitor; then
    attempt=0
    continue
  else
    log "Ping gagal 3 kali, mengaktifkan mode pesawat..."
    svc airplane_mode enable
    sleep 2
    svc airplane_mode disable
    log "Mode pesawat dinonaktifkan."
    attempt=$((attempt + 1))
  fi
done

log "Ping gagal setelah 5 kali percobaan. Mengaktifkan Wi-Fi hotspot."
svc wifi enable
settings put global tethering_wifi_ssid "Modem Wifi"
settings put global tethering_wifi_passphrase "2341qwert#"
sleep 2400

svc wifi disable
log "Wi-Fi hotspot dinonaktifkan, mengulangi pengecekan."
