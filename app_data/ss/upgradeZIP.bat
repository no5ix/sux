@echo off

setlocal
REM upgradeZIP.bat "D:\Program Files (x86)\PixPin" "C:\Users\wk_d_\Downloads\PixPin_1.3.0.0.zip" PixPin .\unzip.exe
REM Check input parameters
if "%~1"=="" (
    echo Error: Please provide the program directory path as the first parameter.
    exit /b
)

if "%~2"=="" (
    echo Error: Please provide the ZIP file path as the second parameter.
    exit /b
)

if "%~3"=="" (
    echo Error: Please provide the software folder name as the third parameter.
    exit /b
)

if "%~4"=="" (
    echo Error: Please provide the unzip.exe file path as the fourth parameter.
    exit /b
)

REM Set variables
set "program_dir=%~1"
set "zip_file=%~2"
set "software_folder=%~3"
set "unzip_exe=%~4"
set "temp_dir=%program_dir%\unzip_temp"

if exist "%temp_dir%" (
    rmdir /s /q "%temp_dir%"
)

REM Create temporary directory
mkdir "%temp_dir%"
echo "%temp_dir%"
REM Copy unzip.exe to the temporary directory
copy "%unzip_exe%" "%temp_dir%"

REM Extract the ZIP file to the temporary directory
cd "%temp_dir%"
unzip.exe -o "%zip_file%"

REM Enter the software folder
cd "%temp_dir%\%software_folder%"

REM Move all files to the program directory
xcopy /y /e /i * "%program_dir%"

REM Return to the original directory
cd /d "%~dp0"

REM Delete the temporary directory
rmdir /s /q "%temp_dir%"

echo Operation completed.

endlocal