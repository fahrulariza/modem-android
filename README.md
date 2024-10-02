# Magisk Modem Android & Management Module
### Penjelasan
Modul ini mengelola smartphone yang di jadikan sebagai modem internet melalui pengaturan usb tethering. yang mana sering di gunakan di openwrt untuk sebagai sumber internet/`usb0`. biasanya di gunakan untuk peruntukan VPN seperti openclash dan lain". intinya sebagai monitoring site bug yang sering bengong.

### Fungsi
Modul ini menggunakan algoritma `shell abd` yang akan memonitor ping dari url yang menjadi indikator dalam melaksanakan tindakan seperti jaringan tidak merespon maka akan beralih ke mode pesawat otomatis untuk mengganti ip address internet pada smartphone.

### Cara Kerja / Perintah pada module_ping
 1. Module akan mengecek apakah terpasang simcard operator pada `simcard1`. jika tidak ada simcard maka tahan monitoring sampai ada simcard. jika simcard1 terdeteksi maka lanjutkan ke perintah no no 2.
 2. melakukan pengecekan status sinyal, jika status tidak `connected` maka tahan perintah dan kembalikan ke perintah 1 selanjutnya sampai ada sinyal . jika status `connected` maka lanjutkan ke perintah no 3 
 3. Melakukan Pengecekan apakah pengaturan `DATA` internet aktif. jika nonaktif maka akan mengaktifkan pengaturan `DATA` dan melanjutkan perintah no 4.
 4. Module akan memonitor url yang diberikan di `modem.txt` yang dibuat di 'internal/modem.txt' / storage internal android. jika tidak ada file modem.txt maka default cek url ping `8.8.8.8`. lanjut ke perintah no 4.
 5. Jika dalam 2 kali percobaan ping url gagal (dalam 1 kali percobaan selama 2 detik) maka akan otomatis beralih ke mengaktifkan mode pesawat dalam 2 detik lalu nonaktifkan mode pesawat kembali. Melanjutkan ke perintah no 5.
 6. jika berhasil melakukan ping pada url maka akan kembali ke perintah no 2. jika tidak berhasil maka ke perintah no 6.
 7. Module akan melakukan pengecekan berulang selama 50 kali percobaan, jika 50 kali percobaan maka module pengaktifkan perintah untuk bertahan selama 30 menit untuk mengulangi ke perintah 1.

## Cara Install

1. Download module `modem-android.zip` dari GitHub: https://github.com/fahrulariza/modem-android/releases
2. Buat file `modem.txt` di `/storage/emulated/0/modem.txt` / internal storage android. isi alamat url di file `modem.txt` seperti `google.com` atau `bug.com`. Jika tidak menyertakan URL, maka default adalah `8.8.8.8`.
3. Install module `modem-android.zip` menggunakan Magisk Manager.
4. restart Device.
   
## Pengaturan Lanjutan
1. kamu bisa mengganti URL ping dengan memberikan URL baru pada `modem.txt` tanpa menjalankan ulang module atau merestart ulang device.
2. untuk setiap log di sertakan di lokasi `/storage/emulated/0/Module-log.txt` / internal storage android dengan batasan file log sebesar 250kb

Selamat menggunakan!

## Catatan Pembuat
Modul ini kedepannya akan diperbaharui untuk mengelola modem Android seperti pengaturan auto tethering USB, auto debugging ADB, dan manajemen baterai.
sertakan credit pembuat jika ingin menyebarkan module ini.
Terimakasih.
