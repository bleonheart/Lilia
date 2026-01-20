@echo off
cd /d "%~dp0"
echo Opening MkDocs server...
start "" "http://127.0.0.1:8000"
mkdocs serve
pause
