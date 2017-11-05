# T H A N K S   T O   E U A B
GCCPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386
objects = loader.o kernel.o

%.o: %.cpp
	gcc $(GCCPARAMS) -c -o $@ $<

%.o: %.s
	as $(ASPARAMS) -o $@ $<

kernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

install: kernel.bin
	sudo cp $< /boot/mykernel.bin

kernel.iso: kernel.iso
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	mkdir iso/boot/kernel
	cp kernel.bin iso/boot/kernel/kernel.bin
	echo 'menuentry "gherkinOS" {multiboot /boot/kernel/kernel.bin}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=kernel.iso iso
	rm -rf iso

run: kernel.iso
	(killall VirtualBox && sleep 1) || true
	VirtualBox --startvm 'gherkinOS' &

.PHONY: clean
clean:
	rm -f $(objects) kernel.bin kernel.iso
