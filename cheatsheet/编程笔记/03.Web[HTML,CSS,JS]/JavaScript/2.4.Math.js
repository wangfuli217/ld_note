
Math 数学对象：
   都是数学常数：(可直接用)
   Math.E (自然数)       Math.LN2 (ln2)      Math.LN10 (ln10)          Math.LOG2E (log 2e)
   Math.LOG10E (log e)   Math.PI (圆周率)    Math.SQRT1_2 (根号1/2)    Math.SQRT2 (根号2)
   三角函数：
      Math.sin(x)        计算正弦值； (x在0~2π之间，返回值-1~1)
      Math.cos(x)        计算余弦值； (x在0~2π之间，返回值-1~1)
      Math.tan(x)        计算正切值； (x在0~2π之间，返回正切值)
   反三角函数：
      Math.asin(x)       计算反正弦值；(x在 -1与1之间，返回0~2π)
      Math.acos(x)       计算反余弦值；(x在 -1与1之间，返回0~2π)
      Math.atan(x)       计算反正切值；(x可以为任意值，返回 -π/2 ~π/2)
      Math.atan2(y,x)    计算从X轴到一个点的角度；(y,x分别为点的纵坐标和横坐标，返回-π ~π)
   计算函数：
      Math.sqrt(x)       计算平方根
      Math.pow(x,y)      计算x^y
      Math.exp(x)        计算e的指数 e^x
      Math.log(x)        计算自然对数 (x为大于0的整数)
   数值比较函数：
      Math.abs(x)        计算绝对值
      Math.max(x,y,...)  返回参数中最大的一个
      Math.min(x,y,...)  返回参数中最小的一个
    * Math.random()      返回0~1之间的一个随机数  //若要整数时，如0~99的随机数： n=parseInt(Math.random()*100);
      Math.round(x)      返回舍入为最接近的整数(四舍五入，负数时五舍六入)
    * Math.floor(x)      返回下舍入整数 (结果不大于x；正数时直接舍去小数，负数时 -1.1==-2 )
      Math.ceil(x)       返回上舍入整数 (结果大于等于x)


属性
    E	欧拉常量(2.718281828459045)
    LN2	2的自然对数(0.6931471805599453)
    LN10	10的自然对数(2.3025850994046)
    LOG2E	以2为底数e的对数(1.4426950408889633)
    LOG10E	以10为底数e的对数(0.4342944819032518)
    PI	圆周率常数(3.141592653589793)
    SQRT1-2	0.5的平方根(0.7071067811865476)
    SQRT2	2的平方根(1.14142135623730951)

方法
    abs(x)	返回x的绝对值
    acos(x)	返回x弧度的反余弦
    asin(x)	返回x弧度的反正弦
    atan(x)	返回x弧度的正正切
    atan2(x,y)	返回坐标(x,y)对应的极坐标角度
    ceil(x)	返回大于或等于x的最小整数
    cos(x)	返回x的余弦
    exp(x)	返回e的x乘方
    floor(x)	返回 小于或等于x的最大整数
    log(x)	返回x的自然对数
    max(x,y)	返回x和y中的最大数
    min(x,y)	返回x和y中的最小数
    pow(x,y)	返回x对y的次方
    random()	返回0和1之间的随机数
    round(x)	返回最接近x的整数,即四舍五入函数
    sin(x)	返回x的正弦值
    sqrt(x)	返回x的平方根
    tan(x)	返回x的正切值


/************* Math 小技巧摘录 ************************/
1.产生1到N的随机数
    var random = Math.floor(Math.random() * N + 1);

    // 产生1到10之间的随机数
    var random = Math.floor(Math.random() * 10 + 1);

    // 产生1到100之间的随机数
    var random = Math.floor(Math.random() * 100 + 1);


2.产生0到99的随机数：
    n=parseInt(Math.random()*100);


3.在特定范围里获得一个随机数
　　下面这段代码非常通用，当你需要生成一个假的数据用来测试时，比如在最低工资和最高之前获取一个随机值。
    var x = Math.floor(Math.random() * (max - min + 1)) + min;


4.生成一组随机的字母数字字符
    function generateRandomAlphaNum(len) {
        var rdmString = "";
        for( ; rdmString.length < len; rdmString += Math.random().toString(36).substr(2));
        return  rdmString.substr(0, len);
    }


5.验证一个给定参数是否为数字
    function isNumber(n){
        return !isNaN(parseFloat(n)) && isFinite(n);
    }


6.舍入小数位数
    var num =2.456242342;
    num = num.toFixed(2);  // "2.46"


7.浮点数问题
    0.1 + 0.2 === 0.3 // is false
    9007199254740992 + 1 // is equal to 9007199254740992
    9007199254740992 + 2 // is equal to 9007199254740994

    // 0.1+0.2等于0.30000000000000004，为什么会发生这种情况？
    根据IEEE754标准，你需要知道的是所有JavaScript数字在64位二进制内的都表示浮点数。
    开发者可以使用toFixed()和toPrecision()方法来解决这个问题。

