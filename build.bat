@echo off
setlocal
set P=C:\Users\DogDos\MonkeyCode\leopard-slot
set JDK=C:\Program Files\Java\jdk-26.0.1\bin
set BT=%P%\tools\android-15
set PLAT=%P%\tools\android-34\android.jar
set JAVA_HOME=C:\Program Files\Java\jdk-26.0.1
cd /d %P%
if not exist build mkdir build
if not exist build\classes mkdir build\classes
if not exist build\dex mkdir build\dex
if not exist app\res\mipmap mkdir app\res\mipmap

echo [1/8] generate icon
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\make_icon.ps1 || goto :err

echo [2/8] javac
"%JDK%\javac.exe" --release 11 -classpath "%PLAT%" -d build\classes app\src\com\dosdog\leopardslot\MainActivity.java || goto :err

echo [3/8] d8 dex
call "%BT%\d8.bat" --lib "%PLAT%" --release --output build\dex build\classes\com\dosdog\leopardslot\*.class || goto :err

echo [4/8] aapt2 compile
"%BT%\aapt2.exe" compile --dir app\res -o build\res.zip || goto :err

echo [5/8] aapt2 link
"%BT%\aapt2.exe" link -o build\base.apk -I "%PLAT%" --manifest app\AndroidManifest.xml -A app\assets --auto-add-overlay build\res.zip || goto :err

echo [6/8] add classes.dex + zipalign
"%JDK%\jar.exe" -uf build\base.apk -C build\dex classes.dex || goto :err
"%BT%\zipalign.exe" -f 4 build\base.apk build\aligned.apk || goto :err

echo [7/8] keystore
if not exist build\dosdog.keystore "%JDK%\keytool.exe" -genkeypair -keystore build\dosdog.keystore -alias dosdog -keyalg RSA -keysize 2048 -validity 10000 -storepass dosdog123 -keypass dosdog123 -dname "CN=DosDog" || goto :err

echo [8/8] sign + verify
call "%BT%\apksigner.bat" sign --ks build\dosdog.keystore --ks-pass pass:dosdog123 --ks-key-alias dosdog --out LeopardSlot.apk build\aligned.apk || goto :err
call "%BT%\apksigner.bat" verify --print-certs LeopardSlot.apk || goto :err
echo.
echo BUILD_OK
dir LeopardSlot.apk | findstr Leopard
exit /b 0
:err
echo BUILD_FAILED
exit /b 1
