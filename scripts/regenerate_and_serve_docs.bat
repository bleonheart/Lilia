@echo off
setlocal EnableExtensions

rem Regenerate and serve the local documentation site using the same
rem documentation steps used by Lilia's website deployment workflow.

set "LILIA_ROOT=%~dp0.."
pushd "%LILIA_ROOT%" >nul
if errorlevel 1 goto :error

where python >nul 2>&1
if errorlevel 1 (
    echo Python was not found on PATH.
    goto :error
)

where npm >nul 2>&1
if errorlevel 1 (
    echo npm was not found on PATH.
    goto :error
)

where mkdocs >nul 2>&1
if errorlevel 1 (
    echo MkDocs was not found on PATH. Install it with:
    echo   python -m pip install mkdocs mkdocs-material mkdocs-awesome-pages-plugin
    goto :error
)

echo Cleaning generated documentation directories...
for %%D in (
    "documentation\docs\development\meta"
    "documentation\docs\development\libraries"
    "documentation\docs\development\hooks"
    "documentation\docs\modules"
    "documentation\docs\compatibility"
) do if exist "%%~D" rmdir /s /q "%%~D"

echo Regenerating documentation...
python generate_docs.py meta --force
if errorlevel 1 goto :error
python generate_docs.py library --force
if errorlevel 1 goto :error
python generate_docs.py hooks --force
if errorlevel 1 goto :error
python generate_docs.py compatibility --force
if errorlevel 1 goto :error
python generate_docs.py about --force
if errorlevel 1 goto :error

echo Removing source comments...
python scripts\remove_comments.py gamemode
if errorlevel 1 goto :error

echo Fetching Modules documentation...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; $archive = Join-Path (Get-Location) 'modules_docs.zip'; $extract = Join-Path (Get-Location) 'Modules-module-markdown'; Invoke-WebRequest -Uri 'https://github.com/LiliaFramework/Modules/archive/refs/heads/module-markdown.zip' -OutFile $archive; if (Test-Path $extract) { Remove-Item -LiteralPath $extract -Recurse -Force }; Expand-Archive -LiteralPath $archive -DestinationPath (Get-Location) -Force; New-Item -ItemType Directory -Force -Path 'documentation\docs\modules' | Out-Null; Copy-Item -Path (Join-Path $extract 'documentation\modules\*') -Destination 'documentation\docs\modules' -Recurse -Force; $sourceVersioning = Join-Path $extract 'documentation\docs\versioning'; if (Test-Path $sourceVersioning) { New-Item -ItemType Directory -Force -Path 'documentation\docs\versioning' | Out-Null; Copy-Item -Path (Join-Path $sourceVersioning '*') -Destination 'documentation\docs\versioning' -Recurse -Force }; Remove-Item -LiteralPath $archive -Force; Remove-Item -LiteralPath $extract -Recurse -Force"
if errorlevel 1 goto :error

echo Building the Derma Generator...
call npm.cmd ci --no-audit --no-fund --prefix documentation\docs\derma_generator\source
if errorlevel 1 goto :error
call npm.cmd --prefix documentation\docs\derma_generator\source run build:docs
if errorlevel 1 goto :error
if exist "documentation\docs\derma_generator\source\node_modules" rmdir /s /q "documentation\docs\derma_generator\source\node_modules"

echo Building the MkDocs site...
if exist site rmdir /s /q site
mkdocs build --config-file documentation\mkdocs.yml --site-dir "%LILIA_ROOT%\site"
if errorlevel 1 goto :error
if not exist "%LILIA_ROOT%\site\index.html" (
    echo MkDocs did not create the expected site at "%LILIA_ROOT%\site".
    goto :error
)

echo.
echo Documentation is available at http://127.0.0.1:8000
echo Press Ctrl+C to stop the server.
python scripts\serve_site.py --directory site --host 127.0.0.1 --port 8000
set "EXIT_CODE=%ERRORLEVEL%"
echo.
echo Documentation server stopped.
pause
popd >nul
exit /b %EXIT_CODE%

:error
set "EXIT_CODE=%ERRORLEVEL%"
if "%EXIT_CODE%"=="0" set "EXIT_CODE=1"
echo.
echo Documentation build failed.
pause
popd >nul
exit /b %EXIT_CODE%
