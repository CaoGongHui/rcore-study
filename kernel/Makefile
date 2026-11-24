# 内核实验的构建 / 运行入口（在 kernel/ 目录内使用）
#
#   make build      编译（默认 release）
#   make bin        编译并剥出裸二进制 os.bin
#   make run        QEMU 跑起来（退出：先按 Ctrl+A，再按小写 x）
#   make run-gdb    同上，但等在 :1234 上，用 gdb 连
#   make objdump    看各段地址和开头几条指令
#   make PROFILE=debug run   用 debug 构建
#
# rustsbi 用外部教程仓里的那份；换位置就 SBI=/path/to/rustsbi-qemu.bin make run

TARGET    := riscv64gc-unknown-none-elf
PROFILE   ?= release
CARGO_ARG := $(if $(filter release,$(PROFILE)),--release,)

OUTDIR := target/$(TARGET)/$(PROFILE)
ELF    := $(OUTDIR)/os
BIN    := $(OUTDIR)/os.bin

SBI   ?= $(HOME)/github/rCore-Tutorial-v3/bootloader/rustsbi-qemu.bin
QEMU  ?= qemu-system-riscv64
QEMU_BASE := -machine virt -nographic -bios $(SBI) \
             -device loader,file=$(BIN),addr=0x80200000

.PHONY: help build bin run run-gdb objdump headers clean check-sbi

help:
	@echo "make build                编译（默认 release，PROFILE=debug 切 debug）"
	@echo "make bin                  编译并剥出裸二进制 os.bin"
	@echo "make run                  QEMU 跑起来（退出：Ctrl+A 再按小写 x）"
	@echo "make run-gdb              同上，停在第一条指令等 gdb 连 :1234"
	@echo "make headers              看各段地址（.text 应为 0x80200000）"
	@echo "make objdump              看开头几条反汇编指令"
	@echo "make clean                清掉 target/"
	@echo ""
	@echo "rustsbi: $(SBI)"

build:
	cargo build $(CARGO_ARG)

check-sbi:
	@test -f "$(SBI)" || { echo "找不到 rustsbi: $(SBI)"; \
	  echo "用 SBI=/path/to/rustsbi-qemu.bin make run 指定"; exit 1; }

# QEMU 的 loader 只认裸二进制，不认 ELF 头
bin: build
	rust-objcopy --strip-all $(ELF) -O binary $(BIN)
	@echo "镜像: $(BIN)  ($$(stat -c%s $(BIN)) 字节)"

run: bin check-sbi
	$(QEMU) $(QEMU_BASE)

# 停在第一条指令，另开终端: gdb -q $(ELF)
run-gdb: bin check-sbi
	@echo "gdb 连 :1234  →  gdb -q $(ELF)"
	@echo "  (gdb) set architecture riscv:rv64"
	@echo "  (gdb) target remote :1234"
	$(QEMU) $(QEMU_BASE) -s -S

objdump: bin
	rust-objdump -d $(ELF) | head -30

headers: bin
	@rust-objdump -h $(ELF) | sed -n '1,12p'
	@echo "---"
	@echo "期望 .text 的 VMA 是 0x80200000；不是的话检查 .cargo/config.toml 的 rustflags"

clean:
	cargo clean
