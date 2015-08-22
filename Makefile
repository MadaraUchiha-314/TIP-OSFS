all:start.o kernel.o linker.ld
	ld -m elf_i386 -T linker.ld -o myos.bin -nostdlib kernel.o start.o 
start.o:start.asm
	nasm -f elf start.asm -o start.o
kernel.o:kernel.c
	gcc -c kernel.c -o kernel.o -std=c99 -m32 -ffreestanding -O2
qemu:myos.bin
	cp myos.bin isodir/boot/myos.bin
	grub-mkrescue -o myos.iso isodir
	qemu-system-i386 -cdrom myos.iso
clean:
	rm -R *.o
	rm myos.bin
	rm myos.iso
