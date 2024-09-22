#!/bin/bash
# Memastikan direktori modem-android ada
mkdir -p ~/modem-android
cd ~/modem-android
# URL Ping yang diset melalui argumen
URL_PING=${1:-"8.8.8.8"}
# Menulis URL ke file modem.txt
echo "$URL_PING" > /sdcard/modem-android/modem.txt
# Mengunduh file yang diperlukan
echo "Mengunduh file untuk Magisk module..."
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/META-INF/com/google/android/update-binary
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/META-INF/com/google/android/updater-script
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module_ping.sh
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module-adbau.sh
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module-batt.sh
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/install.sh
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/module.prop
wget -P /sdcard/modem-android https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/readme.md
# Kompres folder menjadi zip
cd /sdcard
zip -r modem-android.zip modem-android/
echo "Proses selesai. Module tersimpan di /sdcard/modem-android.zip"
