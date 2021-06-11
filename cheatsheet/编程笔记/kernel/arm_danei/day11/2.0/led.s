.equ GPC1CON, 0xE0200080
.equ GPC1DATA, 0xE0200084
.equ GPC1PUD, 0xE0200088

.text 
.arm
.global main
main:
    /*1.配置GPC1_3为输出口*/
    ldr r2, =GPC1CON
    ldr r3, [r2]

    /*1.1修改r3 &=~(0xf << 12)*/
    mov r0, #0x0f
    bic r3,r3,r0, lsl #4*3

    /*1.2|= 1 << 12*/
    mov r1, #0x01
    orr r3,r3,r1, lsl #4*3
    
    /*1.3把r3写回到GPC1CON*/
    str r3,[r2]

    /*2.禁止上下拉电阻功能*/
    ldr r2,=GPC1PUD
    ldr r3,[r2]
    mov r0,#0x03
    bic r3,r3,r0, lsl #2*3
    str r3,[r2]

    /*3.开关灯*/
    ldr r2, =GPC1DATA
    mov r0, #1

loop:
    /*开灯*/
    ldr r3,[r2] 
    orr r3,r3,r0, lsl #1*3
    str r3,[r2]

    bl delay

    /*关灯*/
    bic r3,r3,r0, lsl #1*3
    str r3,[r2]

    bl delay /*ARM核自动保存返回地址到lr*/

    b loop

delay:
    mov r4, #0xf00000
delay_loop:
    subs r4,r4,#1
    bne delay_loop
    mov pc,lr /*软件实现返回*/
.end








