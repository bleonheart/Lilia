@echo off
cd /d "%~dp0"
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
