# Magisk Modem Android & Management Module
### Penjelasan
Modul ini mengelola smartphone yang di jadikan sebagai modem internet pengaturan usb tethering. yang mana sering di gunakan di openwrt sebagai sumber internet.

### Fungsi
Modul ini akan memonitor ping dari url yang menjadi indikator dalam melaksanakan tindakan seperti jaringan tidak merespon maka akan beralih ke mode pesawat otomatis untuk mengganti ip address smartphone

### Cara Kerja
 1. Module akan mengecek apakah terpasang simcard operator pada 'simcard1'.
 2. jika ya maka melanjutkan pengecekan apakah pengaturan 'DATA' internet aktif. jika nonaktif maka akan mengaktifkan pengaturan 'DATA' dan melanjutkan perintah selanjutnya. 
 3. Module akan memonitor url yang diberikan di 'modem.txt' yang dibuat di 'internal/modem.txt' / storage internal android.
 4. Jika dalam 2 kali percobaan ping url gagal (dalam 1 kali percobaan selama 2 detik) maka akan otomatis beralih ke mengaktifkan mode pesawat dalam 2 detik lalu nonaktifkan mode pesawat kembali.
 5. jika dalam berhasil melakukan ping pada url maka akan kembali ke perintah no 2.
 6. Module akan melakukan pengecekan berulang selama 50 kali percobaan, jika 50 kali percobaan maka module pengaktifkan perintah untuk bertahan selama 30 menit untuk mengulangi ke perintah 1.

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
