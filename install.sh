#!/bin/bash

# Memastikan direktori modem-android dan subdirektorinya ada
mkdir -p /storage/emulated/0/modem-android/META-INF/com/google/android
mkdir -p /storage/emulated/0/modem-android/system/bin

# URL Ping yang diset melalui argumen
URL_PING=${1:-"8.8.8.8"}

# Menulis URL ke file modem.txt
echo "$URL_PING" > /storage/emulated/0/modem-android/modem.txt

# Mengunduh file yang diperlukan
echo "Mengunduh file untuk Magisk module..."

# Daftar file dan path tujuan
declare -A FILES=(
    ["META-INF/com/google/android/update-binary"]="/storage/emulated/0/modem-android/META-INF/com/google/android/update-binary"
    ["META-INF/com/google/android/updater-script"]="/storage/emulated/0/modem-android/META-INF/com/google/android/updater-script"
    ["system/bin/module_ping.sh"]="/storage/emulated/0/modem-android/system/bin/module_ping.sh"
    ["system/bin/module-adbau.sh"]="/storage/emulated/0/modem-android/system/bin/module-adbau.sh"
    ["system/bin/module-batt.sh"]="/storage/emulated/0/modem-android/system/bin/module-batt.sh"
    ["install.sh"]="/storage/emulated/0/modem-android/install.sh"
    ["module.prop"]="/storage/emulated/0/modem-android/module.prop"
    ["README.md"]="/storage/emulated/0/modem-android/README.md"
)

BASE_URL="https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/"

# Mengunduh setiap file ke lokasi yang sesuai
for FILE in "${!FILES[@]}"; do
    if wget -O "${FILES[$FILE]}" "$BASE_URL$FILE"; then
        echo "Successfully downloaded $FILE"
    else
        echo "Failed to download $FILE"
    fi
done

# Kompres folder menjadi zip
cd /storage/emulated/0 || { echo "Failed to change directory to /storage/emulated/0"; exit 1; }
zip -r modem-android.zip modem-android/
echo "Proses selesai. Module tersimpan di /storage/emulated/0/modem-android.zip"
