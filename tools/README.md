# tools/

`qa-notes.mjs` 只是便捷入口，真正的实现在个人脚本目录（多个项目共用一份）：

- `~/.pi/agent/scripts/qa-notes/qa-notes.mjs` —— 导出逻辑
- `~/.pi/agent/scripts/qa-notes/projects.json` —— 笔记仓库路径与记录白名单
- `~/.pi/agent/extensions/qa-notes.ts` —— pi 扩展，每次回答结束自动同步

用法见仓库根目录 README 的「笔记」一节。
