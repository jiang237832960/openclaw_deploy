# OpenClaw + Ollama 一键部署程序

## 📁 项目结构

```
openclaw_deploy/
├── deploy_openclaw_ollama.bat    # 一键部署脚本
├── start_openclaw.bat             # 启动脚本
├── downloads/                     # 下载文件存放目录
├── nodejs/                        # Node.js 安装目录
├── python/                        # Python 安装目录
├── ollama/                        # Ollama 安装目录
├── openclaw/                      # OpenClaw 项目目录
├── config/                        # 配置文件
├── logs/                          # 日志文件
└── README.md                      # 使用说明
```

## 🚀 使用方法

### 1. 准备工作
- 确保计算机已连接互联网
- 确保以管理员身份运行脚本
- 确保有足够的存储空间（至少 20GB）

### 2. 获取云服务 API 密钥

#### 2.1 Groq API 密钥获取

**步骤：**
1. 访问 [Groq 官方网站](https://console.groq.com/)
2. 点击 "Sign Up" 注册账号
3. 验证邮箱和手机号
4. 登录后，进入 "API Keys" 页面
5. 点击 "Create API Key" 生成新的 API 密钥
6. 复制并保存 API 密钥

**免费额度：**
- 每月提供一定数量的免费 API 调用
- 支持 Llama 3 8B 和 70B 模型

#### 2.2 其他云服务 API 密钥获取

**Google AI Studio：**
- 访问 [Google AI Studio](https://makersuite.google.com/)
- 使用 Google 账号登录
- 同意服务条款
- 进入 "API Keys" 部分
- 创建并复制 API 密钥

**Anthropic Claude：**
- 访问 [Anthropic 官方网站](https://console.anthropic.com/)
- 点击 "Sign Up" 注册账号
- 验证邮箱
- 登录后，进入 "API Keys" 页面
- 创建并复制 API 密钥

### 3. 执行部署
1. 双击运行 `deploy_openclaw_ollama.bat`
2. 等待部署完成（约 10-15 分钟）
3. 部署过程中会自动下载并安装所有依赖项

### 4. 启动系统
- 部署完成后，桌面会创建 "OpenClaw" 快捷方式
- 双击快捷方式启动系统
- 或运行 `start_openclaw.bat` 脚本

## 🔧 系统配置

### Ollama 配置
- 默认安装在 `ollama` 目录
- 默认服务地址：http://localhost:11434
- 支持配置云模型服务

### OpenClaw 配置
- 默认安装在 `openclaw` 目录
- 已配置使用 Ollama 作为模型提供商
- 支持多种运行模式

## 📞 技术支持

### 常见问题
1. **部署失败**：检查网络连接和管理员权限
2. **服务无法启动**：检查端口是否被占用
3. **模型加载失败**：检查 Ollama 服务状态

### 日志文件
- 部署日志：`logs\deploy.log`
- 运行日志：`logs\runtime.log`

## 📄 许可证

本项目基于 MIT 许可证开源。