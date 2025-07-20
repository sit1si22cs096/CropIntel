@echo off
echo ========================================
echo CropIntel GitHub Setup Script
echo ========================================
echo.

REM Navigate to project directory
cd /d "c:\Users\Manohara M M\Downloads\cropsmart-master\cropsmart-master"

echo [1/6] Initializing Git repository...
git init

echo [2/6] Adding all files to Git...
git add .

echo [3/6] Creating initial commit...
git commit -m "Initial commit: CropIntel with Docker CI/CD pipeline"

echo [4/6] Adding GitHub remote repository...
git remote add origin https://github.com/sit1si22cs096/CropIntel.git

echo [5/6] Creating and switching to main branch...
git branch -M main

echo [6/6] Pushing to GitHub...
git push -u origin main

echo.
echo ========================================
echo SUCCESS! Your CropIntel project has been pushed to GitHub!
echo Repository: https://github.com/sit1si22cs096/CropIntel
echo ========================================
echo.
echo Next steps:
echo 1. Go to your GitHub repository
echo 2. Set up Docker Hub secrets (see instructions below)
echo 3. Watch your CI/CD pipeline run automatically!
echo.
pause
