#!/system/bin/sh

# Menambahkan log agar dapat memantau eksekusi skrip
LOGFILE="/data/adb/service_log.txt"
echo "Menjalankan skrip service.sh pada $(date)" >> $LOGFILE

# Lokasi flag untuk menandai bahwa skrip sudah dijalankan
FLAG_FILE="/data/adb/magisk_tethering_flag"

# Cek apakah skrip sudah pernah dijalankan
if [ -f "$FLAG_FILE" ]; then
  echo "Skrip sudah pernah dijalankan, tidak akan dijalankan lagi." >> $LOGFILE
  exit 0
fi

# Mematikan USB tethering dan WiFi
svc usb setFunctions ''
svc wifi disable
echo "Mematikan USB tethering dan WiFi" >> $LOGFILE

# Tunggu beberapa detik untuk memastikan perubahan diterapkan
sleep 2

# Mengatur IP dan subnet untuk WiFi (wlan0)
IP_WIFI="192.168.10.1"
SUBNET_WIFI="255.255.255.0"

# Mengatur IP dan subnet untuk USB tethering (rndis0)
IP_USB="192.168.42.1"
SUBNET_USB="255.255.255.0"

# Menetapkan IP untuk antarmuka WiFi (wlan0)
ip addr add $IP_WIFI/24 dev wlan0
echo "Menetapkan IP $IP_WIFI ke antarmuka wlan0" >> $LOGFILE

# Menetapkan IP untuk antarmuka USB tethering (rndis0)
ip addr add $IP_USB/24 dev rndis0
echo "Menetapkan IP $IP_USB ke antarmuka rndis0" >> $LOGFILE

# Mengatur NAT untuk berbagi koneksi internet melalui antarmuka seluler (rmnet0)
iptables -t nat -A POSTROUTING -o rmnet0 -j MASQUERADE
echo "NAT diterapkan pada antarmuka rmnet0" >> $LOGFILE

# Mengatur iptables untuk meneruskan paket dari WiFi dan USB tethering
iptables -A FORWARD -i wlan0 -o rmnet0 -j ACCEPT
iptables -A FORWARD -i rndis0 -o rmnet0 -j ACCEPT
echo "Paket diteruskan antara wlan0, rndis0, dan rmnet0" >> $LOGFILE

# Mengaktifkan kembali WiFi dan USB tethering
svc wifi enable
svc usb setFunctions rndis
echo "WiFi dan USB tethering diaktifkan kembali" >> $LOGFILE

# Membuat file flag sebagai tanda bahwa skrip sudah dijalankan
touch "$FLAG_FILE"
echo "Flag file dibuat untuk menandai bahwa skrip sudah dijalankan" >> $LOGFILE

# Menutup log dengan penanda waktu selesai
echo "Skrip selesai dijalankan pada $(date)" >> $LOGFILE
