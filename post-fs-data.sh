#!/system/bin/sh

# Mematikan USB tethering dan WiFi
svc usb setFunctions ''
svc wifi disable

# Tunggu beberapa detik untuk memastikan perubahan diterapkan
sleep 2

# Mengatur IP dan subnet
IP_ADDRESS="192.168.10.1"
SUBNET_MASK="255.255.255.0"

# Mengatur iptables untuk mengatur IP default
ip addr add $IP_ADDRESS/24 dev wlan0

# Mengatur NAT untuk berbagi koneksi
iptables -t nat -A POSTROUTING -o rmnet0 -j MASQUERADE

# Mengaktifkan kembali WiFi dan USB tethering
svc wifi enable
svc usb setFunctions rndis
