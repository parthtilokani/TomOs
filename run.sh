rm boot.bin
rm kernel.bin
rm floopy.img
rm CustomOS.iso
echo "hello"
ls
nasm bootloader.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin
echo "ok"
dd if=/dev/zero of=floopy.img bs=1024 count=1440
echo "count"
dd if=boot.bin of=floopy.img seek=0 conv=notrunc
dd if=kernel.bin of=floopy.img bs=512 seek=1 conv=notrunc
cp floopy.img iso/
genisoimage -quiet -V 'CustomOS' -input-charset iso8859-1 -o CustomOS.iso -b floopy.img -hide floopy.img iso/

