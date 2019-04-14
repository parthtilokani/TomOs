rm ../os_output/boot.bin
rm ../os_output/kernel.bin
rm ../os_output/floopy.img
rm ../os_output/CustomOS.iso
echo "hello"
ls
nasm ~/os/bootloader/bootloader.asm -f bin -o ../os_output/boot.bin
nasm ~/os/bootloader/kernel.asm -f bin -o ../os_output/kernel.bin
echo "ok"
dd if=/dev/zero of=../os_output/floopy.img bs=1024 count=1440
echo "count"
dd if=../os_output/boot.bin of=../os_output/floopy.img seek=0 conv=notrunc
dd if=../os_output/kernel.bin of=../os_output/floopy.img bs=512 seek=1 conv=notrunc
cp ../os_output/floopy.img ../os_output/iso/
#genisoimage -quiet -V 'CustomOS' -input-charset iso8859-1 -o CustomOS.iso -b floopy.img -hide floopy.img iso/

