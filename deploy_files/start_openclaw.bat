@echo off
chcp 65001 >nul
title OpenClaw 启动工具

echo ===============================================
echo 启动 OpenClaw + Ollama 服务
echo ===============================================
echo.

echo 正在启动 Ollama 服务...
sc start ollama 2>nul
echo.

echo 正在启动 OpenClaw...
cd "%~dp0openclaw"
"%~dp0nodejs\npm" start
echo.
echo 服务启动完成!
pause