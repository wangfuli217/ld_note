/**  
 * 2012-2-6  
 * Administrator  
 */ 
/**  
 * @author: 梁焕月   
 * 文件名：TestClass.java   
 * 时间：2012-2-6上午10:01:52    
 */ 
public class TestClass {  
public  static void main(String[] args)  
{  
try {  
//测试类名.class  
Class testTypeClass=TestClassType.class;  
System.out.println("testTypeClass---"+testTypeClass);

//测试Class.forName()  
Class testTypeForName=Class.forName("TestClassType");          
System.out.println("testForName---"+testTypeForName);  
  
//测试Object.getClass()  
TestClassType testGetClass= new TestClassType();  
System.out.println("testGetClass---"+testGetClass.getClass());  
} catch (ClassNotFoundException e) {  
// TODO Auto-generated catch block  
e.printStackTrace();  
}  
}  
}  
 class TestClassType{  
//构造函数  
public TestClassType(){  
System.out.println("----构造函数---");  
}  
//静态的参数初始化  
static{  
System.out.println("---静态的参数初始化---");  
}  
//非静态的参数初始化  
{  
System.out.println("----非静态的参数初始化---");  
}          
}