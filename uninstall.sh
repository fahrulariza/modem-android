#!/system/bin/sh

# Mengatur MODDIR agar mengacu ke direktori modul saat ini
MODDIR=${0%/*}

# Menambahkan log untuk memantau eksekusi skrip uninstall
LOGFILE="/data/adb/modules/uninstall_log.txt"
echo "Menjalankan skrip uninstall.sh pada $(date)" >> $LOGFILE

# Menghapus skrip dan log yang dibuat oleh modul
rm -f /data/adb/service.d/module_ping.sh
rm -f /data/adb/service.d/module_ping.log
rm -f /data/adb/modules/modem_ping_monitor/service.d/tethering.sh
# rm -f "$LOGFILE"

# Menghapus direktori modul
if [ -d "$MODDIR" ]; then
    rm -rf "$MODDIR"
    echo "Direktori modul $MODDIR telah dihapus." >> $LOGFILE
else
    echo "Direktori modul tidak ditemukan." >> $LOGFILE
fi

# Selesai
echo "Selesai menjalankan uninstall.sh pada $(date)" >> $LOGFILE
