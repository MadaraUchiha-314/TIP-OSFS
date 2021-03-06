all:start.o kernel.o ./scripts/linker.ld
	ld -m elf_i386 -T ./scripts/linker.ld -o myos.bin -nostdlib kernel.o start.o 
start.o:./init/start.asm
	nasm -f elf ./init/start.asm -o start.o
kernel.o:./kernel/kernel.c
	gcc -c ./kernel/kernel.c -o kernel.o -std=c99 -m32 -ffreestanding -O2
qemu:myos.bin
	cp myos.bin isodir/boot/myos.bin
	grub-mkrescue -o myos.iso isodir
	qemu-system-i386 -cdrom myos.iso
clean:
	rm -R -f *.o
	rm -f ./*.bin ./isodir/boot/*.bin
	rm -f myos.iso
