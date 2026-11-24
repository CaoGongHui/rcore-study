#!/usr/bin/env node
/**
 * 本项目内的便捷入口，实际逻辑在个人脚本目录（os / rCore-Tutorial-v3 共用一份）：
 *   ~/.pi/agent/scripts/qa-notes/qa-notes.mjs
 *
 * 用法示例：
 *   node tools/qa-notes.mjs              # 导出当前会话
 *   node tools/qa-notes.mjs --tag ch1    # 指定标签
 *   node tools/qa-notes.mjs --all        # 导出本项目所有历史会话
 */
import { spawnSync } from "node:child_process";
import { join } from "node:path";
import { homedir } from "node:os";

const script = join(homedir(), ".pi/agent/scripts/qa-notes/qa-notes.mjs");
const r = spawnSync(process.execPath, [script, ...process.argv.slice(2)], { stdio: "inherit" });
process.exit(r.status ?? 1);
