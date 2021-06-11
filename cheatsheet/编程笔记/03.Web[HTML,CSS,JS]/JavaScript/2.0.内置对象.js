
JS的内置对象

    11种内置对象：Array, Boolean, Date, Math, Number , String, Error, Function, Global , Object, RegExp

    在JavaScript中除了 null 和 undefined 以外其它的数据类型都被定义成了对象
    可以用创建对象的方法定义变量；  String、Math、Array、Date、RegExp是JavaScript中常用的对象

    内置对象的分类：
       数据对象: Number数据对象； String字符串对象； Boolean布尔值对象
       组合对象: Array数组对象；  Math数学对象； Date日期对象
       高级对象: Object自定义对象；Error错误对象；Function函数对象； RegExp正则表达式对象；Global全局对象

    自动创建对象:调用字符串的对象属性或方法时自动创建对象，用完就丢弃。 如： var str1="hello world";
    手工创建对象:采用new创建字符串对象str1，全局有效。 如：var str1= new String("hello word");

