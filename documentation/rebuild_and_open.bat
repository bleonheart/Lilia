@echo off
cd /d "%~dp0"
echo Cleaning existing documentation...
if exist "docs\meta" rd /s /q "docs\meta"
if exist "docs\libraries" rd /s /q "docs\libraries"
if exist "docs\hooks" rd /s /q "docs\hooks"
if exist "docs\modules" rd /s /q "docs\modules"
if exist "docs\compatibility" rd /s /q "docs\compatibility"

echo === Fetching Modules Documentation ===
echo Fetching modules documentation from LiliaFramework/Modules...
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/LiliaFramework/Modules/archive/refs/heads/module-markdown.zip' -OutFile 'modules_docs.zip'"

echo Extracting modules documentation...
powershell -Command "Expand-Archive -Path 'modules_docs.zip' -DestinationPath '.' -Force"

echo Copying modules documentation...
if not exist "docs\modules" mkdir "docs\modules"
xcopy /e /i /y "Modules-module-markdown\documentation\modules\*" "docs\modules\"

echo Copying versioning files...
if not exist "docs\versioning" mkdir "docs\versioning"
if exist "Modules-module-markdown\documentation\docs\versioning" (
    xcopy /e /i /y "Modules-module-markdown\documentation\docs\versioning\*" "docs\versioning\"
)

echo Cleaning up temporary files...
if exist "Modules-module-markdown" rd /s /q "Modules-module-markdown"
if exist "modules_docs.zip" del /f /q "modules_docs.zip"

echo Re-compiling documentation...
python ..\generate_docs.py meta
if errorlevel 1 (
    echo Error: Failed to generate meta documentation
    pause
    exit /b 1
)
python ..\generate_docs.py library
if errorlevel 1 (
    echo Error: Failed to generate library documentation
    pause
    exit /b 1
)
python ..\generate_docs.py compatibility
if errorlevel 1 (
    echo Error: Failed to generate compatibility documentation
    pause
    exit /b 1
)

python ..\generate_docs.py hooks
if errorlevel 1 (
    echo Error: Failed to generate hooks documentation
    pause
    exit /b 1
)

python ..\generate_docs.py about
if errorlevel 1 (
    echo Error: Failed to generate about documentation
    pause
    exit /b 1
)

echo Starting MkDocs server...
start "" "http://127.0.0.1:8000"
mkdocs serve
pause
