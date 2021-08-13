
javascript有很多怪异之处,这里抄录一下
来源: http://wtfjs.com/

// 打印: 10
alert(++[[]][+[]]+[+[]]);

// 打印: "fail"
alert((![]+[])[+[]]+(![]+[])[+!+[]]+([![]]+[][[]])[+!+[]+[+[]]]+(![]+[])[!+[]+!+[]]);



Math.max() behaviour
    Math.max() has an interesting behaviour, handling different JavaScript data types in different ways.
        Math.max(3, 0);           // 3
        Math.max(3, {});          // NaN
        Math.max(3, []);          // 3
        Math.max(3, true);        // 3
        Math.max(3, 'foo');       // NaN
        Math.max(-1, null);       // 0
        Math.max(-1, undefined);  // NaN


    Now, let's focus on Booleans:
        Math.max(1, true);     // 1
        Math.max(0, true);     // 1
        Math.max(1, false);    // 1
        Math.max(-1, true);    // 1
        Math.max(-1, false);   // 0


    And now, on Arrays:
        Math.max(-1, []);      // 0
        Math.max(-1, [1]);     // 1
        Math.max(-1, [1, 4]);  // NaN

    So next time, watch out for what you pass into Math.max().
    Math.max() typecasts all values to Numbers (Number(x)), e.g.:
        Math.max(false, -1); // 0
        Math.max(5, "10");   // 10


Math.max() 理解：
    Math.max() 会将它所有的参数先转变成数值，然后进行比较。
    下面，介绍各种值转换成数值时的情况,必须先理解他们怎么变数值才会理解 Math.max() 的处理方式:

    字符串转变成数值时,如果是数值则会直接变成数值，含有字母符号等则会是NaN。小数点、e也会认为是数值。见下例:
        Number("10");      // 10
        Number("10.123");  // 10.123
        Number("10e123");  // 1e+124
        Number("10j123");  // NaN
        Number("foo");     // NaN

    boolean 类型 转变成数值时, true == 1, false == 0:
        Number(true);      // 1
        Number(false);     // 0
        alert(true==1);    // true
        alert(false==0);   // true

    null, undefined, NaN 转变成数值时:
        Number(null);      // 0
        Number(undefined); // NaN
        Number(NaN);       // NaN

    数值比较时, 含有 NaN 都会返回 NaN:
        Math.max(3, NaN);  // NaN
        Math.min(3, NaN);  // NaN

    数组 转变成数值时: 不含有值,则等同于0; 含有一个值,则取里面的那个值; 含有两个或以上,则认为是类,返回 NaN
    注意,数值末尾的逗号会被忽略(下面数值会详细解释)
        Number([]);           // 0
        Number([2]);          // 2
        Number(['5']);        // 5
        Number([0,2]);        // NaN
        Number([null]);       // 0
        Number([undefined]);  // 0    注意这个,比较特殊,其实还是认为里面有一个值的
        Number([NaN]);        // NaN
        Number([,]);          // 0
        Number([,,]);         // NaN
        Number([6,]);         // 6

    类 转变成数值时,为 NaN
    注意: {} 是空的类(json写法, 相当于 new Object())
        Number({});             // NaN
        Number({a:1});          // NaN
        Number(function(){});   // NaN
        Number(new Object());   // NaN


array ruse
数组计算
    [,,,].join() // ==> ",,"
    [,,,undefined].join() // ==> ',,,'

    Turns out that the trailing comma is removed (trailing commas are allowed in javascript, but not JSON). Once removed, there are only three "elements" in the array, and both are undefined. When join is called, by default it uses a comma, yielding ",,". I think this is what happens

    JSON has nothing to do with this issue. Although trailing comma is really allowed by Javascript and that's the case.
    So [1,2,3,] equals to [1,2,3]. So literally [,,,] is something like [undefined, undefined, undefined,]. You can add undefined to the end explicitly to get 4 elements array:

    数组末尾的逗号会被忽略(作者猜测是这样)
    所以 [1,2,3,] 相当于 [1,2,3],  [,,,] 相当于 [undefined, undefined, undefined,]

        [].length;            // 0
        [undefined].length;   // 1
        [,].length;           // 1
        [6,].length;          // 1
        [,,].length;          // 2

        [,].join()            // ","
        [undefined,].join()          // ","
        [undefined,undefined].join()          // ","



array constructor
数组构造函数
    Array(20).map(function(elem) { return 'a'; }); // Array of undefined × 20

    原因:  Array(20);  // ==> [undefined × 20]


negative indexes
负数下标
    Negative numbers mean different things to different functions on the Array prototype.

    var nums = [1, 2, 3];
    nums.splice(nums.indexOf('wtf'), 1);
    nums; // [1, 2]

    原因: nums.indexOf('wtf');  // ==> -1
          nums.splice(-1, 1);  // 截取,只留前面两位




isfinite null is true
    isFinite function of JavaScript tests whether a number is finite.
    isFinite() 函数用于检查其参数是否是有限(非无穷大)。
    这也会先把参数转成数值,然后再检查是否有限。

    isFinite(42); // true
    isFinite(1/0); // false
    isFinite(0/0); // NaN is not finite -> false  (注:我在火狐上测试是false,可能新版有修正)
    isFinite('42'); // true
    isFinite('hi'); // false

    原因:   1/0  // ==> Infinity
            0/0  // ==> NaN

  These are normal results.
    isFinite(); // false
    isFinite(null); // true
    isFinite(undefined); // false
    isFinite(NaN); // false

  Undefined values are not finite. These are normal results too.
    isFinite(null); // true

  Wait, what? Is null a number? It is converted into 0? Why?
  Since null != 0 and null == undefined, (even thought null !== undefined) I expected null will behave something like undefined!
