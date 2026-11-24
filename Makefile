BOOK    := book
SPHINX  := .venv/bin/sphinx-build
PYTHON  ?= /home/cgh/.local/bin/python3.11
MSG     ?= update $(shell date +"%Y-%m-%d %H:%M")

.PHONY: help book serve notes notes-all check clean-book status push

help:
	@echo "make book       构建教材 HTML 到 book/build/html"
	@echo "make serve      本地预览教材 http://localhost:8000"
	@echo "make notes      导出当前会话的问答笔记"
	@echo "make notes-all  导出本项目全部历史会话"
	@echo "make check      kernel 编译检查"
	@echo "make status      看工作区状态"
	@echo "make push        提交并推送（make push MSG=\"说明\"）"

book:
	cd $(BOOK) && make html SPHINXBUILD=$(SPHINX)

serve:
	@echo "http://localhost:8000"
	python3 -m http.server 8000 --directory $(BOOK)/build/html

notes:
	node tools/qa-notes.mjs

notes-all:
	node tools/qa-notes.mjs --all

check:
	cd kernel && cargo build 2>&1 | tail -5

clean-book:
	rm -rf $(BOOK)/build

status:
	git status -sb

# 提交并推送；无改动时只推送（比如只更新了笔记之外的东西）
push:
	@git add -A
	@if git diff --cached --quiet; then \
		echo "没有需要提交的改动"; \
	else \
		git commit -q -m "$(MSG)" && echo "已提交：$(MSG)"; \
	fi
	@git push
	@echo "已推送到 $$(git remote get-url origin)（分支 $$(git rev-parse --abbrev-ref HEAD)）"
