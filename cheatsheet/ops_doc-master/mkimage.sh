mkimage在制作映象文件的时候，是在原来的可执行映象文件的前面加上一个0x40
字节的头，记录参数所指定的信息，这样uboot才能识别这个映象是针对哪个CPU
体系结构的，哪个OS的，哪种类型，加载内存中的哪个位置， 入口点在内存的
那个位置以及映象名是什么

Usage: mkimage -l image
          -l ==> list image header information
       mkimage [-x] -A arch -O os -T type -C comp -a addr -e ep -n name -d data_file[:data_file...] image
          -A ==> set architecture to 'arch'         # -A 指定CPU的体系结构：
          -O ==> set operating system to 'os'       # -O 指定操作系统类型
          -T ==> set image type to 'type'           # -T 指定映象类型，可以取以下值：standalone、kernel、ramdisk、multi、firmware、script、filesystem
          -C ==> set compression type 'comp'        # -C 指定映象压缩方式，可以取以下值：
          -a ==> set load address to 'addr' (hex)   # -a 指定映象在内存中的加载地址，映象下载到内存中时，要按照用mkimage制作映象时，这个参数所指定的地址值来下载
          -e ==> set entry point to 'ep' (hex)      # -e 指定映象运行的入口点地址，这个地址就是-a参数指定的值加上0x40
          -n ==> set image name to 'name'           # -n 指定映象名
          -d ==> use image data from 'datafile'     # -d 指定制作映象的源文件
          -x ==> set XIP (execute in place)
       mkimage [-D dtc_options] [-f fit-image.its|-F] fit-image
          -D => set options for device tree compiler
          -f => input filename for FIT source
Signing / verified boot not supported (CONFIG_FIT_SIGNATURE undefined)
       mkimage -V ==> print version information and exit
       
arch(){
取值 表示的体系结构
alpha Alpha
arm A RM
x86 Intel x86
ia64 IA64
mips MIPS
mips64 MIPS 64 Bit
ppc PowerPC
s390 IBM S390
sh SuperH
sparc SPARC
sparc64 SPARC 64 Bit
m68k MC68000
} 
os(){
-O 指定操作系统类型，可以取以下值：
openbsd、netbsd、freebsd、4_4bsd、linux、svr4、esix、solaris、irix、sco、dell、ncr、lynxos、vxworks、psos、qnx、u-boot、rtems、artos
}

comp(){
-C 指定映象压缩方式，可以取以下值：
none 不压缩
gzip 用gzip的压缩方式
bzip2 用bzip2的压缩方式
}

addr(){
-a 指定映象在内存中的加载地址，映象下载到内存中时，要按照用mkimage制作映象时，这个参数所指定的地址值来下载
}


mkimage(U-BOOT下使用bootm引导内核方法){
一、在开始之前先说明一下bootm相关的东西。
1、 首先说明一下，S3C2410架构下的bootm只对sdram中的内核镜像文件进行操作(好像AT91架构提供了一段从flash复制
    内核镜像的代码， 不过针对s3c2410架构就没有这段代码，虽然可以在u-boot下添加这段代码，不过好像这个用处不大)，
    所以请确保你的内核镜像下载到sdram 中，或者在bootcmd下把flash中的内核镜像复制到sdram中。
2、-a参数后是内核的加载地址，-e参数后是执行入口地址。

3、
1）如果我们没用mkimage对内核进行处理的话，那直接把内核下载到0x30008000再运行就行，内核会自解压运行（不过内核
   运行需要一个tag来传递参数，而这个tag建议是由bootloader提供的，在u-boot下默认是由bootm命令建立的）。
2）如果使用mkimage生成内核镜像文件的话，会在内核的前头加上了64byte的信息，供建立tag之用。bootm命令会首先判断
   bootm xxxx 这个指定的地址xxxx是否与-a指定的加载地址相同。
(1)如果不同的话会从这个地址开始提取出这个64byte的头部，对其进行分析，然后把去掉头部的内核复制到-a指定的load地址中去运行之
(2)如果相同的话那就让其原封不同的放在那，但-e指定的入口地址会推后64byte，以跳过这64byte的头部。

# 方法1
1、首先，用u-boot/tools/mkimage这个工具为你的内核加上u-boot引导所需要的文件头，具体做法如下：
mkimage -n 'linux-2.6.14' -A arm -O linux -T kernel -C none -a 0x30008000 -e 0x30008000 -d zImage zImage.img
2 、下载内核
sbc2410=>tftp 0x31000000 zImage.img  
3.运行 
sbc2410=>bootm 0x31000000

# 方法2
1、首先，用u-boot/tools/mkimage这个工具为你的内核加上u-boot引导所需要的文件头，具体做法如下：
mkimage -n 'linux-2.6.14' -A arm -O linux -T kernel -C none -a 0x30008000 -e 0x30008040 -d zImage zImage.img
2 、下载内核 
sbc2410=>tftp 0x30008000 zImage.img
3.运行 
sbc2410=>bootm 0x30008000

}

mkimage -l uImage
mkimage -A powerpc -O linux -T kernel -C gzip -a 0 -e 0 -n Linux -d vmlinux.gz uImage
mkimage -f kernel.its kernel.itb
mkimage -f kernel.its -k /public/signing-keys -K u-boot.dtb -c Kernel 3.8 image for production devices kernel.itb
mkimage -F -k /secret/signing-keys -K u-boot.dtb -c Kernel 3.8 image for production devices kernel.itb

image_header(){
typedef struct image_header {
	uint32_t	ih_magic;	/* Image Header Magic Number	*/
	uint32_t	ih_hcrc;	/* Image Header CRC Checksum	*/
	uint32_t	ih_time;	/* Image Creation Timestamp	*/
	uint32_t	ih_size;	/* Image Data Size		*/
	uint32_t	ih_load;	/* Data	 Load  Address		*/
	uint32_t	ih_ep;		/* Entry Point Address		*/
	uint32_t	ih_dcrc;	/* Image Data CRC Checksum	*/
	uint8_t		ih_os;		/* Operating System		*/
	uint8_t		ih_arch;	/* CPU architecture		*/
	uint8_t		ih_type;	/* Image Type			*/
	uint8_t		ih_comp;	/* Compression Type		*/
	uint8_t		ih_name[IH_NMLEN];	/* Image Name		*/
} image_header_t;
}

简易mkimage extract 工具

由已知的档案信息及mkimage -l 可取出各另image
采用dd來分解档案
IMG0_SIZE 为image size
IMG0_SKIP_SIZE 为需要刪除的档案byte数
shell script extract mkimagelink
dd if=$file_name of=$IMG_TMP bs=$skip_len skip=1
dd if=$IMG_TMP of=$img_name bs=$img_len count=1
