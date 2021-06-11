
import java.lang.*;

public class IntegerDemo {

   public static void main(String[] args) {

     int i = 170;
     System.out.println("Number = " + i);
    
     /* returns the string representation of the unsigned integer value
     represented by the argument in hexadecimal (base 16) */
     System.out.println("Hex = " + Integer.toHexString(i));
     }
}     