@REM @echo off
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "%cd%\app_data\QQScreenShot\Bin\QQScreenShot.exe" -t  REG_SZ /d "~ RUNASADMIN WIN7RTM" /f
