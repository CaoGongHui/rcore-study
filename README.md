# rCore 学习仓库

文档、实验代码、问答笔记集中在一个仓库里，一边读一边写一边记。

```
rcore-study/
├── book/      # 教材正文（submodule: rcore-os/rCore-Tutorial-Book-v3，Sphinx 中文版）
├── kernel/    # 自己写的内核实验代码（原来在 ~/github/os）
├── notes/     # 每次和 AI 问答的 Markdown 笔记（自动生成，按项目分目录）
└── tools/     # 笔记导出脚本的便捷入口
```

## 教材（book/）

- 在线版：<https://rcore-os.cn/rCore-Tutorial-Book-v3/>
- 本地版：`book/source/` 是全部章节正文（`.rst`），`make book` 构建成 HTML。

```bash
make book     # 构建到 book/build/html（首次会复用 book/.venv，Python 3.11）
make serve    # 起本地静态服务器 http://localhost:8000
```

改动/更新教材：

```bash
git submodule update --remote book      # 拉上游最新
cd book && make html SPHINXBUILD=.venv/bin/sphinx-build
```

`book/.venv`、`book/build`、`book/os-lectures`（章节配图，按需从上游个别拉取）都不入库。

## 实验（kernel/）

自己的内核代码，按教材章节逐步演进：

```bash
cd kernel
cargo build                 # 目标平台 riscv64gc-unknown-none-elf，见 .cargo/config.toml
cargo run                   # 配好 runner 后可直接在 QEMU 里跑
```

需要参考官方实现时用外部目录 `/home/cgh/github/rCore-Tutorial-v3`（含 ch1~ch8 分支），
不放进本仓库，避免 365MB 的重复拷贝。

## 笔记（notes/）

一次会话一个文件，按会话所属项目分目录：

```
notes/os/                 # 在旧目录 ~/github/os 里进行的对话
notes/rCore-Tutorial-v3/  # 在官方代码仓目录里问的问题
notes/rcore-study/        # 本仓库（含 kernel/ 下）的对话
```

自动记录靠 pi 扩展 `~/.pi/agent/extensions/qa-notes.ts`：每次回答结束重写当前会话的笔记，
退出时再同步一次；白名单和笔记仓库在 `~/.pi/agent/scripts/qa-notes/projects.json` 里配置。

手动导出：

```bash
node tools/qa-notes.mjs           # 当前会话
node tools/qa-notes.mjs --all     # 本目录全部历史会话
node tools/qa-notes.mjs --tag ch1 --no-tools
```

注意：笔记正文每次都会被会话原文重写，手写补充请写在文件末尾这一行下面：

```markdown
<!-- 手动笔记：以下内容在自动重写时会被保留 -->
```

## 常用命令

```bash
make book     # 构建教材 HTML
make serve    # 本地预览教材
make notes    # 导出当前会话的问答笔记
make check    # kernel 编译检查
make status   # 看工作区状态
make push     # 提交全部改动并推送（可带说明：make push MSG="ch1: 完成实验"）
```
