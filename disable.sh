#!/system/bin/sh

# Mendapatkan direktori modul
MODDIR=${0%/*}

# Menentukan lokasi direktori service.d
SERVICE_DIR="/data/adb/modules/modem_ping_monitor/service.d/"

# Cek apakah module_ping.sh ada sebelum dinonaktifkan
if [ -f "$SERVICE_DIR/module_ping.sh" ]; then
    # Menghentikan proses yang sedang berjalan
    pkill -f "module_ping.sh"
    echo "Ping monitor dinonaktifkan."
else
    echo "Error: module_ping.sh tidak ditemukan di $SERVICE_DIR."
fi
