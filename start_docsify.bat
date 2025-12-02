@echo off
chcp 65001 >nul 2>&1
REM Windows batch script to start Docsify local server
REM Function: Start Python HTTP server with no-cache, listening on port 3001

REM Change to the directory where this batch file is located
cd /d "%~dp0"

echo Starting Docsify local server...
echo Server address: http://localhost:3001/#/
echo.

REM Start Python server in background
start /b python service.py

REM Wait a moment for the server to start
timeout /t 2 /nobreak >nul

REM Open browser with the server address
start http://localhost:3001/#/

echo Browser opened. Server is running in background.
echo Press any key to stop the server...
pause >nul

REM Stop the server by finding and killing the python process running service.py
for /f "tokens=2" %%a in ('netstat -ano ^| findstr :3001 ^| findstr LISTENING') do (
    taskkill /f /pid %%a >nul 2>&1
)
echo Server stopped.

