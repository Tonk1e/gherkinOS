.set MAGIC, 0xbadb002
.set FLAGS, (1<<0 | 1<<1)
.set CHECKSUM, -(MAGIC + FLAGS)
.global loader

.section .text
.section .mbheader
.extern .text
.extern kernelmain
.extern callConstructors

loader:
	mov $kernel_stack, %esp
	call callConstructors
	push %eax
	push %ebx
	call kernelmain

_stop:
	cli
	hlt
	jmp _stop

.section .bss
.space 2*1024*1024
kernel_stack:
