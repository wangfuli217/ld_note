
Function对象
  属性
    arguments[]	一个参数数组,数组元素时传递给函数的参数
    caller	对调用当前函数的Function对象的引用,如果当前函数由顶层代码调用,这个属性值为null
    constructor	返回创建对象的函数
    length	表示在声明函数时指定的命名参数的个数
    prototype	返回对象类型原型的引用
  方法
    apply(thisobj,args)	将该函数作为指定对象的方法调用。thisobj为调用function的对象,在函数主体中,thisobjshirt关键字this的值；args为一个数组,该数组的元素是要传递给函数的参数值
    call(thisobj,arg1...)	将该函数作为指定对象的方法调用。Thisobj为调用function的对象,在函数主体中,thisobjshirt关键字this的值；args1…为传递给函数的任意多个参数
    toString()	返回函数的字符串表示


