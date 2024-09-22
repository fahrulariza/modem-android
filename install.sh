#!/bin/bash

# Menggunakan path default untuk penyimpanan internal
BASE_DIR="/storage/emulated/0"

# Memastikan direktori modem-android ada
mkdir -p "$BASE_DIR/modem-android/META-INF/com/google/android"
mkdir -p "$BASE_DIR/modem-android/system/bin"

# URL Ping yang diset melalui argumen
URL_PING=${1:-"8.8.8.8"}

# Menulis URL ke file modem.txt di direktori internal
echo "$URL_PING" > "$BASE_DIR/modem.txt"

# Mengunduh file yang diperlukan
echo "Mengunduh file untuk Magisk module..."

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

BASE_URL="https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/"

# Mengunduh setiap file ke lokasi yang sesuai
for FILE in "${FILES[@]}"; do
    TARGET_PATH="$BASE_DIR/modem-android/$FILE"
    
    # Membuat direktori jika perlu
    mkdir -p "$(dirname "$TARGET_PATH")"
    
    # Mengunduh file
    if wget -O "$TARGET_PATH" "$BASE_URL$FILE"; then
        echo "Successfully downloaded $FILE"
    else
        echo "Failed to download $FILE"
    fi
done

# Kompres file dalam folder menjadi zip tanpa menyertakan folder modem-android
cd "$BASE_DIR/modem-android" || { echo "Failed to change directory"; exit 1; }
zip -r "$BASE_DIR/modem-android.zip" ./*
cd "$BASE_DIR" || { echo "Failed to change directory"; exit 1; }

echo "Proses selesai. Module tersimpan di $BASE_DIR/modem-android.zip"
