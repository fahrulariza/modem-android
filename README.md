# Magisk Modem Android & Management Module
### Penjelasan
Modul ini mengelola smartphone yang di jadikan sebagai modem internet pengaturan usb tethering. yang mana sering di gunakan di openwrt sebagai sumber internet.

### Fungsi
Modul ini akan memonitor ping dari url yang menjadi indikator dalam melaksanakan tindakan seperti jaringan tidak merespon maka akan beralih ke mode pesawat otomatis untuk mengganti ip address smartphone

### Cara Compile dan Instalasi Magisk Module
Modul ini mengelola modem Android, pengaturan tethering USB, debugging ADB, dan manajemen baterai. Ikuti langkah-langkah berikut untuk instalasi:

## Cara Install

1. Download `install.sh` dari GitHub:

2. Jalankan script dengan Termux/Linux:
   Download install.sh
   ```curl
   curl -O https://raw.githubusercontent.com/fahrulariza/modem-android/master/install.sh
   ```
3. Mengonversi format file teks dari DOS ke Unix
   ```dos2unix
   dos2unix install.sh
   ```
4. Mengubah permission pada file dan folder. Permission ini untuk masuk ke dalam folder
   ```chmod
   chmod +x install.sh
   ```
5. Perintah untuk menginstal
   ```bash
   bash ./install.sh "google.com"
   ```
   Jika tidak menyertakan URL, default adalah `8.8.8.8`. hasil pengisian URL tersimpan di `/storage/emulated/0/modem.txt`
3. Setelah proses selesai, module `modem-android.zip` akan tersimpan di internal memori device.

4. Install module menggunakan Magisk Manager.

## Pengaturan Tambahan

- Anda bisa mengganti URL ping dengan menjalankan ulang script `install.sh` dan memberikan URL baru.

Selamat menggunakan!
