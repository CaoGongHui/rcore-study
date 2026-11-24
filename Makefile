BOOK    := book
SPHINX  := .venv/bin/sphinx-build
PYTHON  ?= /home/cgh/.local/bin/python3.11

.PHONY: help book serve notes notes-all check clean-book

help:
	@echo "make book       构建教材 HTML 到 book/build/html"
	@echo "make serve      本地预览教材 http://localhost:8000"
	@echo "make notes      导出当前会话的问答笔记"
	@echo "make notes-all  导出本项目全部历史会话"
	@echo "make check      kernel 编译检查"

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
