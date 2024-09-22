# Magisk Modem Ping Module

### Cara Compile dan Instalasi Magisk Module

1. Download atau clone repository ini.
2. Jalankan `install.sh` untuk Linux/Android atau `install.bat` untuk Windows.
   - Jika ingin mengganti URL ping, gunakan perintah:  
     ```bash
     ./install.sh "google.com"
     ``` 
     atau 
     ```bat
     install.bat google.com
     ```
     Jika tidak, maka akan menggunakan default `8.8.8.8`.
3. Zip akan dihasilkan dengan nama `MagiskModemPing.zip`, yang siap untuk diinstal melalui aplikasi Magisk.

### Struktur Modul
- **module_ping.sh**: Cek SIM, sinyal, dan monitoring ping.
- **module-adbau.sh**: Konfigurasi ADB dan USB tethering.
- **module-batt.sh**: Manajemen pengisian baterai.
