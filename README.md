# Magisk Modem Ping Module

### Cara Compile dan Instalasi Magisk Module

1. Download atau clone repository ini.
2. Jalankan `install.sh` untuk Linux/Android atau `install.bat` untuk Windows.
   - Jika ingin mengganti URL ping, gunakan perintah:
     Android / Linux / Termux
     menggunakan Menggunakan curl:
     ```bash
     curl -L -o install.sh https://raw.githubusercontent.com/fahrulariza/modem-android/master/install.sh
     ```
     menggunakan Menggunakan wget:
     ```bash
     wget -O install.sh https://raw.githubusercontent.com/fahrulariza/modem-android/master/install.sh
     ```
     Setelah itu
     ```bash
     chmod +x install.sh
     ./install.sh
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


# Magisk Modem Management Module

Modul ini mengelola modem Android, pengaturan tethering USB, debugging ADB, dan manajemen baterai. Ikuti langkah-langkah berikut untuk instalasi:

## Cara Install

1. Download `install.sh` dari GitHub:

2. Jalankan script dengan Termux/Linux:
   ```curl
   curl -O https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/install.sh
   ```
Jika tidak menyertakan URL, default adalah `8.8.8.8`.

3. Setelah proses selesai, module `modem-android.zip` akan tersimpan di SD card.

4. Install module menggunakan Magisk Manager.

## Pengaturan Tambahan

- Anda bisa mengganti URL ping dengan menjalankan ulang script `install.sh` dan memberikan URL baru.

Selamat menggunakan!
