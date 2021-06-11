
oops_example.ko:     file format elf32-i386

Disassembly of section .text:

00000000 <oopsexam_read>:
   0:	8b 44 24 0c          	mov    0xc(%esp,1),%eax
   4:	c7 05 00 00 00 00 01 	movl   $0x1,0x0
   b:	00 00 00 
   e:	c3                   	ret    

0000000f <oopsexam_write>:
   f:	8b 44 24 0c          	mov    0xc(%esp,1),%eax
  13:	c7 05 00 00 00 00 01 	movl   $0x1,0x0
  1a:	00 00 00 
  1d:	c3                   	ret    
  1e:	90                   	nop    
  1f:	90                   	nop    
Disassembly of section .init.text:

00000000 <init_module>:
   0:	83 ec 10             	sub    $0x10,%esp
   3:	89 5c 24 0c          	mov    %ebx,0xc(%esp,1)
   7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp,1)
   e:	00 
   f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp,1)
  16:	00 
  17:	c7 04 24 fb 00 00 00 	movl   $0xfb,(%esp,1)
  1e:	e8 fc ff ff ff       	call   1f <init_module+0x1f>
  23:	85 c0                	test   %eax,%eax
  25:	89 c3                	mov    %eax,%ebx
  27:	74 16                	je     3f <init_module+0x3f>
  29:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp,1)
  30:	e8 fc ff ff ff       	call   31 <init_module+0x31>
  35:	89 d8                	mov    %ebx,%eax
  37:	8b 5c 24 0c          	mov    0xc(%esp,1),%ebx
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	c3                   	ret    
  3f:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp,1)
  46:	eb e8                	jmp    30 <init_module+0x30>
Disassembly of section .exit.text:

00000000 <cleanup_module>:
   0:	83 ec 08             	sub    $0x8,%esp
   3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp,1)
   a:	00 
   b:	c7 04 24 fb 00 00 00 	movl   $0xfb,(%esp,1)
  12:	e8 fc ff ff ff       	call   13 <cleanup_module+0x13>
  17:	85 c0                	test   %eax,%eax
  19:	74 10                	je     2b <cleanup_module+0x2b>
  1b:	c7 04 24 3d 00 00 00 	movl   $0x3d,(%esp,1)
  22:	e8 fc ff ff ff       	call   23 <cleanup_module+0x23>
  27:	83 c4 08             	add    $0x8,%esp
  2a:	c3                   	ret    
  2b:	c7 04 24 59 00 00 00 	movl   $0x59,(%esp,1)
  32:	eb ee                	jmp    22 <cleanup_module+0x22>
