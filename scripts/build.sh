#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SDK="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
if [ -z "$SDK" ]; then
  echo "ANDROID_SDK_ROOT / ANDROID_HOME not set"
  exit 1
fi

BT=""
for d in "$SDK"/build-tools/*; do
  if [ -x "$d/aapt2" ] && [ -x "$d/zipalign" ]; then
    BT="$d"
  fi
done
if [ -z "$BT" ]; then
  echo "Android build-tools not found under $SDK"
  exit 1
fi

PLAT=""
for f in "$SDK"/platforms/android-34/android.jar "$SDK"/platforms/android-*/android.jar; do
  if [ -f "$f" ]; then PLAT="$f"; break; fi
done
if [ -z "$PLAT" ]; then
  echo "android.jar not found"
  exit 1
fi

mkdir -p build/classes build/dex

echo "[1/6] javac"
javac --release 11 -classpath "$PLAT" -d build/classes \
  app/src/com/dosdog/leopardslot/MainActivity.java

echo "[2/6] d8"
if [ -x "$BT/d8" ]; then
  "$BT/d8" --lib "$PLAT" --release --output build/dex \
    build/classes/com/dosdog/leopardslot/*.class
else
  "$BT/d8.bat" --lib "$PLAT" --release --output build/dex \
    build/classes/com/dosdog/leopardslot/*.class
fi

echo "[3/6] aapt2 compile + link"
"$BT/aapt2" compile --dir app/res -o build/res.zip
"$BT/aapt2" link -o build/base.apk -I "$PLAT" \
  --manifest app/AndroidManifest.xml -A app/assets \
  --auto-add-overlay build/res.zip

echo "[4/6] add classes.dex + zipalign"
(
  cd build/dex
  zip -u ../base.apk classes.dex >/dev/null
)
"$BT/zipalign" -f 4 build/base.apk build/aligned.apk

echo "[5/6] keystore"
KS=build/release.keystore
if [ ! -f "$KS" ]; then
  keytool -genkeypair -keystore "$KS" -alias dosdog -keyalg RSA -keysize 2048 \
    -validity 10000 -storepass dosdog123 -keypass dosdog123 \
    -dname "CN=DosDog" -batch
fi

echo "[6/6] sign"
"$BT/apksigner" sign --ks "$KS" --ks-pass pass:dosdog123 --ks-key-alias dosdog \
  --out LeopardSlot.apk build/aligned.apk
"$BT/apksigner" verify --print-certs LeopardSlot.apk
ls -lh LeopardSlot.apk
echo BUILD_OK
