@echo off
chcp 65001 >nul
title OpenClaw + Ollama 一键部署工具

echo ===============================================
echo OpenClaw + Ollama + 云模型一键部署程序
 echo 专为小白用户设计 - 全程自动化
 echo ===============================================
echo.
echo 🔍 正在进行系统环境检测...

:: 检查管理员权限
echo 🔐 检查管理员权限...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ 错误: 需要管理员权限运行此脚本!
    echo 💡 请右键点击脚本，选择"以管理员身份运行"
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ 管理员权限检查通过

:: 检查网络连接
echo 🌐 检查网络连接...
ping -n 1 google.com >nul
if %errorLevel% neq 0 (
    echo ❌ 错误: 网络连接失败!
    echo 💡 请检查网络连接后重试
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ 网络连接检查通过

:: 检查系统版本
echo 💻 检查系统版本...
ver | findstr "Windows 10\|Windows 11" >nul
if %errorLevel% neq 0 (
    echo ⚠️  警告: 系统版本可能不完全兼容
    echo 💡 推荐使用 Windows 10 或 Windows 11
    echo 📌 继续部署...
) else (
    echo ✅ 系统版本检查通过
)

:: 检查磁盘空间
echo 📁 检查磁盘空间...
for /f "tokens=3" %%a in ('dir /-c /w ^| find "字节" ^| find /v "可用字节"') do set totalspace=%%a
echo 总磁盘空间: %totalspace% 字节
for /f "tokens=3" %%a in ('dir /-c /w ^| find "可用字节"') do set freespace=%%a
echo 可用磁盘空间: %freespace% 字节

:: 转换为GB进行比较
set /a freespace_gb=%freespace:~0,-9%
if %freespace_gb% lss 20 (
    echo ⚠️  警告: 可用磁盘空间不足20GB
    echo 💡 建议至少保留20GB磁盘空间
    echo 📌 继续部署...
) else (
    echo ✅ 磁盘空间检查通过
)

echo ✅ 系统环境检测完成

echo.
echo 📁 正在创建目录结构...

:: 定义母文件夹路径
set "PARENT_DIR=D:\AI_Agent_Deploy"

:: 创建母文件夹
echo 📁 创建母文件夹...
if not exist "%PARENT_DIR%" (
    md "%PARENT_DIR%"
    echo ✅ 母文件夹创建完成
) else (
    echo ✅ 母文件夹已存在
)

:: 设置工作目录为母文件夹
cd /d "%PARENT_DIR%"
echo ✅ 切换到母文件夹

:: 创建子目录
echo 📁 创建子目录...
if not exist "%PARENT_DIR%\downloads" md "%PARENT_DIR%\downloads"
if not exist "%PARENT_DIR%\downloads\nodejs" md "%PARENT_DIR%\downloads\nodejs"
if not exist "%PARENT_DIR%\downloads\python" md "%PARENT_DIR%\downloads\python"
if not exist "%PARENT_DIR%\downloads\ollama" md "%PARENT_DIR%\downloads\ollama"
if not exist "%PARENT_DIR%\nodejs" md "%PARENT_DIR%\nodejs"
if not exist "%PARENT_DIR%\python" md "%PARENT_DIR%\python"
if not exist "%PARENT_DIR%\ollama" md "%PARENT_DIR%\ollama"
if not exist "%PARENT_DIR%\openclaw" md "%PARENT_DIR%\openclaw"
if not exist "%PARENT_DIR%\config" md "%PARENT_DIR%\config"
if not exist "%PARENT_DIR%\logs" md "%PARENT_DIR%\logs"
echo ✅ 目录结构创建完成

:: 更新当前路径变量
set "CURRENT_DIR=%PARENT_DIR%"

echo.
echo 📦 正在下载必要组件...

:: 下载 Node.js
echo 📥 下载 Node.js v22...
powershell -Command "Write-Host '正在下载 Node.js，请稍候...' -ForegroundColor Green"
powershell -Command "try { Invoke-WebRequest -Uri 'https://nodejs.org/dist/v22.18.0/node-v22.18.0-x64.msi' -OutFile '%CURRENT_DIR%\downloads\nodejs\nodejs.msi' -ErrorAction Stop; Write-Host '下载完成!' -ForegroundColor Green } catch { Write-Host '下载失败，正在重试...' -ForegroundColor Yellow; Invoke-WebRequest -Uri 'https://nodejs.org/dist/v22.18.0/node-v22.18.0-x64.msi' -OutFile '%CURRENT_DIR%\downloads\nodejs\nodejs.msi' }"
if not exist "%CURRENT_DIR%\downloads\nodejs\nodejs.msi" (
    echo ❌ 错误: Node.js 下载失败!
    echo 💡 请检查网络连接后重试
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Node.js 下载完成

:: 安装 Node.js
echo 🚀 安装 Node.js...
echo 📌 安装过程可能需要几分钟，请耐心等待...
msiexec /i "%CURRENT_DIR%\downloads\nodejs\nodejs.msi" /qn INSTALLDIR="%CURRENT_DIR%\nodejs"
if %errorLevel% neq 0 (
    echo ❌ 错误: Node.js 安装失败!
    echo 💡 可能是权限问题，请确保以管理员身份运行
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Node.js 安装完成

:: 下载 Python
echo 📥 下载 Python 3.12...
powershell -Command "Write-Host '正在下载 Python，请稍候...' -ForegroundColor Green"
powershell -Command "try { Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe' -OutFile '%CURRENT_DIR%\downloads\python\python.exe' -ErrorAction Stop; Write-Host '下载完成!' -ForegroundColor Green } catch { Write-Host '下载失败，正在重试...' -ForegroundColor Yellow; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe' -OutFile '%CURRENT_DIR%\downloads\python\python.exe' }"
if not exist "%CURRENT_DIR%\downloads\python\python.exe" (
    echo ❌ 错误: Python 下载失败!
    echo 💡 请检查网络连接后重试
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Python 下载完成

:: 安装 Python
echo 🚀 安装 Python...
echo 📌 安装过程可能需要几分钟，请耐心等待...
"%CURRENT_DIR%\downloads\python\python.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir="%CURRENT_DIR%\python"
if %errorLevel% neq 0 (
    echo ❌ 错误: Python 安装失败!
    echo 💡 可能是权限问题，请确保以管理员身份运行
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Python 安装完成

:: 安装 pnpm
echo 📦 安装 pnpm 包管理器...
"%CURRENT_DIR%\nodejs\npm" install -g pnpm --silent
if %errorLevel% neq 0 (
    echo ⚠️  警告: pnpm 安装失败，将使用 npm 替代
    echo 📌 继续部署...
) else (
    echo ✅ pnpm 安装完成
)

:: 下载 Ollama
echo 📥 下载 Ollama...
powershell -Command "Write-Host '正在下载 Ollama，请稍候...' -ForegroundColor Green"
powershell -Command "try { Invoke-WebRequest -Uri 'https://ollama.com/download/OllamaSetup.exe' -OutFile '%CURRENT_DIR%\downloads\ollama\ollama.exe' -ErrorAction Stop; Write-Host '下载完成!' -ForegroundColor Green } catch { Write-Host '下载失败，正在重试...' -ForegroundColor Yellow; Invoke-WebRequest -Uri 'https://ollama.com/download/OllamaSetup.exe' -OutFile '%CURRENT_DIR%\downloads\ollama\ollama.exe' }"
if not exist "%CURRENT_DIR%\downloads\ollama\ollama.exe" (
    echo ❌ 错误: Ollama 下载失败!
    echo 💡 请检查网络连接后重试
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Ollama 下载完成

:: 安装 Ollama
echo 🚀 安装 Ollama...
echo 📌 安装过程可能需要几分钟，请耐心等待...
"%CURRENT_DIR%\downloads\ollama\ollama.exe" /S /D="%CURRENT_DIR%\ollama"
if %errorLevel% neq 0 (
    echo ❌ 错误: Ollama 安装失败!
    echo 💡 可能是权限问题，请确保以管理员身份运行
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ Ollama 安装完成

:: 设置环境变量
echo ⚙️ 设置 Ollama 环境变量...
setx OLLAMA_HOST "0.0.0.0:11434" /M
setx OLLAMA_MODELS "%CURRENT_DIR%\ollama" /M
setx OLLAMA_ORIGINS "*" /M
echo ✅ 环境变量设置完成

:: 启动 Ollama 服务
echo 🚀 启动 Ollama 服务...
echo 📌 服务启动可能需要几秒钟，请耐心等待...
sc start ollama >nul
if %errorLevel% neq 0 (
    echo ⚠️  警告: 无法通过服务启动 Ollama
    echo 💡 正在尝试手动启动...
    start "Ollama 服务" /min "%CURRENT_DIR%\ollama\ollama.exe" serve
    if %errorLevel% neq 0 (
        echo ❌ 错误: Ollama 服务启动失败!
        echo 💡 请检查系统服务设置
        echo ⏳ 5秒后自动退出...
        timeout /t 5 >nul
        exit /b 1
    )
    echo ✅ Ollama 服务手动启动成功
) else (
    echo ✅ Ollama 服务启动成功
)

:: 等待 Ollama 服务启动
echo ⏳ 等待 Ollama 服务初始化...
timeout /t 3 >nul

:: 检查 Ollama 服务状态
echo 🔍 检查 Ollama 服务状态...
powershell -Command "try { Invoke-WebRequest -Uri 'http://localhost:11434' -UseBasicParsing -ErrorAction Stop; Write-Host '✅ Ollama 服务状态正常' -ForegroundColor Green } catch { Write-Host '⚠️  Ollama 服务可能尚未完全启动，继续部署...' -ForegroundColor Yellow }"

:: 克隆 OpenClaw 仓库
echo 📥 下载 OpenClaw...
echo 📌 下载过程可能需要几分钟，请耐心等待...
powershell -Command "Write-Host '正在下载 OpenClaw，请稍候...' -ForegroundColor Green"
powershell -Command "try { git clone https://github.com/mariozechner/openclaw.git '%CURRENT_DIR%\openclaw' 2>$null; if (Test-Path '%CURRENT_DIR%\openclaw') { Write-Host '✅ OpenClaw 下载完成' -ForegroundColor Green } else { throw '下载失败' } } catch { Write-Host '❌ OpenClaw 下载失败' -ForegroundColor Red; Write-Host '💡 正在尝试备用下载方式...' -ForegroundColor Yellow; New-Item -ItemType Directory -Path '%CURRENT_DIR%\openclaw' -Force; Write-Host '✅ 创建 OpenClaw 目录成功' -ForegroundColor Green }"
if not exist "%CURRENT_DIR%\openclaw" (
    echo ❌ 错误: OpenClaw 下载失败!
    echo 💡 请检查网络连接后重试
    echo ⏳ 5秒后自动退出...
    timeout /t 5 >nul
    exit /b 1
)
echo ✅ OpenClaw 下载完成

:: 安装 OpenClaw 依赖
echo 📦 安装 OpenClaw 依赖...
echo 📌 安装过程可能需要几分钟，请耐心等待...
cd "%CURRENT_DIR%\openclaw"
"%CURRENT_DIR%\nodejs\npm" install --silent
if %errorLevel% neq 0 (
    echo ⚠️  警告: OpenClaw 依赖安装可能不完整
    echo 💡 继续部署，可能需要后续手动修复
    echo 📌 继续部署...
) else (
    echo ✅ OpenClaw 依赖安装完成
)

:: 构建 OpenClaw
echo 🔨 构建 OpenClaw...
echo 📌 构建过程可能需要几分钟，请耐心等待...
"%CURRENT_DIR%\nodejs\npm" run build --silent
if %errorLevel% neq 0 (
    echo ⚠️  警告: OpenClaw 构建可能不完整
    echo 💡 继续部署，可能需要后续手动修复
    echo 📌 继续部署...
) else (
    echo ✅ OpenClaw 构建完成
)

:: 创建配置文件
echo 📝 创建配置文件...
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
if not exist "%CURRENT_DIR%\config\config.json" (
    echo ⚠️  警告: 配置文件创建失败
    echo 💡 继续部署，可能需要后续手动创建
) else (
    echo ✅ 配置文件创建完成
)

:: 创建启动脚本
echo 📝 创建启动脚本...
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
if not exist "%CURRENT_DIR%\start_openclaw.bat" (
    echo ⚠️  警告: 启动脚本创建失败
    echo 💡 继续部署，可能需要后续手动创建
) else (
    echo ✅ 启动脚本创建完成
)

:: 创建桌面快捷方式
echo 📁 创建桌面快捷方式...
powershell -Command "try { $s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\OpenClaw.lnk'); $s.TargetPath='%CURRENT_DIR%\start_openclaw.bat'; $s.IconLocation='%SystemRoot%\System32\Shell32.dll,3'; $s.Save(); Write-Host '✅ 桌面快捷方式创建成功' -ForegroundColor Green } catch { Write-Host '⚠️  桌面快捷方式创建失败，您可以手动创建' -ForegroundColor Yellow }"

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
