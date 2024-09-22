#!/bin/bash

PING_URL=${1:-"8.8.8.8"}  # Default ping URL if not provided

detect_os() {
  case "$(uname -s)" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    CYGWIN*|MINGW*|MSYS*) OS=Windows;;
    *)          OS="UNKNOWN"
  esac
  echo "$OS"
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
  fi
}

main
