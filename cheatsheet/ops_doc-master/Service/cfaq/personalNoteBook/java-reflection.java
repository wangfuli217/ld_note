
package playGround.reflection;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class DemoReflect {

	public static void main(String[] args) throws Exception {

		

		
			Class<?> employClass = Class.forName("playGround.reflection.Employee");
			// System.out.println(employClass.getName());
			// System.out.println(employClass.getSuperclass().getName());
			Constructor<?> employConstrut = employClass.getConstructor(new Class[] { String.class, int.class });
			Employee employObj = (Employee) employConstrut.newInstance(new Object[] { "Hinton", 30 });
			System.out.println(employObj);

			Method method = employClass.getMethod("setAge", new Class[] { int.class });
			method.invoke(employObj, 18);
			System.out.println(employObj);

			/*Field field = employClass.getDeclaredField("age");
			field.setAccessible(true);
			field.set(employObj, 60);
			System.out.println(employObj);*/
			
			Method method2 = employClass.getDeclaredMethod("work", new Class[] {});
			method2.setAccessible(true);//due to work() is private
			method2.invoke(employObj, new Object[] {});

	

			
		

	}

}

class CloneUtil{	
	public static Object clone(Object src) throws  Exception {
		Class<?> classObj = src.getClass();
		Object dstObj = classObj.newInstance();//constructor without parameter		
		Field[] fields = classObj.getDeclaredFields(); //get public+private field						
		for(Field field:fields) {
			field.setAccessible(true);//so able to visit private member
			Object value = field.get(src);
			field.set(dstObj, value);			
		}
		return dstObj;
		
	}
}

class Employee {
	private String name;
	private int age;

	public Employee(String name, int age) {
		super();
		this.name = name;
		this.age = age;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "Employee [name=" + name + ", age=" + age + "]";
	}

	private void work() {
		System.out.println("i'm working");
	}

}
