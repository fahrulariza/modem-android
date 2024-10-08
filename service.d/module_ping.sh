#!/system/bin/sh

# Penundaan eksekusi Perintah untuk waktu yang ditentukan untuk menunggu perangkat sepenuhnya menyala ke UI
log "periode sebelum skrip dijalankan"
sleep 90  # Penundaan selama 60 detik (sesuaikan dengan kebutuhan)

# Fungsi log dengan pengecekan ukuran file log
log() {
  # Membaca nilai debugging dari modem.txt
  debugging_config=$(grep -E '^debugging=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

  # Jika debugging_config kosong, gunakan default "yes"
  if [[ -z "$debugging_config" ]]; then
    debugging_config="yes"
  fi

  # Jika debugging_config adalah "no", lewati pencatatan log
  if [[ "$debugging_config" == "no" ]]; then
    return  # Tidak mencatat log, langsung kembali
  fi

  # Membaca ukuran file log dari modem.txt
  log_size_limit=$(grep -E '^log.size=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

  # Jika log_size_limit kosong, gunakan default 250 KB
  if [[ -z "$log_size_limit" ]]; then
    log_size_limit=250
  fi

  # Memastikan log_size_limit adalah angka sebelum melakukan perhitungan
  if ! [[ "$log_size_limit" =~ ^[0-9]+$ ]]; then
    log_size_limit=250  # Atur ke default jika bukan angka
  fi

  # Menghitung ukuran dalam byte (1 KB = 1024 Bytes)
  log_size_bytes=$((log_size_limit * 1024))

  # Pencatatan log
  if [ -w /storage/emulated/0 ]; then
    log_file="/storage/emulated/0/Module-log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> $log_file
    current_log_size=$(stat -c%s "$log_file")
    
    if [ "$current_log_size" -gt "$log_size_bytes" ]; then
      echo "" > $log_file
      echo "$(date '+%Y-%m-%d %H:%M:%S') | Ukuran file log melebihi ${log_size_limit}KB. File log dibuat ulang." >> $log_file
    fi
  else
    echo "Error: Tidak bisa menulis ke /storage/emulated/0. Periksa izin."
  fi
}



# Fungsi untuk mengecek keberadaan kartu SIM
check_sim() {

# Ambil semua PID dari module_ping.sh
PIDS=$(pgrep -f module_ping.sh)

# Cek apakah ada lebih dari satu PID
if [ -n "$PIDS" ]; then
    first_pid=$(echo "$PIDS" | awk 'NR==1')  # Ambil PID pertama
    echo "$PIDS" | awk 'NR>1' | while read -r pid; do  # Ambil PID sisanya
        log "Menghentikan proses module_ping.sh dengan PID: $pid"
        kill "$pid"  # Bunuh PID tersebut
    done
else
    log "Tidak ada proses module_ping.sh yang perlu dihentikan."
fi
	
  # Membaca nilai cek.sim dari modem.txt
  cek_sim_config=$(grep -E '^cek.sim=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

  # Jika cek_sim_config kosong, gunakan default "yes"
  if [[ -z "$cek_sim_config" ]]; then
    cek_sim_config="yes"
  fi

  # Jika cek_sim_config adalah "no", lewati pengecekan SIM
  if [[ "$cek_sim_config" == "no" ]]; then
    log "Pengecekan kartu SIM dilewati sesuai pengaturan."
    return 0  # Lanjutkan ke perintah berikutnya
  fi

  # Membaca status SIM dari file modem.txt
  sim_state_config=$(grep -E '^gsm.sim.state=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

  # Jika sim_state_config kosong, gunakan default "LOADED"
  if [[ -z "$sim_state_config" ]]; then
    sim_state_config="LOADED"
  fi

  # Mendapatkan status SIM saat ini
  sim_state=$(getprop gsm.sim.state)  # Mendapatkan status SIM
  
  if [[ $sim_state == *"$sim_state_config"* ]]; then  # Cek apakah status SIM sesuai
    log "Kartu SIM terdeteksi: $sim_state"
    return 0  # Lanjutkan ke perintah berikutnya jika terdeteksi
  else
    log "Kartu SIM tidak terdeteksi: $sim_state"
    return 1  # Jika tidak terdeteksi, hentikan dan ulangi loop
  fi
}

# Fungsi untuk memeriksa sinyal dan mengaktifkan data seluler
check_signal_and_data() {
  # Mengecek apakah ada sinyal jaringan dengan memeriksa properti 'gsm.network.type'
  if [ -n "$(getprop gsm.network.type)" ]; then
    log "Sinyal terdeteksi. Mengunci ke mode jaringan yang ditentukan."

    # Membaca mode jaringan dari file modem.txt
    preferred_network_mode=$(grep -E '^gsm.network.type=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

    # Jika preferred_network_mode kosong, gunakan default (misalnya 11 untuk LTE)
    if [[ -z "$preferred_network_mode" ]]; then
      preferred_network_mode=11  # Ganti dengan mode default yang diinginkan
    fi

    # Mengunci jaringan ke mode yang ditentukan
    su -c "settings put global preferred_network_mode $preferred_network_mode"

    # Mengecek status data seluler, apakah sudah aktif atau belum
    if [ "$(getprop gsm.data.state)" != "LOADED" ]; then
      log "Data seluler tidak aktif. Mengaktifkan data."

      # Perintah untuk mengaktifkan data seluler
      su -c "svc data enable" || log "Error: Gagal mengaktifkan Data Seluler. karena pembatasan fungsi di android, aktifkan secara manual"
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
  # Memeriksa apakah file modem.txt ada
  if [ ! -f /storage/emulated/0/modem.txt ]; then
    log "File modem.txt tidak ditemukan. Pastikan file sudah ada di /storage/emulated/0."
    return 1  # Keluar dari fungsi jika file tidak ditemukan
  fi

  # Membaca alamat ping dari file modem.txt
  ping_address=$(grep -E '^ping.url=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

  # Jika ping_address kosong, gunakan default
  if [[ -z "$ping_address" ]]; then
    ping_address="8.8.8.8"
  fi

  # Membaca waktu tunggu dari file modem.txt
  wait_time=$(grep -E '^ping.wait=' /storage/emulated/0/modem.txt | cut -d'=' -f2 | tr -d ' ' 2>/dev/null)

  # Jika wait_time kosong atau tidak valid, gunakan nilai default 2 detik
  if [[ -z "$wait_time" || ! "$wait_time" =~ ^[0-9]+$ ]]; then
    wait_time=2
  fi

  # Melakukan ping dengan batas waktu yang ditentukan
  start_time=$(date +%s)  # Mencatat waktu mulai
  if ping -c 1 -W "$wait_time" "$ping_address" > /dev/null; then
    end_time=$(date +%s)  # Mencatat waktu akhir
    elapsed_time=$((end_time - start_time))  # Menghitung waktu yang telah berlalu

    if [ "$elapsed_time" -gt "$wait_time" ]; then
      log "Ping gagal: waktu tunggu ($elapsed_time detik) melebihi batas ($wait_time detik) untuk $ping_address."
      return 1  # Kembali jika ping dianggap gagal
    else
      log "Ping berhasil ke $ping_address dalam $elapsed_time detik."
      return 0  # Kembali jika ping berhasil
    fi
  else
    log "Ping gagal ke $ping_address."
    return 1  # Kembali jika ping gagal
  fi
}

reset_network() {
  log "Mereset jaringan secara manual..."
  su -c "svc data disable"
  sleep 1
  su -c "svc data enable"
  log "Reset jaringan selesai."
}

# Fungsi untuk mengaktifkan/nonaktifkan mode pesawat
toggle_airplane_mode() {
  log "========================"
  log "MODPES: Mengaktifkan mode pesawat..."
  su -c "svc data disable"
  sleep 2  # Tunggu untuk memastikan data dinonaktifkan

  for i in {1..3}; do
    su -c "settings put global airplane_mode_on 1"
    su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"
    sleep 2

    airplane_status=$(settings get global airplane_mode_on)
    if [ "$airplane_status" -eq 1 ]; then
      log "MODPES: Mode pesawat berhasil diaktifkan."
      break
    else
      log "MODPES: Gagal mengaktifkan mode pesawat. Mencoba lagi..."
      sleep 2  # Tunggu sebelum mencoba lagi
    fi
  done

  # Menonaktifkan mode pesawat setelah pengaktifan
  log "MODPES: Menonaktifkan mode pesawat..."
  su -c "settings put global airplane_mode_on 0"
  su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"
  su -c "svc data enable"
  sleep 2
  
  airplane_status=$(settings get global airplane_mode_on)
  if [ "$airplane_status" -eq 0 ]; then
    log "MODPES: Mode pesawat berhasil dinonaktifkan."
  else
    log "MODPES: Gagal menonaktifkan mode pesawat."
    return 1  # Keluar dari fungsi jika gagal
  fi

  log "MODPES: Menunggu jaringan terhubung kembali setelah mode pesawat dimatikan..."
  sleep 2
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
	  log "**************"
      log "Ping gagal (percobaan $attempt)."
	  log "**************"
      
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
      #reset_network  # Mereset jaringan
      toggle_airplane_mode  # Mengaktifkan mode pesawat

      # Tunggu beberapa detik untuk memastikan jaringan pulih
      sleep 2 

      # Periksa apakah data seluler sudah aktif setelah mode pesawat dinonaktifkan
      if [ "$(getprop gsm.data.state)" != "CONNECTED" ]; then
        log "Data seluler belum aktif, menunggu untuk jaringan pulih..."
        sleep 1  # Tambahkan waktu tunggu untuk memastikan jaringan pulih
      else
        log "Loop: Data seluler terhubung kembali setelah mode pesawat."
      fi

      # Coba cek ping lagi setelah mode pesawat
      log "Menunggu sesaat sebelum cek ping..."
      sleep 0.5  # Waktu tunggu agar data kembali aktif

      if ping_monitor; then
        log "Ping berhasil setelah mode pesawat dinonaktifkan."
        break  # Keluar dari loop percobaan jika ping berhasil
      fi

      attempt=$((attempt + 1))  # Increment attempt hanya jika ping gagal
      log "Coba lagi... percobaan $attempt"
    done
  fi

  # Jika setelah 50 percobaan mode pesawat masih gagal, tidur 30 menit sebelum melanjutkan
  if [ $attempt -ge 50 ]; then
    log "Gagal setelah 50 percobaan. Menunggu 30 menit sebelum mencoba lagi..."
    sleep 1800  # Tidur selama 30 menit
  fi
done
