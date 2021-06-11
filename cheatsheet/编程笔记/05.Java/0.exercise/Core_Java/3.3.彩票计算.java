

足球彩票程序：
比赛有"输"、"平"、"赢"三种结果，比赛 N 场
打印出比赛的所有结果

// 递归解法
public class Test{

    public static void main(String[] args){
        int N = 3; // 比赛 N 场，可改变
        showAll(N);
    }

	public static void showAll(int N) {
		String[] element = {"输", "平", "赢"}; // 比赛结果
		// 预存每种结果，只有一场比赛时，这样就可以了
		ArrayList<String> a1 = new ArrayList<String>();
		for (String e : element){
			a1.add(e);
		}
		// 两场以上的比赛时
		for (int i = 1; i < N; i++) {
			ArrayList<String> a2 = new ArrayList<String>();
			for (int j = 0; j < a1.size(); j++) {
				for (String e : element){
					a2.add(a1.get(j) + e);
				}
			}
			a1 = a2;
		}
		// 遍历所有的结果
		for(String str : a1){
			System.out.println(str);
		}
	}
}



