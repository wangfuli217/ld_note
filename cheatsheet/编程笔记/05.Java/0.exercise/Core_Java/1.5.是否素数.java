
12. 判断随机整数是否是素数
产生100个0-999之间的随机整数，然后判断这100个随机整数哪些是素数，哪些不是？

public class PrimeTest{
    public static void main(String args[]){
        for(int i=0;i<100;i++){
            int num = (int)(Math.random()*1000);
            PrimeTest t = new PrimeTest();
            if(t.isPrime(num)){
                System.out.println(num+" 是素数!");
            }else{
                System.out.println(num+" 不是素数!");
            }
            System.out.println();
        }
    }
    public boolean isPrime(int num){
        for(int i=2;i<=num/2;i++){
            if(num%i==0){
                System.out.println(num+"能被"+i+"整除!");
                return false;
            }
        }
        return true;
    }
}



