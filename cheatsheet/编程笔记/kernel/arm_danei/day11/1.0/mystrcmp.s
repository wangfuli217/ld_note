.text
.code 32
.global my_strcmp
my_strcmp:
    ldr r0, =str1 @获取str1地址给r0
    ldr r1, =str2 @获取str2地址给r1

loop:
    ldrb r2,[r0], #1 @获取str1每一个字符
    ldrb r3,[r1], #1 @获取str2每一个字符
    cmp r2, #0       @判断str1是否为空
    beq cmp_end      @如果为空,不进行比较
    cmp r2, r3       @比较字符是否相等
    beq loop         @如果字符相等,继续比较
                     @如果不相等,不再执行loop
                     @代码继续往下执行cmp_end
cmp_end:
    sub r0, r2, r3   @利用qemu观察r0
                     @r0=0:str1=str2
                     @r0>0:str1>str2
                     @r0<0:str1<str2
    b .

str1:
    .ascii "hello\0"
str2:
    .ascii "hallo\0"
.end


