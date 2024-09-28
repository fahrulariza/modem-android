# Magisk Modem Android & Management Module
### Penjelasan
Modul ini mengelola smartphone yang di jadikan sebagai modem internet pengaturan usb tethering. yang mana sering di gunakan di openwrt sebagai sumber internet.

### Fungsi
Modul ini akan memonitor ping dari url yang menjadi indikator dalam melaksanakan tindakan seperti jaringan tidak merespon maka akan beralih ke mode pesawat otomatis untuk mengganti ip address smartphone.

### Cara Kerja / Perintah pada module_ping
 1. Module akan mengecek apakah terpasang simcard operator pada `simcard1`. jika tidak ada simcard maka tahan monitoring sampai ada simcard. jika simcard1 terdeteksi maka lanjutkan ke perintah no 2.
 2. Melakukan Pengecekan apakah pengaturan `DATA` internet aktif. jika nonaktif maka akan mengaktifkan pengaturan `DATA` dan melanjutkan perintah no 3.
 3. Module akan memonitor url yang diberikan di `modem.txt` yang dibuat di 'internal/modem.txt' / storage internal android. jika tidak ada file modem.txt maka default cek url ping `8.8.8.8`.
 4. Jika dalam 2 kali percobaan ping url gagal (dalam 1 kali percobaan selama 2 detik) maka akan otomatis beralih ke mengaktifkan mode pesawat dalam 2 detik lalu nonaktifkan mode pesawat kembali. Melanjutkan ke perintah no 5.
 5. jika dalam berhasil melakukan ping pada url maka akan kembali ke perintah no 2. jika tidak berhasil maka ke perintah no 6.
 6. Module akan melakukan pengecekan berulang selama 50 kali percobaan, jika 50 kali percobaan maka module pengaktifkan perintah untuk bertahan selama 30 menit untuk mengulangi ke perintah 1.

### Cara Compile dan Instalasi Magisk Module
Modul ini kedepannya akan diperbaharui untuk mengelola modem Android seperti pengaturan auto tethering USB, auto debugging ADB, dan manajemen baterai. Ikuti langkah-langkah berikut untuk instalasi:

## Cara Install

1. Download module `modem-android.zip` dari GitHub: https://github.com/fahrulariza/modem-android/releases
2. Buat file `modem.txt` di `/storage/emulated/0/modem.txt` / internat android. isi url seperti `google.com`. Jika tidak menyertakan URL, maka default adalah `8.8.8.8`.
3. Install module menggunakan Magisk Manager.
4. restart Device.
   
## Cara Install
kamu bisa mengganti URL ping dengan memberikan URL baru pada `modem.txt` dan menjalan ulang module dengan merestart ulang device

Selamat menggunakan!
