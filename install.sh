#!/bin/bash

URL=${1:-"8.8.8.8"}
echo $URL > /sdcard/modem.txt
echo "URL Ping telah diatur ke $URL"

mkdir -p /storage/emulated/0/modem-android
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/META-INF/com/google/android/update-binary -O /storage/emulated/0/modem-android/update-binary
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/META-INF/com/google/android/updater-script -O /storage/emulated/0/modem-android/updater-script
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module_ping.sh -O /storage/emulated/0/modem-android/module_ping.sh
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module-adbau.sh -O /storage/emulated/0/modem-android/module-adbau.sh
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/system/bin/module-batt.sh -O /storage/emulated/0/modem-android/module-batt.sh
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/module.prop -O /storage/emulated/0/modem-android/module.prop
wget https://raw.githubusercontent.com/fahrulariza/modem-android/refs/heads/master/readme.md -O /storage/emulated/0/modem-android/readme.md

cd /storage/emulated/0
zip -r modem-android.zip modem-android/
echo "Magisk Module telah dibuat sebagai modem-android.zip di sdcard"
