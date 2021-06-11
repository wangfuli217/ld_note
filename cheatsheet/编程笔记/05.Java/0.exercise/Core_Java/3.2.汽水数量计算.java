

视信世纪(vuclip)面试题：汽水数量计算
某公司搞促销活动，每买满5瓶汽水赠送一瓶
请写一个函数，传入购买的汽水数量，返回应得的汽水数量。(别忘了，赠送数量也是每满5瓶再送一瓶的)
如购买25瓶，则可得到31瓶。

// 我的做法如下：循环解法
public class Test{

    public static void main(String[] args){
        System.out.println("购买-1瓶,应得" + counter(-1) + "瓶"); //0
        System.out.println("购买0瓶,应得" + counter(0) + "瓶"); //0
        System.out.println("购买4瓶,应得" + counter(4) + "瓶"); //4
        System.out.println("购买5瓶,应得" + counter(5) + "瓶"); //5+1=6
        System.out.println("购买6瓶,应得" + counter(6) + "瓶"); //6+1=7
        System.out.println("购买11瓶,应得" + counter(11) + "瓶"); //11+2=13
        System.out.println("购买25瓶,应得" + counter(25) + "瓶"); //25+5+1=31
        System.out.println("购买26瓶,应得" + counter(26) + "瓶"); //26+5+1=32
        System.out.println("购买125瓶,应得" + counter(125) + "瓶"); //125+25+5+1=156
        System.out.println("购买126瓶,应得" + counter(126) + "瓶"); //126+25+5+1=157
    }

    /**
     * 获取促销活动的汽水实际应得数量
     * @param buyNumber 购买数量
     * @return 应得数量
     */
	public static int counter(int buyNumber) {
        if (buyNumber <= 0) {
            return 0;
        }
        int returnNumber = buyNumber;
        while (buyNumber >= 5) {
            buyNumber = buyNumber / 5;
            returnNumber += buyNumber;
        }
        return returnNumber;
	}
}


