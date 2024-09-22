#!/system/bin/sh

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> /sdcard/Module-log.txt
  log_size=$(stat -c%s /sdcard/Module-log.txt)
  if [ $log_size -gt 204800 ]; then
    echo "" > /sdcard/Module-log.txt
  fi
}

# Auto USB tethering
log "Memulai pengecekan tethering USB."
svc usb setFunctions rndis

# Set DHCP for tethering
log "Mengatur DHCP tethering ke 192.168.88.0/24."
settings put global tether_dhcp_range "192.168.88.0 192.168.88.24"

# Enable developer options and ADB
log "Mengaktifkan opsi pengembang dan ADB."
settings put global development_settings_enabled 1
setprop persist.service.adb.enable 1
setprop persist.service.debuggable 1
setprop persist.sys.usb.config mtp,adb

# Wireless debugging on port 5555
log "Mengaktifkan wireless debugging."
setprop service.adb.tcp.port 5555
start adbd
