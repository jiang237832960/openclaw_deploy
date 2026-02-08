@echo off
chcp 65001 >nul
title OpenClaw 启动工具

:: 定义颜色
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "CYAN=[96m"
set "RESET=[0m"

:: 定义变量
set "CURRENT_DIR=%~dp0"
set "LOG_FILE=%CURRENT_DIR%start.log"

echo [%date% %time%] OpenClaw 启动开始 > "%LOG_FILE%"

echo %BLUE%===============================================
echo 启动 OpenClaw + Ollama 服务
echo 专为小白用户设计 - 一键启动
echo ================================================
echo.%RESET%

:: 检查网络连接
echo %GREEN%🌐 检查网络连接...%RESET%
ping -n 1 google.com >nul
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: 网络连接失败!%RESET%
    echo %YELLOW%💡 请检查网络连接后重试%RESET%
    echo %YELLOW%📌 继续启动服务...%RESET%
    echo [%date% %time%] 警告: 网络连接失败 >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ 网络连接正常%RESET%
    echo [%date% %time%] 网络连接正常 >> "%LOG_FILE%"
)

echo %GREEN%🚀 正在启动 Ollama 服务...%RESET%
echo [%date% %time%] 开始启动 Ollama 服务 >> "%LOG_FILE%"

:: 尝试通过服务启动 Ollama
sc start ollama >nul
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: 无法通过服务启动 Ollama%RESET%
    echo %YELLOW%💡 正在尝试手动启动...%RESET%
    echo [%date% %time%] 无法通过服务启动 Ollama，尝试手动启动 >> "%LOG_FILE%"
    
    :: 尝试手动启动 Ollama
    echo [%date% %time%] 尝试手动启动 Ollama: %CURRENT_DIR%ollama\ollama.exe serve >> "%LOG_FILE%"
    start "Ollama 服务" /min "%CURRENT_DIR%ollama\ollama.exe" serve
    if %errorLevel% neq 0 (
        echo %RED%❌ 错误: Ollama 服务启动失败!%RESET%
        echo %YELLOW%💡 请检查系统服务设置%RESET%
        echo %YELLOW%⏳ 5秒后继续...%RESET%
        echo [%date% %time%] 错误: Ollama 服务启动失败! >> "%LOG_FILE%"
        timeout /t 5 >nul
    ) else (
        echo %GREEN%✅ Ollama 服务手动启动成功%RESET%
        echo [%date% %time%] Ollama 服务手动启动成功 >> "%LOG_FILE%"
    )
) else (
    echo %GREEN%✅ Ollama 服务启动成功%RESET%
    echo [%date% %time%] Ollama 服务启动成功 >> "%LOG_FILE%"
)

:: 等待 Ollama 服务启动
echo %GREEN%⏳ 等待 Ollama 服务初始化...%RESET%
echo [%date% %time%] 等待 Ollama 服务初始化 >> "%LOG_FILE%"
timeout /t 3 >nul

:: 检查 Ollama 服务状态
echo %GREEN%🔍 检查 Ollama 服务状态...%RESET%
echo [%date% %time%] 检查 Ollama 服务状态 >> "%LOG_FILE%"
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:11434' -UseBasicParsing -ErrorAction Stop; Write-Host '✅ Ollama 服务状态正常' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] Ollama 服务状态正常') } catch { Write-Host '⚠️  Ollama 服务可能尚未完全启动，继续启动...' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: Ollama 服务可能尚未完全启动，继续启动...') }"

echo.
echo %GREEN%🚀 正在启动 OpenClaw...%RESET%
echo [%date% %time%] 开始启动 OpenClaw >> "%LOG_FILE%"

:: 检查 OpenClaw 目录是否存在
if not exist "%CURRENT_DIR%openclaw" (
    echo %RED%❌ 错误: OpenClaw 目录不存在!%RESET%
    echo %YELLOW%💡 请重新运行部署脚本%RESET%
    echo %YELLOW%⏳ 10秒后自动退出...%RESET%
    echo [%date% %time%] 错误: OpenClaw 目录不存在 >> "%LOG_FILE%"
    timeout /t 10 >nul
    exit /b 1
)

:: 检查 nodejs 是否存在
if not exist "%CURRENT_DIR%nodejs\npm" (
    echo %RED%❌ 错误: Node.js 不存在!%RESET%
    echo %YELLOW%💡 请重新运行部署脚本%RESET%
    echo %YELLOW%⏳ 10秒后自动退出...%RESET%
    echo [%date% %time%] 错误: Node.js 不存在 >> "%LOG_FILE%"
    timeout /t 10 >nul
    exit /b 1
)

:: 启动 OpenClaw
cd "%CURRENT_DIR%openclaw"
echo [%date% %time%] 执行命令: "%CURRENT_DIR%nodejs\npm" start >> "%LOG_FILE%"
"%CURRENT_DIR%nodejs\npm" start
if %errorLevel% neq 0 (
    echo %RED%❌ 错误: OpenClaw 启动失败!%RESET%
    echo %YELLOW%💡 请检查日志文件了解详情%RESET%
    echo %YELLOW%📌 日志文件: %LOG_FILE%%RESET%
    echo [%date% %time%] 错误: OpenClaw 启动失败! >> "%LOG_FILE%"
    timeout /t 10 >nul
    exit /b 1
)

echo.
echo %GREEN%✅ 服务启动完成!%RESET%
echo %GREEN%🎉 您可以开始使用 OpenClaw 了!%RESET%
echo.%RESET%
echo %BLUE%📚 使用提示:%RESET%
echo %BLUE%1. 在 OpenClaw 界面中输入您的问题%RESET%
echo %BLUE%2. 输入 "搜索 [关键词]" 进行联网搜索%RESET%
echo %BLUE%3. 输入 "读取 [文件路径]" 进行文件操作%RESET%
echo %BLUE%4. 输入 "帮我写一个 [功能] 的代码" 生成代码%RESET%
echo.%RESET%
echo %YELLOW%💡 提示: 如果服务未正常启动，请查看日志文件了解详情%RESET%
echo %YELLOW%📌 日志文件: %LOG_FILE%%RESET%
echo.%RESET%

echo [%date% %time%] OpenClaw 启动完成 >> "%LOG_FILE%"

pause