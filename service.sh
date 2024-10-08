#!/system/bin/sh

# Mengatur MODDIR agar mengacu ke direktori modul saat ini
MODDIR=${0%/*}

# Menambahkan log untuk memantau eksekusi skrip
LOGFILE="/data/adb/service.d/service_log.txt"
echo "Menjalankan skrip service.sh pada $(date)" >> $LOGFILE

# Menghapus skrip dan log lama
rm -f /data/adb/service.d/module_ping.sh
rm -f /data/adb/service.d/module_ping.log
rm -f /data/adb/service.d/tethering.sh
rm -f /data/adb/service.d/service_log.txt

# Menyalin skrip module_ping.sh ke lokasi /data/adb/service.d/
cp -f "$MODDIR/service.d/module_ping.sh" /data/adb/service.d/module_ping.sh
cp -f "$MODDIR/service.d/tethering.sh" /data/adb/service.d/tethering.sh

# Memberikan izin eksekusi untuk module_ping.sh
chmod +x /data/adb/service.d/module_ping.sh
chmod 755 /data/adb/service.d/module_ping.sh
#chmod +x /data/adb/modules/modem_ping_monitor/service.d/module_ping.sh
#chmod 755 /data/adb/modules/modem_ping_monitor/service.d/module_ping.sh

# Memberikan hak akses untuk uninstall.sh agar bisa dieksekusi
chmod 755 /data/adb/modules/modem_ping_monitor/uninstall.sh

# Menjalankan module_ping.sh secara otomatis menggunakan sh
sh /data/adb/service.d/module_ping.sh >> /data/adb/service.d/module_ping.log 2>&1 &
#sh /data/adb/modules/modem_ping_monitor/service.d/module_ping.sh >> /data/adb/service.d/module_ping.log 2>&1 &

# Log penginstalan module_ping.sh
echo "Ping monitor installed. Script copied and started from /data/adb/service.d/" >> $LOGFILE

# Atur hak akses tethering.sh agar bisa dieksekusi
if [ -f /data/adb/service.d/tethering.sh ]; then
    chmod 755 /data/adb/service.d/tethering.sh
	chmod +x /data/adb/service.d/tethering.sh
	chmod -x /data/adb/service.d/tethering.sh
    echo "Hak akses tethering.sh telah diatur." >> $LOGFILE
else
    echo "File tethering.sh tidak ditemukan!" >> $LOGFILE
fi

# Jalankan tethering.sh yang terletak di $MODDIR/modem_ping_monitor/service.d/
if [ -f /data/adb/service.d/tethering.sh ]; then
    echo "========================" >> $LOGFILE
    echo "Menjalankan tethering.sh" >> $LOGFILE
    sh /data/adb/service.d/tethering.sh >> $LOGFILE 2>&1
else
    echo "========================" >> $LOGFILE
    echo "tethering.sh gagal ditemukan dan dijalankan!" >> $LOGFILE
fi

# Selesai
echo "========================" >> $LOGFILE
echo "Selesai menjalankan service.sh pada $(date)" >> $LOGFILE
echo "========================" >> $LOGFILE
