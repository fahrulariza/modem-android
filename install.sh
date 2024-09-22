#!/bin/bash

ping_url=${1:-"8.8.8.8"}
sdcard_path="/sdcard/modem.txt"
echo "$ping_url" > "$sdcard_path"

download_file() {
  url=$1
  path=$2
  curl -L "$url" -o "$path"
}

mkdir -p MagiskModemPing/META-INF/com/google/android/
mkdir -p MagiskModemPing/system/bin/

# Download necessary files
download_file "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/META-INF/com/google/android/update-binary" "MagiskModemPing/META-INF/com/google/android/update-binary"
download_file "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/META-INF/com/google/android/updater-script" "MagiskModemPing/META-INF/com/google/android/updater-script"
download_file "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module_ping.sh" "MagiskModemPing/system/bin/module_ping.sh"
download_file "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module-adbau.sh" "MagiskModemPing/system/bin/module-adbau.sh"
download_file "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module-batt.sh" "MagiskModemPing/system/bin/module-batt.sh"
download_file "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/module.prop" "MagiskModemPing/module.prop"
