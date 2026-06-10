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
> 如果开发环境在容器中，将"baseURL"改为："baseURL": "http://ollama:11434/v1"

查看 Ollama 已有模型：

```bash
docker exec <ollama容器名> ollama list
```

按需修改 `opencode.json` 中的 `models` 和 `model` 字段。

---

## 四、配置 Skills（可选，推荐）

Skills 是可复用的指令集，让 AI 在调试、代码审查、任务规划等场景表现更专业。安装后无需手动调用，opencode 会根据你的任务描述自动匹配加载。

### 方法一：使用现成 Skills 合集（推荐）

```bash
# 克隆 agent-skills 合集
git clone https://github.com/addyosmani/agent-skills /tmp/agent-skills

# 创建全局 skills 目录
mkdir -p ~/.config/opencode/skills

# 按需复制（以下为 C++/Qt 后端开发推荐组合）
cp -r /tmp/agent-skills/skills/debugging-and-error-recovery \
      /tmp/agent-skills/skills/code-review-and-quality \
      /tmp/agent-skills/skills/test-driven-development \
      /tmp/agent-skills/skills/planning-and-task-breakdown \
      /tmp/agent-skills/skills/incremental-implementation \
      /tmp/agent-skills/skills/spec-driven-development \
      /tmp/agent-skills/skills/performance-optimization \
      ~/.config/opencode/skills/
```

### 方法二：手动创建自定义 Skill

每个 skill 是一个文件夹，里面放一个 `SKILL.md`：

```bash
mkdir -p ~/.config/opencode/skills/my-skill
cat > ~/.config/opencode/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: 描述这个 skill 的用途和触发时机
---

# Skill 名称

在这里写给 AI 的指令和流程...
EOF
```

### Skills 目录结构

```
~/.config/opencode/skills/          # 全局，所有项目可用
└── debugging-and-error-recovery/
    └── SKILL.md

your-project/.opencode/skills/      # 项目级，仅当前项目可用
└── my-custom-skill/
    └── SKILL.md
```

### 验证安装

重启 opencode 后在对话中输入：

```
你有哪些 skills？
```

AI 会列出所有已加载的 skill 列表。

### 使用方式

Skills 会根据任务描述自动触发，无需手动调用：

| 你的描述                     | 自动触发的 Skill               |
| ---------------------------- | ------------------------------ |
| "这个函数崩溃了，帮我排查"   | `debugging-and-error-recovery` |
| "帮我审查这个类的设计"       | `code-review-and-quality`      |
| "我要新增一个功能，帮我规划" | `planning-and-task-breakdown`  |
| "这段代码太慢了，帮我优化"   | `performance-optimization`     |

也可以显式指定：

```
使用 spec-driven-development skill，帮我设计 UdpManager 的接口
```

---

## 五、日常使用

```bash
cd ~/workspace/code/your-project
opencode
```

| 操作                   | 快捷键         |
| ---------------------- | -------------- |
| 发送消息               | `Enter`        |
| 切换 Agent 模式        | `Tab`          |
| 引用文件               | 输入 `@文件名` |
| 命令面板（切换模型等） | `Ctrl+P`       |
| 退出                   | `Ctrl+C`       |

---

## 六、切换到付费模型（后续）

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

| 平台      | baseURL                                         |
| --------- | ----------------------------------------------- |
| DeepSeek  | `https://api.deepseek.com/v1`（内置，无需填写） |
| OpenAI    | `https://api.openai.com/v1`（内置）             |
| Anthropic | `https://api.anthropic.com`（内置）             |

---

## 七、常见问题

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