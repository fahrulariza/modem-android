#!/system/bin/sh

LOG_FILE="/sdcard/Module-log.txt"
MAX_LOG_SIZE=200000

log() {
  if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_FILE")
    if [ "$LOG_SIZE" -ge "$MAX_LOG_SIZE" ]; then
      > "$LOG_FILE"
    fi
  fi
  echo "$(date +'%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

configure_adb_usb() {
  setprop persist.service.adb.enable 1
  setprop persist.service.debuggable 1
  setprop persist.sys.usb.config "mtp,adb"
  log "Mengaktifkan ADB dan MTP"
}

check_android_version() {
  ANDROID_VERSION=$(getprop ro.build.version.sdk)

  if [ "$ANDROID_VERSION" -ge 21 ]; then
    log "Versi Android >= 5, mengaktifkan debugging wireless pada port 5555"
    setprop service.adb.tcp.port 5555
  fi
}

configure_usb_tethering() {
  # Check and enable USB tethering
  svc usb setFunctions rndis
  log "USB tethering diaktifkan, konfigurasi DHCP 192.168.88.1"
}

main() {
  configure_adb_usb
  configure_usb_tethering
  check_android_version
}

main
