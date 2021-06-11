

获取项目的根目录:
    System.out.println(System.getProperty("user.dir"));

地址引用：
    Integer i = 1;
    Integer j = 1;
    System.out.println(i == j); //结果是 true

    // 而下面写法结果是 false：
    Integer i = new Integer(1);
    Integer j = new Integer(1);
    System.out.println(i == j);

    原理：
    Integer i = 1;Integer j = 1; 意思是 i指向常量1的空间，两个地址一样所以对象一样
    Integer i = new Integer(1); 意思是开辟一个新空间值为1  两个对象当然就不会一样

