# Q&A 学习笔记

记录在 pi 里问过的每个问题与回答，自动生成，用来复习 rCore 学习过程。

## 目录结构

```
notes/
├── os/                 # 在旧目录 ~/github/os 里进行的对话
├── rCore-Tutorial-v3/  # 在官方代码仓目录里进行的对话
└── rcore-study/        # 本仓库（含 kernel/ 子目录）的对话
```

一次会话一个文件，命名 `<日期>-<时分>-<第一个问题摘要>.md`。

## 自动记录

pi 扩展：`~/.pi/agent/extensions/qa-notes.ts`

- 每次回答结束（`agent_settled`）自动重写当前会话的笔记文件
- 退出或切换会话时再同步一次
- 只对白名单目录生效，配置在 `~/.pi/agent/scripts/qa-notes/projects.json`：

  ```json
  {
    "enabled": true,
    "vault": "/home/cgh/github/rcore-study/notes",
    "dirs": [
      "/home/cgh/github/rcore-study",
      "/home/cgh/github/os",
      "/home/cgh/github/rCore-Tutorial-v3"
    ]
  }
  ```

  `vault` 是笔记总目录；`dirs` 里的每个根目录对应 `notes/` 下的一个同名子目录（子目录里的会话归到根项目）。
  `PI_QA_NOTES_ALL=1` 可临时对所有目录生效，`PI_QA_NOTES_DIR` 可临时换笔记目录。

## 手动导出

```bash
# 当前会话（读 $PI_SESSION_FILE）
node tools/qa-notes.mjs

# 指定标签 / 导出本项目全部历史会话 / 只看不写
node tools/qa-notes.mjs --tag ch1
node tools/qa-notes.mjs --all
node tools/qa-notes.mjs --stdout

# 附带思考过程、去掉工具调用明细
node tools/qa-notes.mjs --thinking --no-tools
```

会话中也可以输入 `/notes` 立即导出并提示路径。

## 自己往笔记里补充内容

每个文件末尾都有这一行，写在它下面的内容在自动重写时**不会**被覆盖：

```markdown
<!-- 手动笔记：以下内容在自动重写时会被保留 -->
```

行以上的部分每次都会被会话原文重新生成，不要直接改。
