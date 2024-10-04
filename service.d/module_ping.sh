#!/system/bin/sh

# Fungsi log dengan pengecekan ukuran file log
log() {
  if [ -w /sdcard ]; then
    log_file="/sdcard/Module-log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> $log_file
    log_size=$(stat -c%s "$log_file")
    if [ $log_size -gt 256000 ]; then
      echo "" > $log_file
      log "Ukuran file log melebihi 250KB. File log dibuat ulang."
    fi
  else
    echo "Error: Tidak bisa menulis ke /sdcard. Periksa izin."
  fi
}

# Fungsi untuk mengecek keberadaan kartu SIM
check_sim() {
  if [ -n "$(getprop gsm.sim.state)" ]; then
    log "Kartu SIM terdeteksi."
    return 0  # Lanjutkan ke perintah berikutnya jika terdeteksi
  fi
  log "Kartu SIM tidak terdeteksi."
  return 1  # Jika tidak terdeteksi, hentikan dan ulangi loop
}

# Fungsi untuk memeriksa sinyal dan mengaktifkan data seluler
check_signal_and_data() {
  # Mengecek apakah ada sinyal jaringan dengan memeriksa properti 'gsm.network.type'
  if [ -n "$(getprop gsm.network.type)" ]; then
    log "Sinyal terdeteksi. Mengunci ke LTE."
    
    # Mengunci jaringan ke mode LTE
    su -c "settings put global preferred_network_mode 11"

    # Mengecek status data seluler, apakah sudah aktif atau belum
    if [ "$(getprop gsm.data.state)" != "CONNECTED" ]; then
      log "Data seluler tidak aktif. Mengaktifkan data."
      
      # Perintah untuk mengaktifkan data seluler
      su -c "svc data enable" || log "Error: Gagal mengaktifkan data seluler."
    else
      log "Data seluler sudah aktif."
    fi
    return 0  # Kembali jika sinyal dan data sudah aktif
  fi

  # Jika sinyal tidak terdeteksi, tunggu 2 detik
  log "Sinyal tidak terdeteksi, menunggu 2 detik..."
  sleep 2

  log "Sinyal masih tidak terdeteksi setelah pengecekan."
  return 1  # Mengembalikan nilai gagal jika sinyal tidak ditemukan
}

# Fungsi untuk memantau konektivitas melalui ping secara terus-menerus
ping_monitor() {
  ping_address=$(cat /sdcard/modem.txt 2>/dev/null || echo "8.8.8.8")
  if ping -c 1 -W 2 $ping_address > /dev/null; then
    log "Ping berhasil ke $ping_address"
    return 0  # Kembali jika ping berhasil
  else
    log "Ping gagal ke $ping_address."
    return 1  # Kembali jika ping gagal
  fi
}

# Fungsi untuk mengaktifkan/nonaktifkan mode pesawat
toggle_airplane_mode() {
  log "Mengaktifkan mode pesawat..."
  su -c "settings put global airplane_mode_on 1"
  su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"
  sleep 1  # Tunggu 1 detik
  log "Menonaktifkan mode pesawat..."
  su -c "settings put global airplane_mode_on 0"
  su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"

  log "Menunggu jaringan terhubung kembali setelah mode pesawat dimatikan..."
  sleep 2  # Tunggu untuk jaringan kembali aktif
}

# Loop utama
while true; do
  # Langkah 1: Memeriksa kartu SIM
  if ! check_sim; then
    continue  # Ulangi loop jika kartu SIM tidak terdeteksi
  fi

  # Langkah 2: Memeriksa sinyal dan mengaktifkan data seluler (1 kali pengecekan)
  if ! check_signal_and_data; then
    continue  # Ulangi loop jika sinyal tidak terdeteksi
  fi

  # Langkah 3: Memantau koneksi dengan ping secara terus-menerus
  attempt=0  # Inisialisasi percobaan ping
  while true; do
    if ping_monitor; then
      attempt=0  # Reset percobaan ke 0 jika ping berhasil
      sleep 2  # Tunggu sejenak sebelum melakukan ping lagi
    else
      attempt=$((attempt + 1))
      log "Ping gagal (percobaan $attempt)."
      
      # Jika ping gagal lebih dari 2 kali, lanjutkan ke Langkah 4
      if [ $attempt -ge 2 ]; then
        log "Ping gagal setelah 2 percobaan. Lanjut ke langkah 4."
        break  # Keluar dari loop ping dan masuk ke mode pesawat (Langkah 4)
      fi
    fi
  done

  # Langkah 4: Mengaktifkan/menonaktifkan mode pesawat dan cek koneksi
  if [ $attempt -ge 2 ]; then
    attempt=0  # Reset percobaan untuk mode pesawat
    while [ $attempt -lt 50 ]; do
      toggle_airplane_mode

      # Tunggu sebelum melakukan pengecekan ping lagi
      log "Menunggu 2 detik sebelum cek ping..."
      sleep 2  # Waktu tunggu agar data kembali aktif

      # Coba cek ping lagi setelah mode pesawat
      if ping_monitor; then
        log "Ping berhasil setelah mode pesawat dinonaktifkan."
        attempt=0  # Reset percobaan ke 0 jika ping berhasil
        break  # Keluar dari loop percobaan jika ping berhasil
      fi

      attempt=$((attempt + 1))
      log "Percobaan $attempt gagal. Mencoba lagi."
    done
  fi

  if [ $attempt -ge 50 ]; then
    log "Ping gagal setelah 50 percobaan. Menunggu 30 menit sebelum mencoba lagi..."
    sleep 1800  # Tunggu 30 menit sebelum mencoba lagi
  fi
done
