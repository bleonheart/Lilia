@echo off
cd /d "%~dp0"
echo Cleaning existing documentation...
if exist "..\documentation\docs\meta" rd /s /q "..\documentation\docs\meta"
if exist "..\documentation\docs\libraries" rd /s /q "..\documentation\docs\libraries"
if exist "..\documentation\docs\definitions" rd /s /q "..\documentation\docs\definitions"
if exist "..\documentation\docs\hooks" rd /s /q "..\documentation\docs\hooks"
if exist "..\documentation\docs\modules" rd /s /q "..\documentation\docs\modules"
if exist "..\documentation\docs\compatibility" rd /s /q "..\documentation\docs\compatibility"
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
python ..\generate_docs.py definitions
if errorlevel 1 (
    echo Error: Failed to generate definitions documentation
    pause
    exit /b 1
)
python ..\generate_docs.py hooks
if errorlevel 1 (
    echo Error: Failed to generate hooks documentation
    pause
    exit /b 1
)
echo Starting MkDocs server...
start "" "http://127.0.0.1:8000"
mkdocs serve
pause
