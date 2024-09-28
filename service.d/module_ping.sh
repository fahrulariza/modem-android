#!/system/bin/sh

# Log function with size check
log() {
  if [ -w /sdcard ]; then
    log_file="/sdcard/Module-log.txt"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> $log_file
    log_size=$(stat -c%s "$log_file")
    if [ $log_size -gt 256000 ]; then
      echo "" > $log_file
      log "Log file size exceeded 250KB. Log file recreated."
    fi
  else
    echo "Error: Cannot write to /sdcard. Check permissions."
  fi
}

# Function to check SIM card with shorter wait
check_sim() {
  for i in {1..10}; do
    if [ -n "$(getprop gsm.sim.state)" ]; then
      log "SIM card detected."
      return 0
    fi
    log "No SIM card detected. Waiting..."
    sleep 2  # Reduced wait time between checks
  done
  log "SIM card not detected after multiple attempts."
  return 1
}

# Function to check signal and enable mobile data, with faster retries
check_signal_and_data() {
  for i in {1..10}; do
    if [ -n "$(getprop gsm.network.type)" ]; then
      log "Signal detected. Locking to LTE."
      # Lock to LTE
      su -c "settings put global preferred_network_mode 11"

      # Check and enable mobile data
      if [ "$(getprop gsm.data.state)" != "CONNECTED" ]; then
        log "Mobile data is not active. Enabling data."
        su -c "svc data enable" || log "Error: Failed to enable mobile data."
      else
        log "Mobile data is already active."
      fi
      return 0
    fi
    log "Waiting for network signal..."
    sleep 2  # Reduced wait time between checks
  done
  log "Signal not detected after multiple attempts."
  return 1
}

# Function to monitor ping (2 attempts, 1 ping each with 2 seconds timeout)
ping_monitor() {
  ping_address=$(cat /sdcard/modem.txt 2>/dev/null || echo "8.8.8.8")
  for i in {1..2}; do
    if ping -c 1 -W 2 $ping_address > /dev/null; then
      log "Ping successful to $ping_address"
      return 0
    else
      log "Ping failed to $ping_address (attempt $i)"
    fi
  done
  return 1
}

# Function to toggle airplane mode
toggle_airplane_mode() {
  log "Activating airplane mode..."
  su -c "settings put global airplane_mode_on 1"
  su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"
  sleep 1  # Wait for 1 second
  log "Deactivating airplane mode..."
  su -c "settings put global airplane_mode_on 0"
  su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"

  log "Waiting for network to reconnect after airplane mode is off..."
  sleep 2  # Add delay for network to fully reconnect and data to be available
}

# Main loop
while true; do
  # Step 1: Check SIM card
  if ! check_sim; then
    continue  # Retry if SIM not detected
  fi

  # Step 2: Check signal and enable mobile data
  if ! check_signal_and_data; then
    continue  # Retry if signal not detected
  fi

  # Step 3: Ping monitor
  if ping_monitor; then
    continue  # Restart loop if ping is successful
  else
    log "Ping failed after 2 attempts. Proceeding to Step 4."
  fi

  # Step 4: Toggle airplane mode and check connectivity
  attempt=0
  while [ $attempt -lt 5 ];do
    toggle_airplane_mode

    # Wait for a moment before checking again
    log "Waiting 4 seconds before checking ping..."
    sleep 2  # Wait for 4 seconds to allow data to activate

    # Check ping again after toggling airplane mode
    if ping_monitor; then
      break  # Exit attempt loop if ping is successful
    fi

    attempt=$((attempt + 1))
    log "Attempt $attempt failed. Trying again."
  done

  if [ $attempt -ge 30 ]; then
    log "Ping failed after 30 attempts. Waiting 40 minutes before retrying..."

    # Wait for 30 minutes (1800 seconds)
    sleep 1800
  fi
done
