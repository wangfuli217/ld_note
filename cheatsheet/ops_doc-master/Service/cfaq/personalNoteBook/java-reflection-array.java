package playGround.reflection;

import java.lang.reflect.Array;

public class ArrayReflect {

	public static void main(String[] args) {
							
		Object array= Array.newInstance(int.class, 2);//int[2]
		int[] arr = (int[])array;
		
		for(int i = 0; i<arr.length; i++) {
			arr[i] = 10+i;
			System.out.println(arr[i]);
		}
		for(int v:arr) {
			System.out.println(v);
		}

		Object array2 = Array.newInstance(int.class, new int[] {3,3});//int[3][3]
		int[][] arr2 = (int[][])array2;
		for(int i=0; i<arr2.length; i++)
		{
			for(int j = 0; j<arr2[0].length; j++)
			{
				arr2[i][j] = new Random().nextInt(100);
				System.out.println(arr2[i][j]);
			}
		}
		
		/*
		Object array2 = Array.newInstance(int.class, new int[] {3,3});//int[3][3]
		Array.set(array2, 0, new int[] {10,11,12});
		for(int i = 0; i<Array.getLength(array2); i++) {
			Object row = Array.get(array2, i);
			for(int j = 0; j<Array.getLength(row); j++) {
				Array.set(row, j, i*j);
				System.out.print(Array.get(row, j));
			}
		}			
		*/
	}

}

