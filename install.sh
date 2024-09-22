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
FILES=(
    "META-INF/com/google/android/update-binary"
    "META-INF/com/google/android/updater-script"
    "system/bin/module_ping.sh"
    "system/bin/module-adbau.sh"
    "system/bin/module-batt.sh"
    "install.sh"
    "module.prop"
    "readme.md"
)

for FILE in "${FILES[@]}"; do
    if wget -P /sdcard/modem-android "https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/$FILE"; then
        echo "Successfully downloaded $FILE"
    else
        echo "Failed to download $FILE"
    fi
done

# Kompres folder menjadi zip
cd /sdcard || { echo "Failed to change directory to /sdcard"; exit 1; }
zip -r modem-android.zip modem-android/
echo "Proses selesai. Module tersimpan di /sdcard/modem-android.zip"
