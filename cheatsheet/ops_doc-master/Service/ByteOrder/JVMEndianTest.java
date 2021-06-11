/*************************************************************************
	> File Name: JVMEndianTest.java
	> Author: 
	> Mail: 
	> Created Time: 2018年10月08日 星期一 16时15分54秒
 ************************************************************************/


// package net.aty.util;
 
 
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;
 
public class JVMEndianTest {
	public static void main(String[] args) {
		
		int x = 0x01020304;
		
		ByteBuffer bb = ByteBuffer.wrap(new byte[4]);
		bb.asIntBuffer().put(x);
		String ss_before = Arrays.toString(bb.array());
		
		System.out.println("默认字节序 " +  bb.order().toString() +  ","  +  " 内存数据 " +  ss_before);
		
		bb.order(ByteOrder.LITTLE_ENDIAN);
		bb.asIntBuffer().put(x);
		String ss_after = Arrays.toString(bb.array());
		
		System.out.println("修改字节序 " + bb.order().toString() +  ","  +  " 内存数据 " +  ss_after);
	}
}

/*
默认字节序 BIG_ENDIAN, 内存数据 [1, 2, 3, 4]
修改字节序 LITTLE_ENDIAN, 内存数据 [4, 3, 2, 1]
 
javac JVMEndianTest.java
java  JVMEndianTest
*/
