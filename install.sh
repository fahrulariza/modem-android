#!/bin/bash

# Memastikan direktori modem-android ada
BASE_DIR="/data/adb/modules/modem-android"
mkdir -p "$BASE_DIR/META-INF/com/google/android"
mkdir -p "$BASE_DIR/system/bin"

# URL Ping yang diset melalui argumen
URL_PING=${1:-"8.8.8.8"}

# Menulis URL ke file modem.txt
echo "$URL_PING" > "$BASE_DIR/modem.txt"

# Daftar file dan path tujuan
FILES=(
    "META-INF/com/google/android/update-binary"
    "META-INF/com/google/android/updater-script"
    "system/bin/module_ping.sh"
    "system/bin/module-adbau.sh"
    "system/bin/module-batt.sh"
    "install.sh"
    "module.prop"
    "README.md"
)

BASE_URL="https://raw.githubusercontent.com/fahrulariza/modem-android/master/"

# Mengunduh setiap file ke lokasi yang sesuai
for FILE in "${FILES[@]}"; do
    TARGET_PATH="$BASE_DIR/$FILE"
    
    # Membuat direktori jika perlu
    mkdir -p "$(dirname "$TARGET_PATH")"
    
    # Mengunduh file
    if curl -o "$TARGET_PATH" "$BASE_URL$FILE"; then
        echo "Berhasil mengunduh $FILE"
    else
        echo "Gagal mengunduh $FILE"
        exit 1
    fi
done

echo "Proses selesai. Module terinstal di $BASE_DIR"
