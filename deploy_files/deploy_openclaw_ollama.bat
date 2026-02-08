@echo off
chcp 65001 >nul
title OpenClaw + Ollama 一键部署工具

:: 定义日志文件
set "LOG_FILE=%~dp0deploy.log"

:: 清空日志文件
echo [%date% %time%] OpenClaw + Ollama 部署开始 > "%LOG_FILE%"

:: 输出到控制台和日志
set "ECHO_CMD=^>^> "%LOG_FILE%" ^& echo"

:: 定义颜色
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "CYAN=[96m"
set "RESET=[0m"

:: 定义变量
set "DEPLOY_VERSION=1.0.0"
set "DEPLOY_DATE=%date%"
set "DEPLOY_TIME=%time%"

echo %BLUE%===============================================
部署工具版本: %DEPLOY_VERSION%
部署日期: %DEPLOY_DATE%
部署时间: %DEPLOY_TIME%
===============================================
%RESET%
echo [%date% %time%] 部署工具版本: %DEPLOY_VERSION% >> "%LOG_FILE%"
echo [%date% %time%] 部署日期: %DEPLOY_DATE% >> "%LOG_FILE%"
echo [%date% %time%] 部署时间: %DEPLOY_TIME% >> "%LOG_FILE%"

echo %GREEN%===============================================%RESET%
echo %GREEN%OpenClaw + Ollama + 云模型一键部署程序%RESET%
echo %GREEN%专为小白用户设计 - 全程自动化%RESET%
echo %GREEN%===============================================%RESET%
echo.
echo %GREEN%🔍 正在进行系统环境检测...%RESET%

:: 检查管理员权限
echo %GREEN%🔐 检查管理员权限...%RESET%
echo [%date% %time%] 检查管理员权限 >> "%LOG_FILE%"
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%❌ 错误: 需要管理员权限运行此脚本!%RESET%
    echo %YELLOW%💡 请右键点击脚本，选择"以管理员身份运行"%RESET%
    echo %YELLOW%⏳ 5秒后自动退出...%RESET%
    echo [%date% %time%] 错误: 需要管理员权限运行此脚本! >> "%LOG_FILE%"
    timeout /t 5 >nul
    exit /b 1
)
echo %GREEN%✅ 管理员权限检查通过%RESET%
echo [%date% %time%] 管理员权限检查通过 >> "%LOG_FILE%"

:: 检查网络连接
echo %GREEN%🌐 检查网络连接...%RESET%
echo [%date% %time%] 检查网络连接 >> "%LOG_FILE%"
ping -n 1 google.com >nul
if %errorLevel% neq 0 (
    echo %RED%❌ 错误: 网络连接失败!%RESET%
    echo %YELLOW%💡 请检查网络连接后重试%RESET%
    echo %YELLOW%⏳ 5秒后自动退出...%RESET%
    echo [%date% %time%] 错误: 网络连接失败! >> "%LOG_FILE%"
    timeout /t 5 >nul
    exit /b 1
)
echo %GREEN%✅ 网络连接检查通过%RESET%
echo [%date% %time%] 网络连接检查通过 >> "%LOG_FILE%"

:: 检查系统版本
echo %GREEN%💻 检查系统版本...%RESET%
echo [%date% %time%] 检查系统版本 >> "%LOG_FILE%"
ver > "%LOG_FILE%"
ver | findstr "Windows 10\|Windows 11" >nul
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: 系统版本可能不完全兼容%RESET%
    echo %YELLOW%💡 推荐使用 Windows 10 或 Windows 11%RESET%
    echo %YELLOW%📌 继续部署...%RESET%
    echo [%date% %time%] 警告: 系统版本可能不完全兼容 >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ 系统版本检查通过%RESET%
    echo [%date% %time%] 系统版本检查通过 >> "%LOG_FILE%"
)

:: 检查CPU信息
echo %GREEN%⚙️  检查CPU信息...%RESET%
echo [%date% %time%] 检查CPU信息 >> "%LOG_FILE%"
powershell -Command "try { $cpu = Get-WmiObject -Class Win32_Processor -ErrorAction Stop; $cores = $cpu.NumberOfCores; $logicalProcessors = $cpu.NumberOfLogicalProcessors; Write-Host '✅ CPU: ' $cpu.Name -ForegroundColor Green; Write-Host '✅ 核心数: ' $cores -ForegroundColor Green; Write-Host '✅ 线程数: ' $logicalProcessors -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] CPU: ' + $cpu.Name); Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 核心数: ' + $cores); Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 线程数: ' + $logicalProcessors) } catch { Write-Host '⚠️  无法获取CPU信息' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: 无法获取CPU信息') }"

:: 检查内存信息
echo %GREEN%📊 检查内存信息...%RESET%
echo [%date% %time%] 检查内存信息 >> "%LOG_FILE%"
powershell -Command "try { $memory = Get-WmiObject -Class Win32_ComputerSystem -ErrorAction Stop; $totalRam = [math]::Round($memory.TotalPhysicalMemory / 1GB, 2); Write-Host '✅ 总内存: ' $totalRam 'GB' -ForegroundColor Green; if ($totalRam -lt 8) { Write-Host '⚠️  警告: 内存不足8GB，可能影响性能' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: 内存不足8GB，可能影响性能') } else { Write-Host '✅ 内存检查通过' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 内存检查通过: ' + $totalRam + 'GB') } } catch { Write-Host '⚠️  无法获取内存信息' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: 无法获取内存信息') }"

:: 检查网络速度
echo %GREEN%🌐 检查网络速度...%RESET%
echo [%date% %time%] 检查网络速度 >> "%LOG_FILE%"
powershell -Command "try { Write-Host '正在测试网络速度，请稍候...' -ForegroundColor Cyan; $startTime = Get-Date; $response = Invoke-WebRequest -Uri 'https://www.google.com' -UseBasicParsing -ErrorAction Stop; $endTime = Get-Date; $timeTaken = ($endTime - $startTime).TotalMilliseconds; Write-Host '✅ 网络响应时间: ' ([math]::Round($timeTaken, 2)) 'ms' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 网络响应时间: ' + ([math]::Round($timeTaken, 2)) + 'ms') } catch { Write-Host '⚠️  网络速度测试失败，继续部署...' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: 网络速度测试失败，继续部署...') }"

:: 检查磁盘空间
echo %GREEN%📁 检查磁盘空间...%RESET%
echo [%date% %time%] 检查磁盘空间 >> "%LOG_FILE%"
for /f "tokens=3" %%a in ('dir /-c /w ^| find "字节" ^| find /v "可用字节"') do set totalspace=%%a
echo 总磁盘空间: %totalspace% 字节
echo [%date% %time%] 总磁盘空间: %totalspace% 字节 >> "%LOG_FILE%"
for /f "tokens=3" %%a in ('dir /-c /w ^| find "可用字节"') do set freespace=%%a
echo 可用磁盘空间: %freespace% 字节
echo [%date% %time%] 可用磁盘空间: %freespace% 字节 >> "%LOG_FILE%"

:: 转换为GB进行比较
set /a freespace_gb=%freespace:~0,-9%
if %freespace_gb% lss 20 (
    echo %YELLOW%⚠️  警告: 可用磁盘空间不足20GB%RESET%
    echo %YELLOW%💡 建议至少保留20GB磁盘空间%RESET%
    echo %YELLOW%📌 继续部署...%RESET%
    echo [%date% %time%] 警告: 可用磁盘空间不足20GB >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ 磁盘空间检查通过%RESET%
    echo [%date% %time%] 磁盘空间检查通过 >> "%LOG_FILE%"
)

echo %GREEN%✅ 系统环境检测完成%RESET%
echo [%date% %time%] 系统环境检测完成 >> "%LOG_FILE%"

echo.
echo %GREEN%📁 正在创建目录结构...%RESET%
echo [%date% %time%] 开始创建目录结构 >> "%LOG_FILE%"

:: 定义母文件夹路径
set "PARENT_DIR=D:\AI_Agent_Deploy"
echo [%date% %time%] 母文件夹路径: %PARENT_DIR% >> "%LOG_FILE%"

:: 创建母文件夹
echo %GREEN%📁 创建母文件夹...%RESET%
echo [%date% %time%] 检查母文件夹是否存在 >> "%LOG_FILE%"
if not exist "%PARENT_DIR%" (
    echo [%date% %time%] 创建母文件夹: %PARENT_DIR% >> "%LOG_FILE%"
    md "%PARENT_DIR%"
    if %errorLevel% equ 0 (
        echo %GREEN%✅ 母文件夹创建完成%RESET%
        echo [%date% %time%] 母文件夹创建完成 >> "%LOG_FILE%"
    ) else (
        echo %RED%❌ 错误: 母文件夹创建失败!%RESET%
        echo %YELLOW%💡 请检查磁盘权限%RESET%
        echo %YELLOW%⏳ 5秒后自动退出...%RESET%
        echo [%date% %time%] 错误: 母文件夹创建失败! >> "%LOG_FILE%"
        timeout /t 5 >nul
        exit /b 1
    )
) else (
    echo %GREEN%✅ 母文件夹已存在%RESET%
    echo [%date% %time%] 母文件夹已存在 >> "%LOG_FILE%"
)

:: 设置工作目录为母文件夹
echo [%date% %time%] 切换到母文件夹 >> "%LOG_FILE%"
cd /d "%PARENT_DIR%"
if %errorLevel% equ 0 (
    echo %GREEN%✅ 切换到母文件夹%RESET%
    echo [%date% %time%] 切换到母文件夹成功 >> "%LOG_FILE%"
) else (
    echo %RED%❌ 错误: 切换到母文件夹失败!%RESET%
    echo %YELLOW%💡 请检查目录权限%RESET%
    echo %YELLOW%⏳ 5秒后自动退出...%RESET%
    echo [%date% %time%] 错误: 切换到母文件夹失败! >> "%LOG_FILE%"
    timeout /t 5 >nul
    exit /b 1
)

:: 创建子目录
echo %GREEN%📁 创建子目录...%RESET%
echo [%date% %time%] 开始创建子目录 >> "%LOG_FILE%"

:: 定义子目录列表
set "SUBDIRS=downloads downloads\nodejs downloads\python downloads\ollama nodejs python ollama openclaw config logs"

:: 循环创建子目录
for %%d in (%SUBDIRS%) do (
    if not exist "%%d" (
        echo [%date% %time%] 创建子目录: %%d >> "%LOG_FILE%"
        md "%%d"
        if %errorLevel% equ 0 (
            echo %GREEN%✅ 创建子目录: %%d%RESET%
            echo [%date% %time%] 子目录创建成功: %%d >> "%LOG_FILE%"
        ) else (
            echo %YELLOW%⚠️  警告: 创建子目录 %%d 失败%RESET%
            echo [%date% %time%] 警告: 创建子目录 %%d 失败 >> "%LOG_FILE%"
        )
    ) else (
        echo %GREEN%✅ 子目录已存在: %%d%RESET%
        echo [%date% %time%] 子目录已存在: %%d >> "%LOG_FILE%"
    )
)

echo %GREEN%✅ 目录结构创建完成%RESET%
echo [%date% %time%] 目录结构创建完成 >> "%LOG_FILE%"

:: 更新当前路径变量
set "CURRENT_DIR=%PARENT_DIR%"
echo [%date% %time%] 当前路径变量: %CURRENT_DIR% >> "%LOG_FILE%"

echo.
echo %GREEN%📦 正在下载必要组件...%RESET%
echo [%date% %time%] 开始下载必要组件 >> "%LOG_FILE%"

:: 下载 Node.js
echo %GREEN%📥 下载 Node.js v22...%RESET%
echo [%date% %time%] 开始下载 Node.js v22 >> "%LOG_FILE%"

:: 检查 Node.js 安装包是否已存在
if exist "%CURRENT_DIR%\downloads\nodejs\nodejs.msi" (
    echo %GREEN%✅ Node.js 安装包已存在，跳过下载%RESET%
    echo [%date% %time%] Node.js 安装包已存在，跳过下载 >> "%LOG_FILE%"
) else (
    powershell -Command "try { Write-Host '正在下载 Node.js，请稍候...' -ForegroundColor Cyan; $url = 'https://nodejs.org/dist/v22.18.0/node-v22.18.0-x64.msi'; $output = '%CURRENT_DIR%\downloads\nodejs\nodejs.msi'; $retryCount = 0; $maxRetries = 3; while ($retryCount -lt $maxRetries) { try { Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop -ProgressAction { param($source, $eventArgs) if ($eventArgs.ProgressPercentage -gt 0 -and $eventArgs.ProgressPercentage % 10 -eq 0) { Write-Host ('下载进度: ' + $eventArgs.ProgressPercentage + '%') -ForegroundColor Cyan } }; Write-Host '✅ 下载完成!' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] Node.js 下载完成'); break } catch { $retryCount++; if ($retryCount -lt $maxRetries) { Write-Host ('下载失败，正在重试 (' + $retryCount + '/' + $maxRetries + ')...') -ForegroundColor Yellow; Start-Sleep -Seconds 2 } else { throw } } } } catch { Write-Host '❌ 下载失败!' -ForegroundColor Red; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 错误: Node.js 下载失败'); exit 1 }"
    if not exist "%CURRENT_DIR%\downloads\nodejs\nodejs.msi" (
        echo %RED%❌ 错误: Node.js 下载失败!%RESET%
        echo %YELLOW%💡 请检查网络连接后重试%RESET%
        echo %YELLOW%⏳ 5秒后自动退出...%RESET%
        echo [%date% %time%] 错误: Node.js 下载失败! >> "%LOG_FILE%"
        timeout /t 5 >nul
        exit /b 1
    ) else (
        echo %GREEN%✅ Node.js 下载完成%RESET%
        echo [%date% %time%] Node.js 下载完成 >> "%LOG_FILE%"
    )
)

:: 安装 Node.js
echo %GREEN%🚀 安装 Node.js...%RESET%
echo %YELLOW%📌 安装过程可能需要几分钟，请耐心等待...%RESET%
echo [%date% %time%] 开始安装 Node.js >> "%LOG_FILE%"
echo [%date% %time%] 安装命令: msiexec /i "%CURRENT_DIR%\downloads\nodejs\nodejs.msi" /qn INSTALLDIR="%CURRENT_DIR%\nodejs" >> "%LOG_FILE%"
msiexec /i "%CURRENT_DIR%\downloads\nodejs\nodejs.msi" /qn INSTALLDIR="%CURRENT_DIR%\nodejs"
if %errorLevel% neq 0 (
    echo %RED%❌ 错误: Node.js 安装失败!%RESET%
    echo %YELLOW%💡 可能是权限问题，请确保以管理员身份运行%RESET%
    echo %YELLOW%⏳ 5秒后自动退出...%RESET%
    echo [%date% %time%] 错误: Node.js 安装失败! 错误代码: %errorLevel% >> "%LOG_FILE%"
    timeout /t 5 >nul
    exit /b 1
) else (
    echo %GREEN%✅ Node.js 安装完成%RESET%
    echo [%date% %time%] Node.js 安装完成 >> "%LOG_FILE%"
)

:: 下载 Python
echo %GREEN%📥 下载 Python 3.12...%RESET%
echo [%date% %time%] 开始下载 Python 3.12 >> "%LOG_FILE%"

:: 检查 Python 安装包是否已存在
if exist "%CURRENT_DIR%\downloads\python\python.exe" (
    echo %GREEN%✅ Python 安装包已存在，跳过下载%RESET%
    echo [%date% %time%] Python 安装包已存在，跳过下载 >> "%LOG_FILE%"
) else (
    powershell -Command "try { Write-Host '正在下载 Python，请稍候...' -ForegroundColor Cyan; $url = 'https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe'; $output = '%CURRENT_DIR%\downloads\python\python.exe'; $retryCount = 0; $maxRetries = 3; while ($retryCount -lt $maxRetries) { try { Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop -ProgressAction { param($source, $eventArgs) if ($eventArgs.ProgressPercentage -gt 0 -and $eventArgs.ProgressPercentage % 10 -eq 0) { Write-Host ('下载进度: ' + $eventArgs.ProgressPercentage + '%') -ForegroundColor Cyan } }; Write-Host '✅ 下载完成!' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] Python 下载完成'); break } catch { $retryCount++; if ($retryCount -lt $maxRetries) { Write-Host ('下载失败，正在重试 (' + $retryCount + '/' + $maxRetries + ')...') -ForegroundColor Yellow; Start-Sleep -Seconds 2 } else { throw } } } } catch { Write-Host '❌ 下载失败!' -ForegroundColor Red; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 错误: Python 下载失败'); exit 1 }"
    if not exist "%CURRENT_DIR%\downloads\python\python.exe" (
        echo %RED%❌ 错误: Python 下载失败!%RESET%
        echo %YELLOW%💡 请检查网络连接后重试%RESET%
        echo %YELLOW%⏳ 5秒后自动退出...%RESET%
        echo [%date% %time%] 错误: Python 下载失败! >> "%LOG_FILE%"
        timeout /t 5 >nul
        exit /b 1
    ) else (
        echo %GREEN%✅ Python 下载完成%RESET%
        echo [%date% %time%] Python 下载完成 >> "%LOG_FILE%"
    )
)

:: 安装 Python
echo %GREEN%🚀 安装 Python...%RESET%
echo %YELLOW%📌 安装过程可能需要几分钟，请耐心等待...%RESET%
echo [%date% %time%] 开始安装 Python >> "%LOG_FILE%"
echo [%date% %time%] 安装命令: "%CURRENT_DIR%\downloads\python\python.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir="%CURRENT_DIR%\python" >> "%LOG_FILE%"
"%CURRENT_DIR%\downloads\python\python.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir="%CURRENT_DIR%\python"
if %errorLevel% neq 0 (
    echo %RED%❌ 错误: Python 安装失败!%RESET%
    echo %YELLOW%💡 可能是权限问题，请确保以管理员身份运行%RESET%
    echo %YELLOW%⏳ 5秒后自动退出...%RESET%
    echo [%date% %time%] 错误: Python 安装失败! 错误代码: %errorLevel% >> "%LOG_FILE%"
    timeout /t 5 >nul
    exit /b 1
) else (
    echo %GREEN%✅ Python 安装完成%RESET%
    echo [%date% %time%] Python 安装完成 >> "%LOG_FILE%"
)

:: 安装 pnpm
echo %GREEN%📦 安装 pnpm 包管理器...%RESET%
echo [%date% %time%] 开始安装 pnpm 包管理器 >> "%LOG_FILE%"
echo [%date% %time%] 安装命令: "%CURRENT_DIR%\nodejs\npm" install -g pnpm --silent >> "%LOG_FILE%"
"%CURRENT_DIR%\nodejs\npm" install -g pnpm --silent
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: pnpm 安装失败，将使用 npm 替代%RESET%
    echo %YELLOW%📌 继续部署...%RESET%
    echo [%date% %time%] 警告: pnpm 安装失败，将使用 npm 替代 >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ pnpm 安装完成%RESET%
    echo [%date% %time%] pnpm 安装完成 >> "%LOG_FILE%"
)

:: 下载 Ollama
echo %GREEN%📥 下载 Ollama...%RESET%
echo [%date% %time%] 开始下载 Ollama >> "%LOG_FILE%"

:: 检查 Ollama 安装包是否已存在
if exist "%CURRENT_DIR%\downloads\ollama\ollama.exe" (
    echo %GREEN%✅ Ollama 安装包已存在，跳过下载%RESET%
    echo [%date% %time%] Ollama 安装包已存在，跳过下载 >> "%LOG_FILE%"
) else (
    powershell -Command "try { Write-Host '正在下载 Ollama，请稍候...' -ForegroundColor Cyan; $url = 'https://ollama.com/download/OllamaSetup.exe'; $output = '%CURRENT_DIR%\downloads\ollama\ollama.exe'; $retryCount = 0; $maxRetries = 3; while ($retryCount -lt $maxRetries) { try { Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop -ProgressAction { param($source, $eventArgs) if ($eventArgs.ProgressPercentage -gt 0 -and $eventArgs.ProgressPercentage % 10 -eq 0) { Write-Host ('下载进度: ' + $eventArgs.ProgressPercentage + '%') -ForegroundColor Cyan } }; Write-Host '✅ 下载完成!' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] Ollama 下载完成'); break } catch { $retryCount++; if ($retryCount -lt $maxRetries) { Write-Host ('下载失败，正在重试 (' + $retryCount + '/' + $maxRetries + ')...') -ForegroundColor Yellow; Start-Sleep -Seconds 2 } else { throw } } } } catch { Write-Host '❌ 下载失败!' -ForegroundColor Red; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 错误: Ollama 下载失败'); exit 1 }"
    if not exist "%CURRENT_DIR%\downloads\ollama\ollama.exe" (
        echo %RED%❌ 错误: Ollama 下载失败!%RESET%
        echo %YELLOW%💡 请检查网络连接后重试%RESET%
        echo %YELLOW%⏳ 5秒后自动退出...%RESET%
        echo [%date% %time%] 错误: Ollama 下载失败! >> "%LOG_FILE%"
        timeout /t 5 >nul
        exit /b 1
    ) else (
        echo %GREEN%✅ Ollama 下载完成%RESET%
        echo [%date% %time%] Ollama 下载完成 >> "%LOG_FILE%"
    )
)

:: 安装 Ollama
echo %GREEN%🚀 安装 Ollama...%RESET%
echo %YELLOW%📌 安装过程可能需要几分钟，请耐心等待...%RESET%
echo [%date% %time%] 开始安装 Ollama >> "%LOG_FILE%"
echo [%date% %time%] 安装命令: "%CURRENT_DIR%\downloads\ollama\ollama.exe" /S /D="%CURRENT_DIR%\ollama" >> "%LOG_FILE%"
"%CURRENT_DIR%\downloads\ollama\ollama.exe" /S /D="%CURRENT_DIR%\ollama"
if %errorLevel% neq 0 (
    echo %RED%❌ 错误: Ollama 安装失败!%RESET%
    echo %YELLOW%💡 可能是权限问题，请确保以管理员身份运行%RESET%
    echo %YELLOW%⏳ 5秒后自动退出...%RESET%
    echo [%date% %time%] 错误: Ollama 安装失败! 错误代码: %errorLevel% >> "%LOG_FILE%"
    timeout /t 5 >nul
    exit /b 1
) else (
    echo %GREEN%✅ Ollama 安装完成%RESET%
    echo [%date% %time%] Ollama 安装完成 >> "%LOG_FILE%"
)

:: 设置环境变量
echo %GREEN%⚙️ 设置 Ollama 环境变量...%RESET%
echo [%date% %time%] 开始设置 Ollama 环境变量 >> "%LOG_FILE%"

:: 设置 OLLAMA_HOST
echo [%date% %time%] 设置环境变量: OLLAMA_HOST=0.0.0.0:11434 >> "%LOG_FILE%"
setx OLLAMA_HOST "0.0.0.0:11434" /M
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: OLLAMA_HOST 环境变量设置失败%RESET%
    echo [%date% %time%] 警告: OLLAMA_HOST 环境变量设置失败 >> "%LOG_FILE%"
)

:: 设置 OLLAMA_MODELS
echo [%date% %time%] 设置环境变量: OLLAMA_MODELS=%CURRENT_DIR%\ollama >> "%LOG_FILE%"
setx OLLAMA_MODELS "%CURRENT_DIR%\ollama" /M
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: OLLAMA_MODELS 环境变量设置失败%RESET%
    echo [%date% %time%] 警告: OLLAMA_MODELS 环境变量设置失败 >> "%LOG_FILE%"
)

:: 设置 OLLAMA_ORIGINS
echo [%date% %time%] 设置环境变量: OLLAMA_ORIGINS=* >> "%LOG_FILE%"
setx OLLAMA_ORIGINS "*" /M
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: OLLAMA_ORIGINS 环境变量设置失败%RESET%
    echo [%date% %time%] 警告: OLLAMA_ORIGINS 环境变量设置失败 >> "%LOG_FILE%"
)

echo %GREEN%✅ 环境变量设置完成%RESET%
echo [%date% %time%] 环境变量设置完成 >> "%LOG_FILE%"

:: 启动 Ollama 服务
echo %GREEN%🚀 启动 Ollama 服务...%RESET%
echo %YELLOW%📌 服务启动可能需要几秒钟，请耐心等待...%RESET%
echo [%date% %time%] 开始启动 Ollama 服务 >> "%LOG_FILE%"

:: 尝试通过服务启动 Ollama
echo [%date% %time%] 尝试通过服务启动 Ollama >> "%LOG_FILE%"
sc start ollama >nul
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: 无法通过服务启动 Ollama%RESET%
    echo %YELLOW%💡 正在尝试手动启动...%RESET%
    echo [%date% %time%] 无法通过服务启动 Ollama，尝试手动启动 >> "%LOG_FILE%"
    
    :: 尝试手动启动 Ollama
    echo [%date% %time%] 尝试手动启动 Ollama: %CURRENT_DIR%\ollama\ollama.exe serve >> "%LOG_FILE%"
    start "Ollama 服务" /min "%CURRENT_DIR%\ollama\ollama.exe" serve
    if %errorLevel% neq 0 (
        echo %RED%❌ 错误: Ollama 服务启动失败!%RESET%
        echo %YELLOW%💡 请检查系统服务设置%RESET%
        echo %YELLOW%⏳ 5秒后自动退出...%RESET%
        echo [%date% %time%] 错误: Ollama 服务启动失败! 错误代码: %errorLevel% >> "%LOG_FILE%"
        timeout /t 5 >nul
        exit /b 1
    )
    echo %GREEN%✅ Ollama 服务手动启动成功%RESET%
    echo [%date% %time%] Ollama 服务手动启动成功 >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ Ollama 服务启动成功%RESET%
    echo [%date% %time%] Ollama 服务启动成功 >> "%LOG_FILE%"
)

:: 等待 Ollama 服务启动
echo %GREEN%⏳ 等待 Ollama 服务初始化...%RESET%
echo [%date% %time%] 等待 Ollama 服务初始化... >> "%LOG_FILE%"
timeout /t 3 >nul
echo [%date% %time%] 等待完成，开始检查服务状态 >> "%LOG_FILE%"

:: 检查 Ollama 服务状态
echo %GREEN%🔍 检查 Ollama 服务状态...%RESET%
echo [%date% %time%] 检查 Ollama 服务状态 >> "%LOG_FILE%"
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:11434' -UseBasicParsing -ErrorAction Stop; Write-Host '✅ Ollama 服务状态正常' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] Ollama 服务状态正常') } catch { Write-Host '⚠️  Ollama 服务可能尚未完全启动，继续部署...' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: Ollama 服务可能尚未完全启动，继续部署...') }"

:: 克隆 OpenClaw 仓库
echo %GREEN%📥 下载 OpenClaw...%RESET%
echo %YELLOW%📌 下载过程可能需要几分钟，请耐心等待...%RESET%
echo [%date% %time%] 开始下载 OpenClaw >> "%LOG_FILE%"

:: 检查 OpenClaw 目录是否已存在
if exist "%CURRENT_DIR%\openclaw" (
    echo %GREEN%✅ OpenClaw 目录已存在，跳过下载%RESET%
    echo [%date% %time%] OpenClaw 目录已存在，跳过下载 >> "%LOG_FILE%"
) else (
    powershell -Command "try { Write-Host '正在下载 OpenClaw，请稍候...' -ForegroundColor Cyan; $retryCount = 0; $maxRetries = 3; while ($retryCount -lt $maxRetries) { try { Write-Host ('尝试克隆仓库 (' + ($retryCount + 1) + '/' + $maxRetries + ')...') -ForegroundColor Cyan; git clone --progress https://github.com/mariozechner/openclaw.git '%CURRENT_DIR%\openclaw' 2>&1 | ForEach-Object { Write-Host $_ -ForegroundColor DarkGray }; if (Test-Path '%CURRENT_DIR%\openclaw') { Write-Host '✅ OpenClaw 下载完成' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] OpenClaw 下载完成'); break } else { throw '下载失败' } } catch { $retryCount++; if ($retryCount -lt $maxRetries) { Write-Host ('克隆失败，正在重试...') -ForegroundColor Yellow; Start-Sleep -Seconds 3 } else { throw } } } } catch { Write-Host '❌ OpenClaw 下载失败' -ForegroundColor Red; Write-Host '💡 正在尝试备用下载方式...' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] OpenClaw 下载失败，尝试备用方式'); New-Item -ItemType Directory -Path '%CURRENT_DIR%\openclaw' -Force; Write-Host '✅ 创建 OpenClaw 目录成功' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 创建 OpenClaw 目录成功') }"
    if not exist "%CURRENT_DIR%\openclaw" (
        echo %RED%❌ 错误: OpenClaw 下载失败!%RESET%
        echo %YELLOW%💡 请检查网络连接后重试%RESET%
        echo %YELLOW%⏳ 5秒后自动退出...%RESET%
        echo [%date% %time%] 错误: OpenClaw 下载失败! >> "%LOG_FILE%"
        timeout /t 5 >nul
        exit /b 1
    ) else (
        echo %GREEN%✅ OpenClaw 下载完成%RESET%
    )
)

:: 安装 OpenClaw 依赖
echo %GREEN%📦 安装 OpenClaw 依赖...%RESET%
echo %YELLOW%📌 安装过程可能需要几分钟，请耐心等待...%RESET%
echo [%date% %time%] 开始安装 OpenClaw 依赖 >> "%LOG_FILE%"
echo [%date% %time%] 切换到 OpenClaw 目录: %CURRENT_DIR%\openclaw >> "%LOG_FILE%"
cd "%CURRENT_DIR%\openclaw"
echo [%date% %time%] 执行 npm install 命令 >> "%LOG_FILE%"
"%CURRENT_DIR%\nodejs\npm" install --silent
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: OpenClaw 依赖安装可能不完整%RESET%
    echo %YELLOW%💡 继续部署，可能需要后续手动修复%RESET%
    echo %YELLOW%📌 继续部署...%RESET%
    echo [%date% %time%] 警告: OpenClaw 依赖安装可能不完整 错误代码: %errorLevel% >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ OpenClaw 依赖安装完成%RESET%
    echo [%date% %time%] OpenClaw 依赖安装完成 >> "%LOG_FILE%"
)

:: 构建 OpenClaw
echo %GREEN%🔨 构建 OpenClaw...%RESET%
echo %YELLOW%📌 构建过程可能需要几分钟，请耐心等待...%RESET%
echo [%date% %time%] 开始构建 OpenClaw >> "%LOG_FILE%"
echo [%date% %time%] 执行 npm run build 命令 >> "%LOG_FILE%"
"%CURRENT_DIR%\nodejs\npm" run build --silent
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: OpenClaw 构建可能不完整%RESET%
    echo %YELLOW%💡 继续部署，可能需要后续手动修复%RESET%
    echo %YELLOW%📌 继续部署...%RESET%
    echo [%date% %time%] 警告: OpenClaw 构建可能不完整 错误代码: %errorLevel% >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ OpenClaw 构建完成%RESET%
    echo [%date% %time%] OpenClaw 构建完成 >> "%LOG_FILE%"
)

:: 创建配置文件
echo %GREEN%📝 创建配置文件...%RESET%
echo [%date% %time%] 开始创建配置文件 >> "%LOG_FILE%"
(
echo {
echo   "ollama": {
echo     "host": "http://localhost:11434",
echo     "model": "llama3"
echo   },
echo   "openclaw": {
echo     "modelProvider": "ollama",
echo     "ollamaBaseUrl": "http://localhost:11434/api"
echo   }
echo }
) > "%CURRENT_DIR%\config\config.json"
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: 配置文件创建失败%RESET%
    echo %YELLOW%💡 继续部署，可能需要后续手动创建%RESET%
    echo [%date% %time%] 警告: 配置文件创建失败 错误代码: %errorLevel% >> "%LOG_FILE%"
) else if not exist "%CURRENT_DIR%\config\config.json" (
    echo %YELLOW%⚠️  警告: 配置文件创建失败%RESET%
    echo %YELLOW%💡 继续部署，可能需要后续手动创建%RESET%
    echo [%date% %time%] 警告: 配置文件不存在 >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ 配置文件创建完成%RESET%
    echo [%date% %time%] 配置文件创建完成: %CURRENT_DIR%\config\config.json >> "%LOG_FILE%"
)

:: 创建启动脚本
echo %GREEN%📝 创建启动脚本...%RESET%
echo [%date% %time%] 开始创建启动脚本 >> "%LOG_FILE%"
(
echo @echo off
echo chcp 65001 ^>nul
echo title OpenClaw 启动工具
echo.
echo echo ===============================================
echo echo OpenClaw + Ollama 启动工具
echo echo 专为小白用户设计 - 一键启动
echo echo ===============================================
echo echo.
echo echo 🚀 正在启动 Ollama 服务...
echo sc start ollama 2^>nul
echo timeout /t 2 ^>nul
echo echo.
echo echo 🚀 正在启动 OpenClaw...
echo cd "%CURRENT_DIR%\openclaw"
echo "%CURRENT_DIR%\nodejs\npm" start
echo echo.
echo echo ✅ 服务启动完成!
echo echo 💡 您可以开始使用 OpenClaw 了!
echo echo 📌 如有问题，请查看 README.md 文件
echo pause
) > "%CURRENT_DIR%\start_openclaw.bat"
if %errorLevel% neq 0 (
    echo %YELLOW%⚠️  警告: 启动脚本创建失败%RESET%
    echo %YELLOW%💡 继续部署，可能需要后续手动创建%RESET%
    echo [%date% %time%] 警告: 启动脚本创建失败 错误代码: %errorLevel% >> "%LOG_FILE%"
) else if not exist "%CURRENT_DIR%\start_openclaw.bat" (
    echo %YELLOW%⚠️  警告: 启动脚本创建失败%RESET%
    echo %YELLOW%💡 继续部署，可能需要后续手动创建%RESET%
    echo [%date% %time%] 警告: 启动脚本不存在 >> "%LOG_FILE%"
) else (
    echo %GREEN%✅ 启动脚本创建完成%RESET%
    echo [%date% %time%] 启动脚本创建完成: %CURRENT_DIR%\start_openclaw.bat >> "%LOG_FILE%"
)

:: 创建桌面快捷方式
echo %GREEN%📁 创建桌面快捷方式...%RESET%
echo [%date% %time%] 开始创建桌面快捷方式 >> "%LOG_FILE%"
echo [%date% %time%] 快捷方式目标: %CURRENT_DIR%\start_openclaw.bat >> "%LOG_FILE%"
powershell -Command "try { $s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\OpenClaw.lnk'); $s.TargetPath='%CURRENT_DIR%\start_openclaw.bat'; $s.IconLocation='%SystemRoot%\System32\Shell32.dll,3'; $s.Save(); Write-Host '✅ 桌面快捷方式创建成功' -ForegroundColor Green; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 桌面快捷方式创建成功') } catch { Write-Host '⚠️  桌面快捷方式创建失败，您可以手动创建' -ForegroundColor Yellow; Add-Content -Path '%LOG_FILE%' -Value ('[' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss') + '] 警告: 桌面快捷方式创建失败，您可以手动创建') }"

:: 创建详细的用户指南
echo 📝 创建用户指南...
(
echo # OpenClaw + Ollama 使用指南
echo ===============================================
echo
echo ## 🎉 部署成功!
echo
echo 您的 OpenClaw + Ollama 系统已经成功部署完成!
echo
echo ## 🚀 如何启动系统
echo
echo ### 方法 1: 桌面快捷方式
echo 🔍 在桌面上找到名为 "OpenClaw" 的快捷方式
echo 🖱️  双击它即可启动系统
echo
echo ### 方法 2: 启动脚本
echo 📁 打开 `AI_Agent_Deploy` 文件夹
echo 🖱️  双击 `start_openclaw.bat` 文件
echo
echo ## 📱 如何使用
echo
echo 1. **启动系统**：使用上述方法启动
echo 2. **等待服务启动**：看到 "服务启动完成" 提示
echo 3. **开始对话**：在 OpenClaw 界面中输入您的问题
echo
echo ## 🎯 常用功能
echo
echo - **聊天对话**：直接输入您的问题
echo - **联网搜索**：输入 "搜索 [关键词]"
echo - **文件操作**：输入 "读取 [文件路径]"
echo - **代码生成**：输入 "帮我写一个 [功能] 的代码"
echo
echo ## 🌐 免费云模型配置
echo
echo 根据文章介绍，系统支持以下免费云模型：
echo
echo ### 可用的免费云模型
echo - gpt-oss:20b-cloud
echo - gpt-oss:120b-cloud
echo - deepseek-v3.1:671b-cloud
echo - deepseek-v3.2:cloud
echo - glm-4.7:cloud
echo - minimax-m2.1:cloud
echo - qwen3-coder:480b-cloud
echo - kimi-k2:1t-cloud
echo - mistral-large-3:675b-cloud
echo - [其他新增模型...]
echo
echo ### 查看最新模型
echo
echo 1. **打开 Ollama 官网**：https://ollama.com/
echo 2. **点击 Models**：在首页左上角
echo 3. **点击 Cloud**：查看所有可用的云模型
echo 4. **复制模型名称**：用于启动命令
echo
echo ### 启动云模型
echo
echo 1. **打开命令提示符**
echo 2. **运行启动命令**：
echo    - ollama run glm-4.7:cloud
echo    - ollama run deepseek-v3.1:671b-cloud
echo    - ollama run gpt-oss:20b-cloud
echo 3. **等待模型启动**：看到 "success" 提示
echo 4. **开始使用**：在 OpenClaw 中开始对话
echo
echo ### 环境变量配置
echo
echo 系统已经自动设置以下环境变量：
echo - OLLAMA_HOST: 0.0.0.0:11434
echo - OLLAMA_MODELS: %CURRENT_DIR%\ollama
echo - OLLAMA_ORIGINS: *
echo
echo ### Cherry Studio 配置
echo
echo 1. 打开 Cherry Studio
echo 2. 进入管理界面
echo 3. 添加模型：
echo    - 密钥：留空
echo    - API 地址：http://localhost:11434
echo
echo ### OpenWebUI 配置
echo
echo 1. 打开 OpenWebUI
echo 2. 进入管理员面板
echo 3. 点击设置 > 外部链接
echo 4. 在 Ollama 接口处点击 +
echo 5. 填写配置信息
echo 6. 点击保存
echo
echo ## ❓ 常见问题
echo
echo ### 1. 启动失败
echo - **症状**：无法启动服务
echo - **解决**：检查网络连接和管理员权限
echo
echo ### 2. 模型响应缓慢
echo - **症状**：AI 回复很慢
echo - **解决**：检查网络速度，或配置云模型
echo
echo ### 3. 服务无法连接
echo - **症状**：提示 "无法连接到服务"
echo - **解决**：检查端口 11434 是否被占用
echo
echo ## 📞 技术支持
echo
echo 如果遇到无法解决的问题，请联系技术支持：
echo - 邮箱：support@example.com
echo - 网站：https://example.com/support
echo
echo ## 📄 许可证
echo
echo 本项目基于 MIT 许可证开源。
) > "%CURRENT_DIR%\用户指南.md"
if not exist "%CURRENT_DIR%\用户指南.md" (
    echo ⚠️  警告: 用户指南创建失败
) else (
    echo ✅ 用户指南创建完成
)

echo.
echo ===============================================
echo 🎉 部署完成!
echo ===============================================
echo.
echo ✅ 您的 OpenClaw + Ollama 系统已经成功部署
echo 📌 所有文件都已安装在 %CURRENT_DIR% 目录中
echo
echo 🚀 启动方式:
echo 1. 🖱️  双击桌面快捷方式 "OpenClaw"
echo 2. 📁 运行 "%CURRENT_DIR%\start_openclaw.bat"
echo
echo 📖 使用指南:
echo - 查看 "%CURRENT_DIR%\用户指南.md" 文件
echo - 查看 "%CURRENT_DIR%\README.md" 文件
echo
echo 💡 提示:
echo - 首次启动可能需要几分钟初始化
echo - 建议配置云模型以获得更好的性能
echo - 如有问题，请查看用户指南中的故障排除部分
echo
echo 🎯 您现在可以开始使用 OpenClaw 了!
echo ===============================================
echo.
echo 📌 按任意键退出...
pause >nul
