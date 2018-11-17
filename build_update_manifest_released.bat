set START_DIR="%CD%"

set SCRIPTPATH=%~dp0

echo Setting up Python virtual environment
if not exist "build\" (
    mkdir build
)
python3 -m venv build/venv || goto error
call .\build\venv\Scripts\activate.bat || goto error

echo Adding pyinstaller
pip3 install pyinstaller || goto error

echo Installing certifi
pip3 install certifi || goto error

echo Installing update_manifest_released requirements
pip3 install -r "%SCRIPTPATH%\requirements.txt" || goto error

echo Compiling update_manifest_released
set PYINSTDIR=build\pyinstaller
if not exist "%PYINSTDIR%\" (
    mkdir %PYINSTDIR%
)
pyinstaller --workpath %PYINSTDIR% ^
    --specpath %PYINSTDIR% ^
    --distpath dist --noconfirm ^
    --onefile ^
    --paths "%SCRIPTPATH%\update_manifest_released\scripts" ^
    "%SCRIPTPATH%\update_manifest_released\scripts\update_manifest_released.py" || goto error

goto eof

:error
set CODE=%ERRORLEVEL%
cd "%START_DIR%"
echo "Failed with error code %CODE%"
exit /b %CODE%

:eof
cd "%START_DIR%"
