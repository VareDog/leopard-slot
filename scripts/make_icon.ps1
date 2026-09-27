$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$out = 'C:\Users\DogDos\MonkeyCode\leopard-slot\app\res\mipmap\ic_launcher.png'
$bmp = New-Object System.Drawing.Bitmap 192,192
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'
$g.Clear([System.Drawing.Color]::FromArgb(255,13,27,61))
# 金色外环
$gold = New-Object System.Drawing.Pen ([System.Drawing.Color]::Gold), 9
$g.DrawEllipse($gold, 12, 12, 168, 168)
# 红色圆底
$red = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Firebrick)
$g.FillEllipse($red, 30, 30, 132, 132)
# 777
$font = New-Object System.Drawing.Font ('Arial', 46, [System.Drawing.FontStyle]::Bold)
$fmt = New-Object System.Drawing.StringFormat
$fmt.Alignment = 'Center'; $fmt.LineAlignment = 'Center'
$g.DrawString('777', $font, [System.Drawing.Brushes]::Gold, (New-Object System.Drawing.RectangleF(30,30,132,132)), $fmt)
# 左上小星 (U+2605)
$starFont = New-Object System.Drawing.Font ('Segoe UI Symbol', 22)
$star = [string][char]0x2605
$g.DrawString($star, $starFont, [System.Drawing.Brushes]::Yellow, 118, 8)
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "icon saved: $out"
