#!/system/bin/sh

# Install script
MODDIR=${0%/*}

# Memberikan izin eksekusi untuk module_ping.sh
chmod +x "$MODDIR/service.d/module_ping.sh"

# Menyalin script module_ping.sh ke lokasi /data/adb/service.d/
#cp "$MODDIR/service.d/module_ping.sh" /data/adb/service.d/

# Menjalankan module_ping.sh secara otomatis menggunakan sh
sh $MODDIR/service.d/module_ping.sh #>> $MODDIR/service.d/module_ping.log 2>&1 &

# Menampilkan log atau pesan di terminal
echo "Ping monitor installed. Script copied and started from /data/adb/service.d/"
