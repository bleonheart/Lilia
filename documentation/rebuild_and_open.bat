@echo off
cd /d "%~dp0"
echo Re-compiling documentation...
python ..\generate_docs.py
if errorlevel 1 (
    echo Error: Failed to generate documentation
    pause
    exit /b 1
)
echo Starting MkDocs server...
start "" "http://127.0.0.1:8000"
mkdocs serve
pause
