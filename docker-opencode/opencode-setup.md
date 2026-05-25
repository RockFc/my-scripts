# OpenCode 安装与配置指南

适用场景：Windows → VSCode Remote-SSH → Linux 服务器 + Ollama 本地模型

---

## 前置条件

- Linux 服务器已运行 Ollama（Docker 容器或直接安装均可）
- Windows 本地通过 VSCode Remote-SSH 连接服务器
- 无需额外安装终端模拟器，VSCode 内置终端即可

---

## 一、修复 curl（如遇 symbol lookup error）

如果服务器 curl 报 `undefined symbol` 错误，通常是 `/usr/local/bin/curl` 与系统 libcurl 版本不匹配：

```bash
# 查找冲突的 curl
which curl

# 若输出 /usr/local/bin/curl，删除它
sudo rm /usr/local/bin/curl

# 刷新 shell 缓存
hash -r
curl --version  # 应显示 /usr/bin/curl 7.x
```

---

## 二、安装 OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
source ~/.bashrc
opencode --version
```

---

## 三、配置 Ollama 本地模型

```bash
mkdir -p ~/.config/opencode

cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "qwen2.5-coder:14b": {
          "name": "qwen2.5-coder:14b"
        },
        "qwen2.5-coder:7b": {
          "name": "qwen2.5-coder:7b"
        },
        "deepseek-coder-v2:16b": {
          "name": "deepseek-coder-v2:16b"
        },
        "qwen3:14b": {
          "name": "qwen3:14b"
        }
      }
    }
  },
  "model": "ollama/qwen2.5-coder:14b"
}
EOF
```

> **注意**：配置文件名必须是 `opencode.json`，不是 `config.json`。
> 字段名是 `provider`（单数），不是 `providers`。

查看 Ollama 已有模型：

```bash
docker exec <ollama容器名> ollama list
```

按需修改 `opencode.json` 中的 `models` 和 `model` 字段。

---

## 四、日常使用

```bash
cd ~/workspace/code/your-project
opencode
```

| 操作 | 快捷键 |
|---|---|
| 发送消息 | `Enter` |
| 切换 Agent 模式 | `Tab` |
| 引用文件 | 输入 `@文件名` |
| 命令面板（切换模型等） | `Ctrl+P` |
| 退出 | `Ctrl+C` |

---

## 五、切换到付费模型（后续）

只需修改 `opencode.json`，增加对应 provider 配置即可，例如 DeepSeek：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "deepseek": {
      "apiKey": "你的API_KEY",
      "models": {
        "deepseek-chat": { "name": "DeepSeek V3" },
        "deepseek-reasoner": { "name": "DeepSeek R1" }
      }
    }
  },
  "model": "deepseek/deepseek-chat"
}
```

各平台 API 地址参考：

| 平台 | baseURL |
|---|---|
| DeepSeek | `https://api.deepseek.com/v1`（内置，无需填写） |
| OpenAI | `https://api.openai.com/v1`（内置） |
| Anthropic | `https://api.anthropic.com`（内置） |

---

## 六、常见问题

**Q：启动报 `ConfigInvalidError`**
配置文件格式错误，检查：文件名是否为 `opencode.json`、字段名是否为 `provider`（单数）。

**Q：启动报 `command not found`**
```bash
source ~/.bashrc
```

**Q：TUI 界面乱码/框线显示异常**
在 VSCode 设置中将终端字体改为等宽字体，如 `JetBrains Mono` 或 `Cascadia Code`。

**Q：模型连接失败**
```bash
# 验证 Ollama 是否可访问
curl http://localhost:11434/api/tags
```