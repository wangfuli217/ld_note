int main() 
{
	/* unix被编译器内定为一个宏 
	 * 相当于#define unix 1     */
	
	printf("unix=%d\n", unix); /* =1 */	
	
	/* 打印字符串"un"，因为"fun"是个字符数组
	 * "fun"+1相当于字符指针右移，指向"un" */
	printf("%s\n","fun"+1);

	/* "have"是个字符数组，"have"[1]即字符a
	 * 输出97，即第二个字符'a'的ASCII值。*/
	printf("%d\n", "have"[1]);
	printf("%d\n", 'a');

	/* 在C语言中，x[1] = 1[x] */
	printf("%d\n", (1)["have"]);

	/* 97 - 96 = 0x61 - 0x60 = 1 */
	printf("%d\n", (1)["have"] - 0x60);

	/* 所以 "fun"+((1)["have"]-0x60) 相当于"fun"+1，输出"un" */
	printf("%s\n", "fun" + ((1)["have"] - 0x60));

	/* 将其中的1用unix代替 */
	printf("%s\n", (unix)["have"]+"fun"-0x60);

	/* 以上为后半部分 = "un" */

	/* 下面两个都输出"bcde", 因为指针都是从'b'开始 */
	printf("%s\n", "abcde" + 1);
	printf("%s\n", &"abcde"[1]);

	/* &"abcde"[1] == &(1)["abcde"]  输出一样 */
	printf("%s\n", &(1)["abcde"]);

	/* 1用unix代替 */
	printf("%s\n", &unix["abcde"]);

	/* 下面输出"%six" 并换行 */
	printf("%s", &"?%six\n"[1]);

	/* 注意：
	   \012 = 0x0a = \n, 
	   第一个字符 \021 被跳过
	   \0 是空字符  */

	/* 同样输出"%six" 并换行 */
	printf("%s", &"\021%six\012\0"[1]);

	/* 相当于这样 */
	printf("%s", &unix["\021%six\012\0"]);

	/* 把字符串"%six\n"当作格式，输出"ABix" */
	printf(&unix["\021%six\012\0"], "AB");

	/* 相当于这样 */
	printf("%six\n", "AB");

	/* 所以下面的可以输出"unix" */
	printf("%six\n", (unix)["have"]+"fun"-0x60);
	
	/* 至此，问题解决！！！输出"unix" */
	printf(&unix["\021%six\012\0"],(unix)["have"]+"fun"-0x60);

	return 0;
}