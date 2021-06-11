import java.lang.reflect.*;
import java.awt.*;
class SampleGet {
    
    public static void main(String[] args) throws Exception {
        Rectangle r = new Rectangle(100, 325);
        printHeight(r);
        printWidth(r);
    }
    static void printHeight(Rectangle r)throws Exception {
        //Field属性名
        Field heightField;
        //Integer属性值
        Integer heightValue;
        //创建一个Class对象
        Class c = r.getClass();
        //.通过getField 创建一个Field对象
        heightField = c.getField("height");
        //调用Field.getXXX(Object)方法(XXX是Int,Float等，如果是对象就省略；Object是指实例).
        heightValue = (Integer) heightField.get(r);
        System.out.println("Height: " + heightValue.toString());
    }
    static void printWidth(Rectangle r) throws Exception{
        Field widthField;
        Integer widthValue;
        Class c = r.getClass();

        widthField = c.getField("width");
        widthValue = (Integer) widthField.get(r);
        System.out.println("Height: " + widthValue.toString());

    }
}      