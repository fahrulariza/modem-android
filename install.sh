#!/bin/bash

# Base URL for raw GitHub content
BASE_URL="https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master"

# Create necessary directories
mkdir -p META-INF/com/google/android
mkdir -p system/bin

# Download files
echo "Downloading necessary files..."

# Download META-INF files
curl -L -o META-INF/com/google/android/update-binary "$BASE_URL/META-INF/com/google/android/update-binary"
curl -L -o META-INF/com/google/android/updater-script "$BASE_URL/META-INF/com/google/android/updater-script"

# Download system/bin files
curl -L -o system/bin/module_ping.sh "$BASE_URL/system/bin/module_ping.sh"
curl -L -o system/bin/module-adbau.sh "$BASE_URL/system/bin/module-adbau.sh"
curl -L -o system/bin/module-batt.sh "$BASE_URL/system/bin/module-batt.sh"

# Download other necessary files
curl -L -o install.bat "$BASE_URL/install.bat"
curl -L -o module.prop "$BASE_URL/module.prop"

# Check if all files were downloaded successfully
if [ -f META-INF/com/google/android/update-binary ] && [ -f META-INF/com/google/android/updater-script ] && \
   [ -f system/bin/module_ping.sh ] && [ -f system/bin/module-adbau.sh ] && [ -f system/bin/module-batt.sh ] && \
   [ -f install.bat ] && [ -f module.prop ]; then
  echo "All files downloaded successfully!"
else
  echo "Error: Some files could not be downloaded. Please check your internet connection or the GitHub repository."
  exit 1
fi

# Zip the folder to create Magisk module
echo "Creating MagiskModemPing.zip..."
zip -r MagiskModemPing.zip META-INF system install.sh install.bat module.prop

# Function to move the zip file to the Downloads folder based on OS
move_to_downloads() {
  OS=$(uname -s)  # Detect the operating system
  case $OS in
    Linux)
      if [ -d "$HOME/Downloads" ]; then
        mv "MagiskModemPing.zip" "$HOME/Downloads/"
        echo "MagiskModemPing.zip moved to $HOME/Downloads"
      else
        echo "Downloads folder not found in Linux."
      fi
      ;;
    Darwin)  # For macOS
      if [ -d "$HOME/Downloads" ]; then
        mv "MagiskModemPing.zip" "$HOME/Downloads/"
        echo "MagiskModemPing.zip moved to $HOME/Downloads"
      else
        echo "Downloads folder not found in macOS."
      fi
      ;;
    CYGWIN*|MINGW*|MSYS*)  # For Windows
      DOWNLOAD_DIR="$(cygpath -w "$USERPROFILE\\Downloads")"
      if [ -d "$DOWNLOAD_DIR" ]; then
        mv "MagiskModemPing.zip" "$DOWNLOAD_DIR/"
        echo "MagiskModemPing.zip moved to $DOWNLOAD_DIR"
      else
        echo "Downloads folder not found in Windows."
      fi
      ;;
    Android)
      if [ -d "/sdcard/Download" ]; then
        mv "MagiskModemPing.zip" "/sdcard/Download/"
        echo "MagiskModemPing.zip moved to /sdcard/Download"
      else
        echo "Downloads folder not found on Android."
      fi
      ;;
    *)
      echo "Unknown OS. Zip file will be in the current directory."
      ;;
  esac
}

# Move the zip file to the appropriate Downloads folder
move_to_downloads

echo "Magisk module compilation completed."
