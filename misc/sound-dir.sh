
sound_dir_move()
{
1、早期的2.4内核所有的音频驱动和其他驱动一样都是位于drivers目录下的：drivers/sound
2、到了2.5开发版内核，所有的音频驱动包括音频框架代码由drivers/sound移到了sound目录下：
   （1）2.6内核之前的git记录查找：http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=summary
   （2）音频驱动代码被移动的git提交：
从这个提交信息可以看出，是在Linux内核正式引入ALSA音频构架的时候，所有的代码都被移动到了drivers/sound下。 
也就是在同一天，音频子系统的维护由原来的Alan Cox转为Jaroslav Kysela：
}


