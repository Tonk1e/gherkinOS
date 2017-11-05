GCCPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = kernel.o loader.o

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
	sudo cp kernel.bin iso/boot/kernel.bin
	echo 'menuentry "gherkinOS" {multiboot /boot/kernel.bin}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=kernel.iso iso
	rm -rf iso

run: kernel.iso
	(killall VirtualBox && sleep 1) || true
	VirtualBox --startvm 'PickleOS' &

.PHONY: clean
clean:
	rm -f $(objects) kernel.bin kernel.iso
