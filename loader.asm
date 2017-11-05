.set MAGIC, 0xbadb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
	.long MAGIC
	.long FLAGS
	.long CHECKSUM

.section .text
.extern .text
.extern kernel_main
.global loader

loader:
	push %eax
	push %ebx
	call kernel_main

.section .bss
