#!/bin/bash

PING_URL=${1:-"8.8.8.8"}  # Default ping URL if not provided

detect_os() {
  case "$(uname -s)" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    CYGWIN*|MINGW*|MSYS*) OS=Windows;;
    Android*)   OS=Android;;
    *)          OS="UNKNOWN"
  esac
  echo "$OS"
}

move_to_downloads() {
  DOWNLOAD_DIR=""
  
  if [ "$OS" == "Linux" ]; then
    DOWNLOAD_DIR="$HOME/Downloads"
  elif [ "$OS" == "Mac" ]; then
    DOWNLOAD_DIR="$HOME/Downloads"
  elif [ "$OS" == "Windows" ]; then
    DOWNLOAD_DIR="$USERPROFILE\\Downloads"
  elif [ "$OS" == "Android" ]; then
    DOWNLOAD_DIR="/sdcard/Download"
  fi

  if [ -d "$DOWNLOAD_DIR" ]; then
    mv "MagiskModemPing.zip" "$DOWNLOAD_DIR/"
    echo "MagiskModemPing.zip moved to $DOWNLOAD_DIR"
  else
    echo "Download folder not found. MagiskModemPing.zip not moved."
  fi
}

compile_module() {
  ZIP_NAME="MagiskModemPing.zip"
  zip -r "$ZIP_NAME" META-INF system install.sh install.bat module.prop
  echo "Module compiled to $ZIP_NAME"
}

main() {
  OS=$(detect_os)

  if [ "$OS" == "Windows" ]; then
    echo "Detected Windows OS, running install.bat"
    ./install.bat "$PING_URL"
  else
    echo "Detected $OS OS, compiling Magisk module"
    compile_module
    move_to_downloads
  fi
}

main
