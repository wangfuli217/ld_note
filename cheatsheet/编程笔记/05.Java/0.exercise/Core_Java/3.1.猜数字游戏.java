

咏联科技面试题目：猜数字游戏
1．自动产生四个0~9的数字作为随机数，这个四位数相互之间不能相同。
2．使用者输入猜的四个数字(这四个数字之间也不能相同, 如果有相同的则提示使用者,并让它重新输入)。
3．当使用者输入一组四位数字时，程序把这组数字跟自动产生的那组做比对，当比对结果为一个数字的值相同且位置一样，计算器印出1A；如果四个数字中有数字的值一样但位置不同，计算器印出1B，例如计算器产生的数字为 2345

	当使用者输入　　　　１３７８
	计算器印出　　　　　１Ａ

	当使用者输入　　　　１０７８
	计算器印出　　　　　０Ａ０Ｂ

	当使用者输入　　　　２３７８
	计算器印出　　　　　２Ａ

	当使用者输入　　　　１０３８
	计算器印出　　　　　１Ｂ

	当使用者输入　　　　２０３８
	计算器印出　　　　　１Ａ１Ｂ

	当使用者输入　　　　５４３２
	计算器印出　　　　　４Ｂ

4. 最多可以猜十次，超过十次则游戏结束，使用者可以选择再玩一次或离开（再玩一次的随机数必须重新产生）
5．游戏中使用者可随时查询历史
6．本题程序设计，考试的目的是要看各位对于程序中错误处理及使用者接口的能力，而且不会出现任何错误信息，对于错误的输入需做错误处理并做提示。


import java.util.Random;
import java.util.Scanner;
public class Guess {
	public static void main(String[] args) {

		//产生随机数
		int[] guess = MakeGuessNumber();
		System.out.print("系统产生的随机数为：");
		for(int i=0; i<4; i++){
			System.out.print(guess[i]);
		}System.out.println();

		int[] putIn ;//定义用户输入
		String right = ""; //临时保存比较的结果
		String[] history = new String[]{"","","","","","","","","",""};

		for(int i=0; i<10; i++){
			putIn = PutIn(history); //获取用户输入
			right = CompareNumber(guess, putIn); //比较输入结果
			history[i] = RemarkHistory(putIn, right); //作历史记录，以便随时查看
			if(right.compareTo("4A")==0){
				System.out.println("恭喜您，猜中了！！！");
				PrintMenu();
				menu(history);
			}
		}

		System.out.println("您已经猜了10次，本次游戏结束");
		PrintMenu();
		menu(history);

	}

	//自动产生四个0~9的数字作为随机数，这个四位数相互之间不能相同。
	public static int[] MakeGuessNumber(){
		Random r = new Random();
		int[] guess = new int[4];
		for(int i=0; i<4; i++){
			guess[i] = r.nextInt(10);
			for(int j=i-1; j>=0; j--){
				if(guess[i]==guess[j]){i--;break;}
			}
		}
		return guess;
	}

	//使用者输入猜的四个数字(这四个数字之间也不能相同, 如果有相同的则提示使用者,并让它重新输入)
	public static int[] PutIn(String[] history){
		int[] number = new int[4];
		int putIn = 0;
		Scanner sc = new Scanner(System.in);

		System.out.println("请输入您猜想的4位数字");
		PrintMenu();

		out1: while(true){

			//如果输入英文、符号、小数等则提示并要求重新输入
			try {
				putIn = sc.nextInt();
			} catch (Exception e) {
				String str = sc.next();
				//输入y，重新开始游戏
				if("Y".compareTo(str)==0 || "y".compareTo(str)==0) {main(null);}
				//输入n，退出游戏
				if("N".compareTo(str)==0 || "n".compareTo(str)==0) {System.exit(0);}
				//输入h，查看游戏历史记录
				if("H".compareTo(str)==0 || "h".compareTo(str)==0) {PrintHistory(history);}
				System.out.println("请输入正整数。");
				continue;
			}

			//如果输入的不是4位数，提示并要求重新输入(注意:有可能0开头的)
			if(putIn>9999 || putIn<100){
				System.out.println("请输入一个4位数");
				continue;
			}

			//把输入的一个4位数字变成数组
			number[0] = putIn/1000;
			number[1] = putIn%1000/100;
			number[2] = putIn%100/10;
			number[3] = putIn%10;

			//如果有相同的数字，提示并要求重新输入
			for(int i=0; i<4; i++){
				for(int j=i-1; j>=0; j--){
					if(number[i]==number[j]){
						System.out.println("请输入4位不相同的数字");
						continue out1;
					}
				}
			}

			//输入没错时，退出此死循环，继续其它操作
			break;
		}

		return number;
	}

	//比较输入的与系统产生的，返回结果: xA yB
	public static String CompareNumber(int[] guess, int[] putIn){
		int rightA = 0; //比较结果有多少个"A"
		int rightB = 0; //比较结果有多少个"B"
		String right = ""; //以字符串形式保存的比较结果

		//计算出多少个"A"
		for(int i=0; i<4; i++){
			if(guess[i]==putIn[i]) rightA++;
		}

		//计算出多少个"B"
		for(int i=0; i<4; i++){
			for(int j=0; j<4; j++){
				if(guess[j]==putIn[i]) rightB++;
			}
		}
		rightB -= rightA;//前面的循环会连"A"的也算上，所以需减去

		if(rightA != 0) right += rightA + "A";
		if(rightB != 0) right += rightB + "B";
		if(rightA==0 && rightB==0) right = "0A0B";
		System.out.println(right);
		return right;
	}

	public static void PrintMenu(){
		System.out.println("输入\"Y\"重新开始游戏；输入\"N\"结束游戏；输入\"H\"查看历史记录");
	}

	public static void menu(String[] history){
		Scanner sc = new Scanner(System.in);
		String str = sc.next();
		if("Y".compareTo(str)==0 || "y".compareTo(str)==0) {main(null);}
		if("N".compareTo(str)==0 || "n".compareTo(str)==0) {System.exit(0);}
		if("H".compareTo(str)==0 || "h".compareTo(str)==0) {PrintHistory(history);}
	}

	public static String RemarkHistory(int[] putIn, String right){
		String str = "";
		for(int i=0; i<4; i++){
			str += putIn[i];
		}
		str += "   " + right;
		return str;
	}

	public static void PrintHistory(String[] history){
		for(int i=0; i<history.length; i++){
			if("".compareTo(history[0])==0) {System.out.println("还没有输入内容"); continue;}
			if("".compareTo(history[i])==0) continue;
			System.out.println(history[i]);
		}
	}
}

