import java.lang.*;

public class FloatDemo {

   public static void main(String[] args) {

     Float f = new Float("10.07");
   
     // returns the bits that represent the floating-point number
     System.out.println("Value = " + f.floatToIntBits(5.5f));  
   }
}