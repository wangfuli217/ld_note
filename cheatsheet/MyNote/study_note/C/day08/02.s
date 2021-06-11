	.file	"02.c"
	.section	.rodata
.LC0:
	.string	"%d X %d = %d\n"
	.text
.globl print
	.type	print, @function
print:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, %edx
	imull	12(%ebp), %edx
	movl	$.LC0, %eax
	movl	%edx, 12(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	printf
	leave
	ret
	.size	print, .-print
.globl main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$16, %esp
	movl	$9, 4(%esp)
	movl	$1, (%esp)
	call	print
	movl	$8, 4(%esp)
	movl	$2, (%esp)
	call	print
	movl	$7, 4(%esp)
	movl	$3, (%esp)
	call	print
	movl	$6, 4(%esp)
	movl	$4, (%esp)
	call	print
	movl	$5, 4(%esp)
	movl	$5, (%esp)
	call	print
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.4.7-1ubuntu2) 4.4.7"
	.section	.note.GNU-stack,"",@progbits
