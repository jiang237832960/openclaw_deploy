# OpenClaw + Ollama 一键部署程序

## 📁 项目结构

```
openclaw_deploy/
├── deploy_files/                  # 部署文件目录
│   ├── deploy_openclaw_ollama.bat    # 一键部署脚本
│   ├── start_openclaw.bat             # 启动脚本
│   ├── downloads/                     # 下载文件存放目录
│   ├── nodejs/                        # Node.js 安装目录
│   ├── python/                        # Python 安装目录
│   ├── ollama/                        # Ollama 安装目录
│   ├── openclaw/                      # OpenClaw 项目目录
│   ├── config/                        # 配置文件
│   └── logs/                          # 日志文件
└── README.md                      # 使用说明
```

## 🚀 使用方法

### 1. 准备工作
- 确保计算机已连接互联网
- 确保以管理员身份运行脚本
- 确保有足够的存储空间（至少 20GB）

### 2. 执行部署
1. 进入 `deploy_files` 目录
2. 双击运行 `deploy_openclaw_ollama.bat`
3. 等待部署完成（约 10-15 分钟）
4. 部署过程中会自动下载并安装所有依赖项

### 3. 启动系统
- 部署完成后，桌面会创建 "OpenClaw" 快捷方式
- 双击快捷方式启动系统
- 或进入 `deploy_files` 目录，运行 `start_openclaw.bat` 脚本

## 🔧 系统配置

### Ollama 配置
- 默认安装在 `deploy_files/ollama` 目录
- 默认服务地址：http://localhost:11434
- 支持配置云模型服务

### OpenClaw 配置
- 默认安装在 `deploy_files/openclaw` 目录
- 已配置使用 Ollama 作为模型提供商
- 支持多种运行模式

## 📞 技术支持

### 常见问题
1. **部署失败**：检查网络连接和管理员权限
2. **服务无法启动**：检查端口是否被占用
3. **模型加载失败**：检查 Ollama 服务状态

### 日志文件
- 部署日志：`deploy_files/logs\deploy.log`
- 运行日志：`deploy_files/logs\runtime.log`

## 📄 许可证

本项目基于 MIT 许可证开源。
