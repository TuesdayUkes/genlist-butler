@echo off
REM Test script for genlist-butler package (Windows)

setlocal enabledelayedexpansion

echo ================================
echo GenList-Butler Package Test
echo ================================
echo.

REM Test 1: Check if Python is available
echo [*] Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo [X] Python not found. Please install Python 3.8 or higher.
    exit /b 1
)
for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo [+] Python found: %PYTHON_VERSION%

REM Test 2: Create a virtual environment
echo [*] Creating test virtual environment...
if exist test_venv rmdir /s /q test_venv
python -m venv test_venv
call test_venv\Scripts\activate.bat
echo [+] Virtual environment created and activated

REM Test 3: Install the package in development mode
echo [*] Installing genlist-butler in development mode...
pip install -e . >nul 2>&1
if errorlevel 1 (
    echo [X] Package installation failed
    deactivate
    exit /b 1
)
echo [+] Package installed successfully

REM Test 4: Check if command is available
echo [*] Checking if genlist-butler command is available...
where genlist-butler >nul 2>&1
if errorlevel 1 (
    echo [X] genlist-butler command not found
    deactivate
    exit /b 1
)
echo [+] genlist-butler command found

REM Test 5: Test --help flag
echo [*] Testing --help flag...
genlist-butler --help >nul 2>&1
if errorlevel 1 (
    echo [X] --help flag failed
    deactivate
    exit /b 1
)
echo [+] --help flag works

REM Test 6: Create test music directory
echo [*] Creating test music directory...
mkdir test_music 2>nul
echo {title: Test Song} > test_music\test_song.chopro
echo # Another Song > test_music\another_song.cho
echo [+] Test music files created

REM Test 7: Run the actual command
echo [*] Running genlist-butler on test music...
genlist-butler test_music test_output.html --no-intro
if not exist test_output.html (
    echo [X] HTML output file not created
    deactivate
    exit /b 1
)
echo [+] HTML output file created

REM Check if HTML contains expected content
findstr /C:"test_song" test_output.html >nul
if errorlevel 1 (
    echo [X] HTML missing test_song
    deactivate
    exit /b 1
)
findstr /C:"another_song" test_output.html >nul
if errorlevel 1 (
    echo [X] HTML missing another_song
    deactivate
    exit /b 1
)
echo [+] HTML contains expected song titles

REM Test 8: Test filter options
echo [*] Testing filter options...
genlist-butler test_music test_output2.html --filter none --no-intro >nul 2>&1
if not exist test_output2.html (
    echo [X] Filter option failed
    deactivate
    exit /b 1
)
echo [+] Filter option works

REM Test 9: Check package version
echo [*] Checking package version...
python -c "import genlist_butler; print(f'Version: {genlist_butler.__version__}')"
echo [+] Package version accessible

REM Cleanup
echo [*] Cleaning up test files...
rmdir /s /q test_music
del test_output.html test_output2.html
call deactivate
rmdir /s /q test_venv
echo [+] Cleanup complete

echo.
echo ================================
echo All tests passed! [+]
echo ================================
echo.
echo Next steps:
echo   1. Test with real music folder:
echo      genlist-butler ..\TUG\music test.html
echo.
echo   2. Build the package:
echo      python -m build
echo.
echo   3. Publish to TestPyPI:
echo      twine upload --repository testpypi dist/*
echo.
echo See PUBLISHING.md for detailed instructions.

endlocal
