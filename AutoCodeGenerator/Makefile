# Execute on linux.
# the result file is code.hex and forpaste.txt.

all: code.hex
	echo "make complete!"

code.hex: code.c 
	gcc -Wall -o bin2hex bin2hex.c
	mips-linux-gnu-gcc -O0 -mips32 -nostdlib -ffreestanding -S -o code.asm $<
	sed -i -e 's/.*\$$fp.*//g' -e 's/.*\$$sp.*//g' -e 's/.*jr\t.*//g' -e 's/.*nop.*//g' -e 's/.*fp=.*//g' code.asm
	mips-linux-gnu-as -o code.elf code.asm
	mips-linux-gnu-objdump -dj .text code.elf > code.text
	mips-linux-gnu-objcopy -O binary --only-section=.text code.elf code.bin
	./bin2hex code.bin > $@
	./forpaste.sh

clean:
	rm -f code.hex
	rm -f code.bin
	rm -f code.text
	rm -f code.elf
	rm -f code.asm
	rm -f bin2hex
	rm -f forpaste.txt
	echo "make clear complete!"

