#!/bin/bash

# Directories
BASE_DIR="/data/adb/modules/modem-android"
SYSTEM_BIN="/system/bin"

# Ensure necessary directories exist
mkdir -p "$BASE_DIR"
mkdir -p "$SYSTEM_BIN"

# Copy scripts to /system/bin so they are executable globally
cp "$BASE_DIR/module-ping.sh" "$SYSTEM_BIN/"
cp "$BASE_DIR/module-adbau.sh" "$SYSTEM_BIN/"
cp "$BASE_DIR/module-batt.sh" "$SYSTEM_BIN/"

# Set the necessary permissions to make the scripts executable
chmod 755 "$SYSTEM_BIN/module-ping.sh"
chmod 755 "$SYSTEM_BIN/module-adbau.sh"
chmod 755 "$SYSTEM_BIN/module-batt.sh"

# Optionally run the scripts during installation
echo "Running module-ping.sh..."
sh "$SYSTEM_BIN/module-ping.sh"

echo "Running module-adbau.sh..."
sh "$SYSTEM_BIN/module-adbau.sh"

echo "Running module-batt.sh..."
sh "$SYSTEM_BIN/module-batt.sh"

# End of installation script
echo "Installation complete!"
