@echo off
REM WebP Conversion Script for Windows
REM Converts all JPG images to WebP format with 85% quality

echo ==========================================
echo WebP Conversion Script for Windows
echo ==========================================
echo.

REM Check if cwebp exists
where cwebp >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: cwebp is not installed or not in PATH!
    echo.
    echo Please download WebP tools from:
    echo https://developers.google.com/speed/webp/download
    echo.
    echo Then add the bin folder to your PATH environment variable.
    echo.
    pause
    exit /b 1
)

REM Set portfolio directory
set PORTFOLIO_DIR=assets\img\portfolio

REM Check if directory exists
if not exist "%PORTFOLIO_DIR%" (
    echo ERROR: Portfolio directory not found at %PORTFOLIO_DIR%
    pause
    exit /b 1
)

echo Converting images in: %PORTFOLIO_DIR%
echo.

REM Counter for converted images
set /a count=0

REM Convert all jpg and JPG files
for %%f in ("%PORTFOLIO_DIR%\*.jpg" "%PORTFOLIO_DIR%\*.JPG" "%PORTFOLIO_DIR%\*.jpeg" "%PORTFOLIO_DIR%\*.JPEG") do (
    if exist "%%f" (
        set "filename=%%~nf"
        set "output=%PORTFOLIO_DIR%\%%~nf.webp"

        echo Converting: %%~nxf -^> %%~nf.webp

        REM Convert with quality 85
        cwebp -q 85 "%%f" -o "%PORTFOLIO_DIR%\%%~nf.webp" >nul 2>&1

        if !ERRORLEVEL! equ 0 (
            echo   Success! File converted.
            set /a count+=1
        ) else (
            echo   Failed to convert %%~nxf
        )
        echo.
    )
)

echo ==========================================
echo Conversion Complete!
echo Converted %count% images to WebP format
echo ==========================================
echo.
echo Your WebP images are ready in: %PORTFOLIO_DIR%
echo.
echo Next steps:
echo 1. Test one image in your browser to verify quality
echo 2. Update your HTML to use WebP with JPG fallbacks
echo.
pause
