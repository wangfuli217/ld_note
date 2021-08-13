
Array 数组对象：
    1) 创建数组：
        var a = new Array();  a[0] = "元素1"; a[1] = "元素2";
        var a = new Array(){"元素1", "元素2"};
        var a = new Array("元素1","元素2");    //一维数组，效果同上
        var a = new Array();  a[0] = new Array();   //二维数组
      简略的数组创建方法：
        var a = ['元素1', '元素2'];  // 效果等同于: var a = new Array("元素1","元素2");
    2) 删除数组：  delete 数组名;
    3) 数组操作：
         arr.length;             //获取数组元素的个数；返回大于或等于0的整数
        连接数组： (原数组不变)
         arr.join(bystr);        //把数组的各元素由bystr连接起来作为字符串；与字符串的split功能刚好相反
         arr.toString();         //返回由逗号(,)连接数组元素组成的字符串
           document.write(v.toString());document.write(v);  //这两句效果一样
         arr2 = arr.concat(元素, ...);  //把元素添加到数组尾端后，返回另一数组；在参数里填入另一数组，返回合并数组
        数组排序： (返回排序后的数组；改变原数组)
         arr.reverse();          //按原顺序倒着排序
         arr.sort();             //按字典顺序排序
        获取子数组： (返回被删/被截取的元素数组)
         arr.slice(start,end);   //从start下标开始，截取到end；返回被截取的元素数组；原数组变成去掉截取部分的
           //start和end可用负数表倒数(-1代表最后一个元素)；end<start时不截取；忽略end，截取start后的所有元素
         arr.splice(start,n,value, ...);  //从start下标开始删除n个，再插入value(可理解为替换)；改变原数组
       //start为负数时表倒数；n<1表不删除；可忽略value(不插入)；可忽略n，表删除后面所有；返回被删元素数组
    4) 栈：(数组的基础； 改变原数组)
     arr.pop(); //删最后的一个元素；返回删除的元素
     arr.push(元素, ...);       //添加元素到最后位置；返回数组长度; 等价于: arr[length] = newValue;
     arr.unshift(元素, ...);    //添加元素到最前位置(多个参数，则按参数顺序同时插入)；返回数组长度
     arr.shift();  //删最前的一个元素；返回被删除的元素
    5) toString 和 valueOf
     把每一项都调用 toString 方法，然后用半角逗号(,)连接每一项。
     如: var arr = [1,2,3,4,5]; alert(arr); // 1,2,3,4,5
     toLocaleString 方法在这里不做详细说明了，他的效果与 toString 方法类似，只是每项调用 toLocateString 方法。


创建 Array 对象的语法:
    new Array();
    new Array(size);
    new Array(element0, element1, ..., elementn);


属性
    constructor	引用数组对象的构造函数
    length	返回数组中的元素个数
    prototype	用于在定义数组时添加新的属性和方法,prototype是数组对象的静态属性

方法
    concat()	返回一个新数组,这个新数组是由两个或更多数组组合而成的
    join()	将数组中的所有元素都转换成字符串,然后连接起来,各元素由指定的分隔符分隔
    pop()	删除数组中最后一个元素
    push(value,....)	向数组的尾部添加元素
    reverse()	在原数组上颠倒数组中元素的顺序
    shift()	删除数组中第一个元素
    slice(start,end)	从现有数组中提取指定个数的数据元素,组成一个新的数组。所提取元素的下标从start开始,到end结束,但不包括end
    sort()	将数组元素排序
     	从数组中插入和删除元素
    toLocaleString	返回数组的本地化字符串表示
    toString()	返回数组的字符串表示
    unshift(value,.....)	在数组的头部插入数组元素

splice()方法说明
    array.splice(start,deleteCount,value,....)
    start	用于指定开始插入或删除数组元素的下标
    deleteCount	用于指定包括start所指元素在内要删除元素的个数
    value,....	用于指定要插入到插入到数组中的0个或多个值,从start指定的下标处开始插入


/************* Array 小技巧摘录 ************************/

1.数组追加/数组合并
    var array1 = [12 , "foo" , {name "Joe"} , -2458];
    var array2 = ["Doe" , 555 , 100];
    Array.prototype.push.apply(array1, array2);
    /* array1 will be equal to  [12 , "foo" , {name "Joe"} , -2458 , "Doe" , 555 , 100] */


2.打乱数字数组
    var numbers = [5, 458 , 120 , -215 , 228 , 400 , 122205, -85411];
    numbers = numbers.sort(function(){ return Math.random() - 0.5});
    /* the array numbers will be equal for example to [120, 5, 228, -215, 400, 458, -85411, 122205]  */


3.将参数对象转换为数组
    function test1(){
        var argArray = Array.prototype.slice.call(arguments);
        //....
    }


4.验证一个给定的参数为数组
    function isArray(obj){
        // 注意，如果toString()方法被重写了，你将不会得到预期结果。
        return Object.prototype.toString.call(obj) === '[object Array]';
    }


5.不要用delete从数组中删除项目
    开发者可以使用 split 来代替使用 delete 来删除数组项。
    与其删除数组中未定义项目，还不如使用 delete 来替代。
    var items = [12, 548 ,'a' , 2 , 5478 , 'foo' , 8852, , 'Doe' ,2154 , 119 ];
    items.length; // return 11
    delete items[3]; // return true
    items.length; // return 11
    /* items will be equal to [12, 548, "a", undefined × 1, 5478, "foo", 8852, undefined × 1, "Doe", 2154,       119]   */



/************* 给 Array 额外添加函数 ************************/

/**
 * 清空数组
 * @return {Array} 返回本数组(即清空后的情况,可以不接收返回值,原数组已经被清空)
 *
 * @example
 *  var arr = [1, 2, 3];
 *  arr.clear();
 *  alert(arr.length); // 提示为0
 *  alert(arr[0]); // 提示为 undefined
 */
Array.prototype.clear = function() {
    this.length = 0;
    return this;
};

// opera浏览器 没有 数组的 concat 函数,兼容它
[].concat || (Array.prototype.concat = function(){
    var array = [];
    for (var i = 0, length = this.length; i < length; i++) array.push(this[i]);
    for (var i = 0, length = arguments.length; i < length; i++) {
        if(arguments[i].constructor == Array) {
            for(var j = 0, arrayLength = arguments[i].length; j < arrayLength; j++) {
                array.push(arguments[i][j]);
            }
        } else {
            array.push(arguments[i]);
        }
    }
    return array;
});

/**
 * 查找数组里的某个值的下标(w3c标准的浏览器已经有此函数了)
 * @param  {任意类型} value 要查找的值(需完全匹配)
 * @param  {Number} startNum 查找的起始下标(默认为0)
 * @return {Number} 查找到的值的下标,有多个这样的值时返回第一个查找到的下标,找不到则返回 -1
 *
 * @example
 *  var arr = ['a', 'b', 'c'];
 *  arr.indexOf('c'); // 返回 2
 */
[].indexOf || (Array.prototype.indexOf = function(value, startNum){
	startNum = startNum || 0;
	for (var i = startNum, length = this.length; i < length; i++) {
		if (this[i] === value) return i;
    }
	return -1;
});

/**
 * 查找数组里的某个值的下标(从后面找起,w3c标准的浏览器已经有此函数了)
 * @param  {任意类型} value 要查找的值(需完全匹配)
 * @return {Number} 查找到的值的下标,有多个这样的值时返回最后一个查找到的下标,找不到则返回 -1
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  arr.lastIndexOf('c'); // 返回 4
 */
[].lastIndexOf || (Array.prototype.lastIndexOf = function(value, startNum) {
	startNum = startNum || this.length;
    for (var i = startNum - 1; i > 0; i--) {
        if (this[i] === value) return i;
    }
    return -1;
});

/**
 * 判断数组里是否包含此值
 * @param  {任意类型} 要查找的值, 可以有多个
 * @return {Boolean} 只有一个参数时：包含有则返回 true,没有则返回 false；有多个参数时,要求每一个参数都包含才返回 true,否则返回 false
 *  注：引用对象的判断,只是简单判断引用地址是否相等,不判断里面的值
 *
 * @example
 *  var arr = ['a', 'b', 'c'];
 *  arr.contains('c'); // 返回 true
 *  arr.contains('d'); // 返回 false
 *  arr.contains('c', 'a'); // 返回 true
 *  arr.contains('a', 'd'); // 返回 false
 */
Array.prototype.contains = function() {
    for (var i=0, len = arguments.length; i < len; i++) {
        if (this.indexOf(arguments[i]) == -1) return false;
    }
    return true;
};

/**
 * 复制数组(浅拷贝)
 * @return {Array} 返回复制后的数组
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  var arr2 = arr.clone(); // 返回的是另一个数组,对 arr2 的操作不再影响 arr
 */
Array.prototype.clone = function() {
    return this.slice(0);
};

/**
 * 删除数组里的某些值(只删除第一个找到的值)
 * @param  {任意类型} 要删除的数组里的对象,可以多个
 * @return {Array} 返回数组本身,以便使用连缀
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  arr.remove('c'); // 此时的数组删除了第一个'c', 为: ['a', 'b', 'd', 'c']
 *  arr.remove('a', 'd'); // 还可以同时删除多个值, 此时为: ['b', 'c']
 *  arr.remove('e'); // 传入数组里面没有的值,不对数组产生影响,也不会出现异常, 此时为: ['b', 'c']
 */
Array.prototype.remove = function() {
    for (var i = 0, l = arguments.length; i < l; i++) {
        var value = arguments[i];
        var index = this.indexOf(value);
        if (index > -1) this.splice(index, 1);
    }
    return this;
};

/**
 * 删除数组里的某些值(删除所有找到的值)
 * @param  {任意类型} 要删除的数组里的对象,可以多个
 * @return {Array} 返回数组本身,以便使用连缀
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c'];
 *  arr.removeAll('c'); // 此时的数组删除了所有的'c', 为: ['a', 'b', 'd']
 *  arr.removeAll('a', 'd'); // 还可以同时删除多个值, 此时为: ['b']
 *  arr.removeAll('e'); // 传入数组里面没有的值,不对数组产生影响,也不会出现异常, 此时为: ['b']
 */
Array.prototype.removeAll = function() {
    var index;
    for (var i = 0, l = arguments.length; i < l; i++) {
        var value = arguments[i];
        // 赋值给 index 且判断是否大于 -1, 避免获取两次 index 以提高效率
        while ((index = this.indexOf(value)) > -1) {
            this.splice(index, 1);
        }
    }
    return this;
};


///////////////////// 工具类里去掉的 ///////////////////////////

/**
 * 返回没有重复值的新数组,原数组不改变
 * @return {Array} 返回过滤重复值后的新数组
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c', null];
 *  var arr2 = arr.unique(); // arr2 为: ['a', 'b', 'd', 'c', null]
 */
Array.prototype.unique = function() {
    var result = [];
    for (var i=0,l=this.length; i<l; i++) {
        for (var j=i+1; j<l; j++) {
            if (this[i] === this[j]) j = ++i;
        }
        result.push(this[i]);
    }
    return result;
};
// 上面写法是两重遍历，大数据量时消耗很大，下面优化:
Array.prototype.unique = function() {
    var temp = {};
    for (var i = 0, l = this.length; i < l; i++)
        temp[arr[i]] = true;

    var r = [];
    for (var k in temp)
        r.push(k);
    return r;
};

//用法
var fruits = ['apple', 'orange', 'peach', 'apple', 'strawberry', 'orange'];
var uniquefruits = removeDuplicates(fruits);
//输出 uniquefruits ['apple', 'orange', 'peach', 'strawberry'];


/**
 * 以数组形式返回原数组中不为 null 与 undefined 的元素。原数组不改变
 * @return {Array} 以数组形式返回原数组中不为 null 与 undefined 的元素
 *
 * @example
 *  var arr = ['a', 'b', 'c', 'd', 'c', null];
 *  var arr2 = arr.notNull(); // arr2 为: ['a', 'b', 'c', 'd', 'c']
 */
Array.prototype.notNull = function() {
    var result = [];
    for (var i=0,l=this.length; i<l; i++) {
        if (this[i] != null) result.push(this[i]);
    }
    return result;
};

/**
 * 返回数组里的最大值
 * 如果数组里有不能直接转成数值的值,或者有 NaN,则返回 NaN；空值按0处理,能转成数值的字符串会被转成数值处理
 * @return {Number | NaN} 返回数组里的最大值
 *
 * @example
 *  var arr = ['66', 44, 32.1, null];
 *  var arr2 = ['66', 44, 32.1, null, 'a'];
 *  alert( arr.max() ); // 值为: 66
 *  alert( arr2.max() ); // 值为: NaN
 */
Array.prototype.max = function() {
    return Math.max.apply(null,this);
};

/**
 * 返回数组里的最小值
 * 如果数组里有不能直接转成数值的值,或者有 NaN,则返回 NaN；空值按0处理,能转成数值的字符串会被转成数值处理
 * @return {Number | NaN} 返回数组里的最小值
 *
 * @example
 *  var arr = ['66', 44, 32.1, null, -1];
 *  var arr2 = ['66', 44, 32.1, null];
 *  alert( arr.min() ); // 值为: -1
 *  alert( arr2.min() ); // 值为: 0
 */
Array.prototype.min = function() {
    return Math.min.apply(null,this);
};


