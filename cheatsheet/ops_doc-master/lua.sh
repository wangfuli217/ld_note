大小写字符敏感
Lua脚本的语句的分号是可选的

Lua 是一门扩展式程序设计语言，被设计成支持通用过程式编程，并有相关数据描述设施。 
同时对面向对象编程、函数式编程和数据驱动式编程也提供了良好的支持。 
它作为一个强大、轻量的嵌入式脚本语言，可供任何需要的程序使用。 
Lua 由 clean C（标准 C 和 C++ 间共通的子集） 实现成一个库。

Lua 是一门动态类型语言。 这意味着变量没有类型；只有值才有类型。 语言中不设类型定义。 所有的值携带自己的类型。


lua(注释){
-- 两个减号是行注释

 --[[
 这是块注释
 这是块注释
 --]]
 
}
在 Lua 中, 函数是和字符串、数值和表并列的基本数据结构, 属于第一类对象( first-class-object /一等公民), 
可以和数值等其他类型一样赋给变量、作为参数传递, 以及作为返回值接收(闭包):

Lua 中所有的值都是一等公民。 这意味着所有的值均可保存在变量中、 当作参数传递给其它函数、以及作为返回值。

库函数 type 用于以字符串形式返回给定值的类型。
lua(变量){
Lua 中有八种基本类型： nil、boolean、number、string、function、userdata、 thread 和 table。 
1. Nil 是值 nil 的类型， 其主要特征就是和其它值区别开；通常用来表示一个有意义的值不存在时的状态。 
2. Boolean 是 false 与 true 两个值的类型。 nil 和 false 都会导致条件判断为假； 而其它任何值都表示为真。 
3. Number 代表了整数和实数（浮点数）。
   number 类型有两种内部表现方式，整数 和 浮点数。
   标准 Lua 使用 64 位整数和双精度（64 位）浮点数。
4. String 表示一个不可变的字节序列。 
   Lua 对 8 位是友好的： 字符串可以容纳任意 8 位值，其中包含零 ('\0') 。 
   string字符序列中的字符采用完全8位编码，即可以存放任何二进制数据。
   Lua 的字符串与编码无关； 它不关心字符串中具体内容。
5. Lua 可以调用（以及操作）用 Lua 或 C 编写的函数。 这两种函数有统一类型 function。
6. userdata 类型允许将 C 中的数据保存在 Lua 变量中。 
   用户数据类型的值是一个内存块， 有两种用户数据： 完全用户数据 ，指一块由 Lua 管理的内存对应的对象； 
                                                   轻量用户数据 ，则指一个简单的 C 指针。
   用户数据在 Lua 中除了赋值与相等性判断之外没有其他预定义的操作。 
   通过使用 元表 ，程序员可以给完全用户数据定义一系列的操作。 你只能通过 C API 而无法在 Lua 代码中创建或者修改用户数据的值， 这保证了数据仅被宿主程序所控制。
7. thread 类型表示了一个独立的执行序列，被用于实现协程
8. table 是一个关联数组， 也就是说，这个数组不仅仅以数字做索引，除了 nil 和 NaN 之外的所有 Lua 值 都可以做索引。
   对于记录，Lua 使用域名作为索引。 语言提供了 a.name 这样的语法糖来替代 a["name"] 这种写法以方便记录这种结构的使用。 在 Lua 中有多种便利的方式创建表

全局变量、局部变量和表的域
1. 单个名字可以指代一个全局变量也可以指代一个局部变量 （或者是一个函数的形参，这是一种特殊形式的局部变量）。
2. 局部变量可以被定义在它作用范围中的函数自由使用.
3. 在变量的首次赋值之前，变量的值均为 nil。
4. 方括号被用来对表作索引：
	var ::= prefixexp ‘[’ exp ‘]’
5. var.Name 这种语法只是一个语法糖，用来表示 var["Name"]：
	var ::= prefixexp ‘.’ Name
对全局变量 x 的操作等价于操作 _ENV.x。 由于代码块编译的方式， _ENV 永远也不可能是一个全局名字.
对于全局变量 x = val 的赋值等价于 _ENV.x = val

Lua 中有这些基本表达式:
1. exp ::= prefixexp
2. exp ::= nil | false | true
3. exp ::= Numeral
4. exp ::= LiteralString
5. exp ::= functiondef
6. exp ::= tableconstructor
7. exp ::= ‘...’
8. exp ::= exp binop exp
9. exp ::= unop exp
10. prefixexp ::= var | functioncall | ‘(’ exp ‘)’

1. f()                -- 调整为 0 个结果
2. g(f(), x)          -- f() 会被调整为一个结果
3. g(x, f())          -- g 收到 x 以及 f() 返回的所有结果
4. a,b,c = f(), x     -- f() 被调整为 1 个结果 （c 收到 nil）
5. a,b = ...          -- a 收到可变参数列表的第一个参数，
                      -- b 收到第二个参数（如果可变参数列表中
                      -- 没有实际的参数，a 和 b 都会收到 nil）
   
6. a,b,c = x, f()     -- f() 被调整为 2 个结果
7. a,b,c = f()        -- f() 被调整为 3 个结果
8. return f()         -- 返回 f() 的所有返回结果
9. return ...         -- 返回从可变参数列表中接收到的所有参数parameters
10. return x,y,f()     -- 返回 x, y, 以及 f() 的所有返回值
11. {f()}              -- 用 f() 的所有返回值创建一个列表
12. {...}              -- 用可变参数中的所有值创建一个列表
13. {f(), nil} -- f() 被调整为一个结果
}

lua(变量:数字){
Lua的数字只有double型，64bits，你不必担心Lua处理浮点数会慢（除非大于100,000,000,000,000），或是会有精度问题。
你可以以如下的方式表示数字，0x开头的16进制和C是很像的。
num = 1024
num = 3.0
num = 3.1416
num = 314.16e-2
num = 0.31416E1
num = 0xff
num = 0x56

1. 数学操作符的操作数如果是字符串会自动转换成数字,
2. 连接 .. 自动将数值转换成字符串;
3. 比较操作符的结果一定是布尔类型, 且会严格判断数据类型('1' != 1);
}

lua(数学运算操作符){
 Lua 支持下列数学运算操作符：
    +: 加法
    -: 减法
    *: 乘法
    /: 浮点除法
    //: 向下取整除法
    %: 取模
    ^: 乘方
    -: 取负

Lua 支持下列位操作符：
    &: 按位与
    |: 按位或
    ~: 按位异或
    >>: 右移
    <<: 左移
    ~: 按位非
Lua 支持下列位操作符：
    &: 按位与
    |: 按位或
    ~: 按位异或
    >>: 右移
    <<: 左移
    ~: 按位非
    
Lua 中的逻辑操作符有 and， or，以及 not。 和控制结构（参见 §3.3.4）一样， 所有的逻辑操作符把 false 和 nil 都作为假， 而其它的一切都当作真。
     10 or 20            --> 10
     10 or error()       --> 10
     nil or "a"          --> "a"
     nil and 10          --> nil
     false and error()   --> false
     false and nil       --> false
     false or nil --> nil 
     10 and 20 --> 20
}
lua(变量：字符串连接 ..){}
lua(变量：字符串连接 "#"){}
lua(变量：字符串){
字符串你可以用单引号，也可以用双引号，还支持C类型的转义，比如： ‘\a’ （响铃）， ‘\b’ （退格）， ‘\f’ （表单）， ‘\n’ （换行）， ‘\r’ （回车）， ‘\t’ （横向制表）， ‘\v’ （纵向制表）， ‘\\’ （反斜杠）， ‘\”‘ （双引号）， 以及 ‘\” （单引号)

下面的四种方式定义了完全相同的字符串（其中的两个中括号可以用于定义有换行的字符串）

可以通过<转义符'\'+数值>来指定字符串中的字符，数值为最多3位数组成的序列。

# a = 'alo\n123"'
# a = "alo\n123\""
# a = '\97lo\10\04923"'
# a = [[alo123"]]

一般而言，你可以用字符的数字值来表示这个字符。
方式是用转义串 \xXX， 此处的 XX 必须是恰好两个字符的 16 进制数。 
或者你也可以使用转义串 \ddd ， 这里的 ddd 是一到三个十进制数字。

# 注意，如果在转义符后接着恰巧是一个数字符号的话， 你就必须在这个转义形式中写满三个数字。
#对于用 UTF-8 编码的 Unicode 字符，你可以用 转义符 \u{XXX} 来表示 （这里必须有一对花括号）， 此处的 XXX 是用 16 进制表示的字符编号。
C语言中的NULL在Lua中是nil，比如你访问一个没有声明过的变量，就是nil，比如下面的v的值就是nil

v = UndefinedVariable #nil

长括号: 可以用一对[[XXX]]来界定一个字符串XXX。字符串可以为任意字符。
        如上的表示有一个bug，就是当字符串包含[[或]]子串的时候，会表达错误。
         Lua提供了[===[XXX]===]这样的形式来包含字符串XXX。其中，两边中括号之间的"="数量要匹配。如：
}

lua(变量：布尔类型){
布尔类型只有nil和false是false，数字0啊，‘’空字符串（’\0’）都是true!
}

lua(局部变量){
另外，需要注意的是：lua中的变量如果没有特殊说明，全是全局变量，那怕是语句块或是函数里。变量前加local
关键字的是局部变量。
theGlobalVar = 50
local theLocalVar = "local variable"

x = 10                -- 全局变量
do                    -- 新的语句块
  local x = x         -- 新的一个 'x', 它的值现在是 10
  print(x)            --> 10
  x = x+1
  do                  -- 另一个语句块
    local x = x+1     -- 又一个 'x'
    print(x)          --> 12
  end
  print(x)            --> 11
  end
print(x)              --> 10 （取到的是全局的那一个）

    注意这里，类似 local x = x 这样的声明， 新的 x 正在被声明，但是还没有进入它的作用范围， 所以第二个 x 
指向的是外面一层的变量。
    因为有这样一个词法作用范围的规则， 局部变量可以被在它的作用范围内定义的函数自由使用。 当一个局部变量
被内层的函数中使用的时候， 它被内层函数称作 上值，或是 外部局部变量。
}

lua(环境与全局环境){
引用一个叫 var 的自由名字（指在任何层级都未被声明的名字） 在句法上都被翻译为 _ENV.var 。 此外，
每个被编译的 Lua 代码块都会有一个外部的局部变量叫 _ENV， 因此，_ENV 这个名字永远都不会成为一个代码块中的自由名字。


}

lua(错误处理){
    由于 Lua 是一门嵌入式扩展语言，其所有行为均源于宿主程序中 C 代码对某个 Lua 库函数的调用。 （单独使用 Lua 时，
lua 程序就是宿主程序。） 所以，在编译或运行 Lua 代码块的过程中，无论何时发生错误， 控制权都返回给宿主，
由宿主负责采取恰当的措施（比如打印错误消息）。

    可以在 Lua 代码中调用 error 函数来显式地抛出一个错误。 如果你需要在 Lua 中捕获这些错误， 可以使用 
pcall 或 xpcall 在 保护模式 下调用一个函数。

     无论何时出现错误，都会抛出一个携带错误信息的 错误对象 （错误消息）。 Lua 本身只会为错误生成字符串类型
的错误对象， 但你的程序可以为错误生成任何类型的错误对象， 这就看你的 Lua 程序或宿主程序如何处理这些错误对象。

    使用 xpcall 或 lua_pcall 时， 你应该提供一个 消息处理函数 用于错误抛出时调用。 该函数需接收原始的错误消息，
并返回一个新的错误消息。 它在错误发生后栈尚未展开时调用， 因此可以利用栈来收集更多的信息， 比如通过探知栈来
创建一组栈回溯信息。 同时，该处理函数也处于保护模式下，所以该函数内发生的错误会再次触发它（递归）。 如果
递归太深，Lua 会终止调用并返回一个合适的消息。
}

lua(控制结构){
if, while, and repeat 这些控制结构符合通常的意义，而且也有类似的语法：
	stat ::= while exp do block end
	stat ::= repeat block until exp
	stat ::= if exp then block {elseif exp then block} [else block] end
Lua 也有一个 for 语句，它有两种形式

控制结构中的条件表达式可以返回任何值。 false 与 nil 两者都被认为是假。
所有不同于 nil 与 false 的其它值都被认为是真 （特别需要注意的是，数字 0 和空字符串也被认为是真）。
}
lua(控制结构:goto){
goto 语句将程序的控制点转移到一个标签处。 由于句法上的原因， Lua 里的标签也被认为是语句：
	stat ::= goto Name
	stat ::= label
	label ::= ‘::’ Name ‘::’
除了在内嵌函数中，以及在内嵌语句块中定义了同名标签，的情况外， 标签对于它定义所在的整个语句块可见。 
只要 goto 没有进入一个新的局部变量的作用域，它可以跳转到任意可见标签处。
}

lua(控制结构:break){
break 被用来结束 while、 repeat、或 for 循环， 它将跳到循环外接着之后的语句运行：
	stat ::= break
break 跳出最内层的循环。
}
lua(控制结构:return){
return 被用于从函数或是代码块（其实它就是一个函数） 中返回值。 函数可以返回不止一个值，所以 return 的语法为
	stat ::= return [explist] [‘;’]
return 只能被写在一个语句块的最后一句。 如果你真的需要从语句块的中间 return， 你可以使用显式的定义一个内部语句块，
一般写作 do return end。 可以这样写是因为现在 return 成了（内部）语句块的最后一句了。
}

lua(控制语句:while循环){
sum = 0
num = 1
while num <= 100 do
    sum = sum + num
    num = num + 1
end
print("sum =",sum)

}

lua(控制语句:if-else分支){
if age == 40 and sex =="Male" then
    print("男人四十一枝花")
elseif age > 60 and sex ~="Female" then
    print("old man without country!")
elseif age < 20 then
    io.write("too young, too naive!\n")
else
    local age = io.read()
    print("Your age is "..age)
end

上面的语句不但展示了if-else语句，也展示了
1）“～=”是不等于，而不是!=
2）io库的分别从stdin和stdout读写的read和write函数
3）字符串的拼接操作符“..”

另外，条件表达式中的与或非为分是：and, or, not关键字。
}

lua(控制语句:for 循环){
# 从1加到100
sum = 0
for i = 1, 100 do
    sum = sum + i
end

# 从1到100的奇数和
sum = 0
for i = 1, 100, 2 do
    sum = sum + i
end

# 从100到1的偶数和
sum = 0
for i = 100, 1, -2 do
    sum = sum + i
end
}

lua(控制语句:until循环){
sum = 2
repeat
   sum = sum ^ 2 --幂操作
   print(sum)
until sum >1000
}

lua(函数调用){
Lua 中的函数调用的语法如下：
	functioncall ::= prefixexp args
函数调用时， 第一步，prefixexp 和 args 先被求值。 如果 prefixexp 的值的类型是 function， 
那么这个函数就被用给出的参数调用。 否则 prefixexp 的元方法 "call" 就被调用， 第一个参数是 prefixexp 的值，
接下来的是原来的调用参数.

这样的形式
	functioncall ::= prefixexp ‘:’ Name args
可以用来调用 "方法"。 这是 Lua 支持的一种语法糖。 像 v:name(args) 这个样子， 被解释成 v.name(v,args)， 
这里的 v 只会被求值一次。
参数的语法如下：
	args ::= ‘(’ [explist] ‘)’
	args ::= tableconstructor
	args ::= LiteralString
    
}
lua(函数:递归){
Lua的函数和Javascript的很像
function fib(n)
  if n < 2 then return 1 end
  return fib(n - 2) + fib(n - 1)
end

}

lua(函数:闭包){
同样，Javascript附体！

示例一
function newCounter()
    local i = 0
    return function()     -- anonymous function
       i = i + 1
        return i
    end
end
 
c1 = newCounter()
print(c1())  --> 1
print(c1())  --> 2
 

示例二
function myPower(x)
    return function(y) return y^x end
end
 
power2 = myPower(2)
power3 = myPower(3)
 
print(power2(4)) --4的2次方
print(power3(5)) --5的3次方
}

lua(函数的返回值){
和Go语言一样，可以一条语句上赋多个值，如：

name, age, bGay = "haoel", 37, false, "haoel@hotmail.com"
上面的代码中，因为只有3个变量，所以第四个值被丢弃。

函数也可以返回多个值：

function getUserInfo(id)
    print(id)
    return "haoel", 37, "haoel@hotmail.com", "http://coolshell.cn"
end
 
name, age, email, website, bGay = getUserInfo()
注意：上面的示例中，因为没有传id，所以函数中的id输出为nil，因为没有返回bGay，所以bGay也是nil。
}

lua(变数形参){
-- 4. 变数形参
local function square(...)
    local argv = { ... }
    for i = 1, #argv do
        argv[i] = argv[i] * argv[i]
    end
    return table.unpack(argv)
end

print(square(1, 2, 3))
}

lua(局部函数){
函数前面加上local就是局部函数，其实，Lua中的函数和Javascript中的一个德行。

比如：下面的两个函数是一样的：
function foo(x) return x^2 end
foo = function(x) return x^2 end
}

1. 数组索引从1开始;
2. 获取数组长度操作符#其’长度’只包括以(正)整数为索引的数组元素.
3. Lua用表管理全局变量, 将其放入一个叫_G的table内:
4. pairs会遍历所有值不为nil的索引, 与此类似的ipairs只会从索引1开始递遍历到最后一个值不为nil的整数索引

lua(Table){
    所谓Table其实就是一个Key Value的数据结构，它很像Javascript中的Object，或是PHP中的数组，在别的语言里叫Dict或Map，
Table长成这个样子：

haoel = {name="ChenHao", age=37, handsome=True}
下面是table的CRUD操作：

haoel.website="http://coolshell.cn/"
local age = haoel.age
haoel.handsome = false
haoel.name=nil
上面看上去像C/C++中的结构体，但是name,age, handsome, website都是key。你还可以像下面这样写义Table：

t = {[20]=100, ['name']="ChenHao", [3.14]="PI"}
这样就更像Key Value了。于是你可以这样访问：t[20]，t[“name”], t[3.14]。

我们再来看看数组：

arr = {10,20,30,40,50}
这样看上去就像数组了。但其实其等价于：

arr = {[1]=10, [2]=20, [3]=30, [4]=40, [5]=50}
所以，你也可以定义成不同的类型的数组，比如：

arr = {"string", 100, "haoel", function() print("coolshell.cn") end}
注：其中的函数可以这样调用：arr[4]()。

我们可以看到Lua的下标不是从0开始的，是从1开始的。

for i=1, #arr do
    print(arr[i])
end
注：上面的程序中：#arr的意思就是arr的长度。

注：前面说过，Lua中的变量，如果没有local关键字，全都是全局变量，Lua也是用Table来管理全局变量的，Lua把这些全局变量放在了一个叫“_G”的Table里。

我们可以用如下的方式来访问一个全局变量（假设我们这个全局变量名叫globalVar）：

_G.globalVar
_G["globalVar"]
我们可以通过下面的方式来遍历一个Table。

for k, v in pairs(t) do
    print(k, v)
end
}

lua(MetaTable 和 MetaMethod){
MetaTable和MetaMethod是Lua中的重要的语法，MetaTable主要是用来做一些类似于C++重载操作符式的功能。

比如，我们有两个分数：
fraction_a = {numerator=2, denominator=3}
fraction_b = {numerator=4, denominator=7}
我们想实现分数间的相加：2/3 + 4/7，我们如果要执行： fraction_a + fraction_b，会报错的。

所以，我们可以动用MetaTable，如下所示：
fraction_op={}
function fraction_op.__add(f1, f2)
    ret = {}
    ret.numerator = f1.numerator * f2.denominator + f2.numerator * f1.denominator
    ret.denominator = f1.denominator * f2.denominator
    return ret
end
为之前定义的两个table设置MetaTable：（其中的setmetatble是库函数）

setmetatable(fraction_a, fraction_op)
setmetatable(fraction_b, fraction_op)
于是你就可以这样干了：（调用的是fraction_op.__add()函数）
fraction_s = fraction_a + fraction_b
至于__add这是MetaMethod，这是Lua内建约定的，其它的还有如下的MetaMethod：

__add(a, b)                     对应表达式 a + b
__sub(a, b)                     对应表达式 a - b
__mul(a, b)                     对应表达式 a * b
__div(a, b)                     对应表达式 a / b
__mod(a, b)                     对应表达式 a % b
__pow(a, b)                     对应表达式 a ^ b
__unm(a)                        对应表达式 -a
__idiv(a,b)                     对应表达式 向下取整除法
__band(a,b)                     对应表达式 a & b
__bor(a,b)                      对应表达式 a | b
__bxor(a,b)                     对应表达式 a ^ b
__bnot(a)                       对应表达式 ~ a 
__shl(a, b)                     对应表达式 "a << b"
__shr(a, b)                     对应表达式 "a >> b"
__concat(a, b)                  对应表达式 a .. b
__len(a)                        对应表达式 #a
__eq(a, b)                      对应表达式 a == b
__lt(a, b)                      对应表达式 a < b
__le(a, b)                      对应表达式 a <= b
__index(a, b)                   对应表达式 a.b
    索引 table[key]。 当 table 不是表或是表 table 中不存在 key 这个键时，这个事件被触发。 
此时，会读出 table 相应的元方法。
    尽管名字取成这样， 这个事件的元方法其实可以是一个函数也可以是一张表。 如果它是一个函数，
则以 table 和 key 作为参数调用它。 如果它是一张表，最终的结果就是以 key 取索引这张表的结果。 
（这个索引过程是走常规的流程，而不是直接索引， 所以这次索引有可能引发另一次元方法。）

__newindex(a, b, c)             对应表达式 a.b = c
    索引赋值 table[key] = value 。 和索引事件类似，它发生在 table 不是表或是表 table 中不存在 
key 这个键的时候。 此时，会读出 table 相应的元方法。
    同索引过程那样， 这个事件的元方法即可以是函数，也可以是一张表。 如果是一个函数， 则以 table、 
key、以及 value 为参数传入。 如果是一张表， Lua 对这张表做索引赋值操作。 （这个索引过程是走常规的流程，
而不是直接索引赋值， 所以这次索引赋值有可能引发另一次元方法。）
    一旦有了 "newindex" 元方法， Lua 就不再做最初的赋值操作。 （如果有必要，在元方法内部可以调用 rawset 来做赋值。）
__call(a, ...)                  对应表达式 a(...)
}

Lua本来就不是设计为一种面向对象语言, 因此其面向对象功能需要通过元表(metatable)这种非常怪异的方式实现, 
Lua并不直接支持面向对象语言中常见的类、对象和方法: 其对象和类通过表实现, 而方法是通过函数来实现.

面向对象的基础是创建对象和调用方法. Lua中, 表作为对象使用, 因此创建对象没有问题, 关于调用方法, 如果表元素为函数的话, 则可直接调用:
-- 从obj取键为x的值, 将之视为function进行调用
obj.x(foo)

lua(元表及元方法){
    Lua 中的每个值都可以有一个 元表。 这个 元表 就是一个普通的 Lua 表， 它用于定义原始值在特定操作下的行为。
如果你想改变一个值在特定操作下的行为，你可以在它的元表中设置对应域。 例如，当你对非数字值做加操作时， 
Lua 会检查该值的元表中的 "__add" 域下的函数。 如果能找到，Lua 则调用这个函数来完成加这个操作。

    元表中的键对应着不同的 事件名； 键关联的那些值被称为 元方法。 在上面那个例子中引用的事件为 "add" ， 
完成加操作的那个函数就是元方法。
[元表->普通的LUA表；域：_add域下的函数；键->事件名；元方法->键关联的那些值]

    你可以用 getmetatable 函数 来获取任何值的元表。
    使用 setmetatable 来替换一张表的元表。在 Lua 中，你不可以改变表以外其它类型的值的元表； 
若想改变这些非表类型的值的元表，请使用 C API。
[getmetatable; setmetatable]

1. 表和完全用户数据有独立的元表 （当然，多个表和用户数据可以共享同一个元表）。 其它类型的值按类型共享元表； 
   也就是说所有的数字都共享同一个元表， 所有的字符串共享另一个元表等等。 默认情况下，值是没有元表的， 
   但字符串库在初始化的时候为字符串类型设置了元表。
2. 元表决定了一个对象在数学运算、位运算、比较、连接、 取长度、调用、索引时的行为。 元表还可以定义一个函数，
   当表对象或用户数据对象在垃圾回收时调用它。
3. 访问元表中的元方法永远不会触发另一次元方法。
4. rawget(getmetatable(obj) or {}, "__" .. event_name)
}

lua(面向对象){
上面我们看到有__index这个重载，这个东西主要是重载了find key的操作。这操作可以让Lua变得有点面向对象的感觉，让其有点像Javascript的prototype。

所谓__index，说得明确一点，如果我们有两个对象a和b，我们想让b作为a的prototype只需要：

setmetatable(a, {__index = b})
例如下面的示例：你可以用一个Window_Prototype的模板加上__index的MetaMethod来创建另一个实例：

Window_Prototype = {x=0, y=0, width=100, height=100}
MyWin = {title="Hello"}
setmetatable(MyWin, {__index = Window_Prototype})
于是：MyWin中就可以访问x, y, width, height的东东了。（注：当表要索引一个值时如table[key], Lua会首先在table本身中查找key的值, 如果没有并且这个table存在一个带有__index属性的Metatable, 则Lua会按照__index所定义的函数逻辑查找）

有了以上的基础，我们可以来说说所谓的Lua的面向对象。

Person={}
 
function Person:new(p)
    local obj = p
    if (obj == nil) then
        obj = {name="ChenHao", age=37, handsome=true}
    end
    self.__index = self
    return setmetatable(obj, self)
end
 
function Person:toString()
    return self.name .." : ".. self.age .." : ".. (self.handsome and "handsome" or "ugly")
end

上面我们可以看到有一个new方法和一个toString的方法。其中：

1）self 就是 Person，Person:new(p)，相当于Person.new(self, p)
2）new方法的self.__index = self 的意图是怕self被扩展后改写，所以，让其保持原样
3）setmetatable这个函数返回的是第一个参数的值。


于是：我们可以这样调用：

me = Person:new()
print(me:toString())
 
kf = Person:new{name="King's fucking", age=70, handsome=false}
print(kf:toString())
继承如下，我就不多说了，Lua和Javascript很相似，都是在Prototype的实例上改过来改过去的。

Student = Person:new()

function Student:new()
    newObj = {year = 2013}
    self.__index = self
    return setmetatable(newObj, self)
end
 
function Student:toString()
    return "Student : ".. self.year.." : " .. self.name
end

}

lua(面向对象说明){
    首先: obj.x这种调用方式, 只是将表obj的属性x这个函数对象取出而已, 而在大多数面向对象语言中, 
方法的实体位于类中, 而非单独的对象中. 在JavaScript等基于原型的语言中, 是以原型对象来代替类进行
方法的搜索, 因此每个单独的对象也并不拥有方法实体. 在Lua中, 为了实现基于原型的方法搜索, 需要使用
元表的__index事件:

    其次: 通过方法搜索得到的函数对象只是单纯的函数, 而无法获得最初调用方法的表(接收器)相关信息. 
于是, 过程和数据就发生了分离.JavaScript中, 关于接收器的信息可由关键字this获得, 而在Python中通过
方法调用形式获得的并非单纯的函数对象, 而是一个“方法对象” –其接收器会在内部作为第一参数附在
函数的调用过程中.
    而Lua准备了支持方法调用的语法糖:obj:x(). 表示obj.x(obj), 也就是: 通过冒号记法调用的函数, 
其接收器会被作为第一参数添加进来(obj的求值只会进行一次, 即使有副作用也只生效一次).
}
lua(模块){
我们可以直接使用require(“model_name”)来载入别的lua文件，文件的后缀是.lua。载入的时候就直接执行那个文件了。比如：

我们有一个hello.lua的文件：
print("Hello, World!")
如果我们：require(“hello”)，那么就直接输出Hello, World！了。

注意：
1）require函数，载入同样的lua文件时，只有第一次的时候会去执行，后面的相同的都不执行了。
2）如果你要让每一次文件都会执行的话，你可以使用dofile(“hello”)函数
3）如果你要玩载入后不执行，等你需要的时候执行时，你可以使用 loadfile()函数，如下所示：

local hello = loadfile("hello")
... ...
... ...
hello()
loadfile(“hello”)后，文件并不执行，我们把文件赋给一个变量hello，当hello()时，才真的执行。

假设我们有一个文件叫mymod.lua，内容如下：

文件名：MYMOD.LUA
local HaosModel = {}
 
local function getname()
    return "Hao Chen"
end
 
function HaosModel.Greeting()
    print("Hello, My name is "..getname())
end
 
return HaosModel
于是我们可以这样使用：

local hao_model = require("mymod")
hao_model.Greeting()
其实，require干的事就如下：（所以你知道为什么我们的模块文件要写成那样了）

local hao_model = (function ()
  --mymod.lua文件的内容--
end)()
}

lua(垃圾收集){
1. Lua 中所有用到的内存，如：字符串、表、用户数据、函数、线程、 内部结构等，都服从自动管理。
2. Lua 实现了一个增量标记-扫描收集器。 它使用这两个数字来控制垃圾收集循环： 垃圾收集器间歇率 和 
   垃圾收集器步进倍率。 这两个数字都使用百分数为单位 （例如：值 100 在内部表示 1 ）。
3. 垃圾收集器间歇率控制着收集器需要在开启新的循环前要等待多久。 增大这个值会减少收集器的积极性。 
   当这个值比 100 小的时候，收集器在开启新的循环前不会有等待。 设置这个值为 200 就会让收集器等到
   总内存使用量达到 之前的两倍时才开始新的循环。
4. 垃圾收集器步进倍率控制着收集器运作速度相对于内存分配速度的倍率。
   增大这个值不仅会让收集器更加积极，还会增加每个增量步骤的长度。 不要把这个值设得小于 100 ， 
   那样的话收集器就工作的太慢了以至于永远都干不完一个循环。 默认值是 200 ，这表示收集器以内存分配的"两倍"速工作。
5. 你可以通过在 C 中调用 lua_gc 或在 Lua 中调用 collectgarbage 来改变这俩数字。 这两个函数也可以用来直接控制收集器（例如停止它或重启它）。
6. 如果要让一个对象（表或用户数据）在收集过程中进入终结流程， 你必须标记它需要触发终结器。 当你为
   一个对象设置元表时，若此刻这张元表中用一个以字符串 "__gc" 为索引的域，那么就标记了这个对象需要触发终结器。
   注意：如果你给对象设置了一个没有 __gc 域的元表，之后才给元表加上这个域， 那么这个对象是没有被标记
   成需要触发终结器的。 然而，一旦对象被标记， 你还是可以自由的改变其元表中的 __gc 域的。
}

lua(弱表){
1. 弱表 指内部元素为 弱引用 的表。 垃圾收集器会忽略掉弱引用。 换句话说，如果一个对象只被弱引用引用到， 垃圾收集器就会回收这个对象。
2. 一张弱表可以有弱键或是弱值，也可以键值都是弱引用。 仅含有弱键的表允许收集器回收它的键，但会阻止对值所指的对象被回收。
}

    以嵌入式为方针设计的Lua, 在默认状态下简洁得吓人. 除了基本的数据类型外, 其他一概没有. 标注库也就 
Coroutine、String、Table、Math、 I/O、OS, 再加上Modules包加载而已.
lua(Coroutine){
1. 与多线程系统中的线程的区别在于， 协程仅在显式调用一个让出（yield）函数时才挂起当前的执行。
 coroutine.create :其唯一的参数是该协程的主函数。 create 函数只负责新建一个协程并返回其句柄（一个 thread 类型的对象）； 而不会启动该协程。
(3)coroutine.resume (co [, val1, ···])
　　这是一个非常重要的函数。用来启动或再次启动一个协程，使其由挂起状态变成运行状态。
　　可以这么说，resume函数相当于在执行协程中的方法。参数Val1...是执行协程co时传递给协程的方法。
　　首次执行协程co时，参数Val1...会传递给协程co的函数；
　　再次执行协程co时，参数Val1...会作为给协程co中上一次yeild的返回值。
　　不知道这句话大家理解了没，这是协程的核心。如果没理解也不用急，继续往下看，稍后我会详细解释。
　　resume函数返回什么呢？有3种情况：
　　1）、如果协程co的函数执行完毕，协程正常终止，resume 返回 true和函数的返回值。
　　2）、如果协程co的函数执行过程中，协程让出了（调用了yeild()方法），那么resume返回true和协程中调用yeild传入的参数。
　　3）、如果协程co的函数执行过程中发生错误，resume返回false与错误消息。
　　可以看到resume无论如何都不会导致程序崩溃。它是在保护模式下执行的。

    协程的运行可能被两种方式终止： 正常途径是主函数返回 （显式返回或运行完最后一条指令）； 非正常途径是发生了
一个未被捕获的错误。 对于正常结束， coroutine.resume 将返回 true， 并接上协程主函数的返回值。 当错误发生时，
 coroutine.resume 将返回 false 与错误消息。
    通过调用 coroutine.yield 使协程暂停执行，让出执行权。 协程让出时，对应的最近 coroutine.resume 函数会立刻返回，
即使该让出操作发生在内嵌函数调用中 （即不在主函数，但在主函数直接或间接调用的函数内部）。 在协程让出的情况下， 
coroutine.resume 也会返回 true， 并加上传给 coroutine.yield 的参数。 当下次重启同一个协程时， 协程会接着从让
出点继续执行。 此时，此前让出点处对 coroutine.yield 的调用会返回，返回值为传给 coroutine.resume 的第一个参数
之外的其他参数。
    与 coroutine.create 类似， coroutine.wrap 函数也会创建一个协程。 不同之处在于，它不返回协程本身，而是返回
一个函数。 调用这个函数将启动该协程。 传递给该函数的任何参数均当作 coroutine.resume 的额外参数。 coroutine.wrap 
返回 coroutine.resume 的所有返回值，除了第一个返回值（布尔型的错误码）。 和 coroutine.resume 不同， 
coroutine.wrap 不会捕获错误； 而是将任何错误都传播给调用者。

你也可以通过 C API 来创建及操作协程： 参见函数 lua_newthread， lua_resume， 以及 lua_yield。

(2)coroutine.isyieldable ()
　　如果正在运行的协程可以让出，则返回真。值得注意的是，只有主协程（线程）和C函数中是无法让出的。
(4)coroutine.running ()
　　用来判断当前执行的协程是不是主线程，如果是，就返回true。
(5)coroutine.status (co)
　　返回一个字符串，表示协程的状态。有4种状态：
　　1）、running。如果在协程的函数中调用status，传入协程自身的句柄，那么执行到这里的时候才会返回running状态。
　　2）、suspended。如果协程还未结束，即自身调用了yeild或还没开始运行，那么就是suspended状态。
　　3）、normal。如果协程Aresume协程B时，协程A处于的状态为normal。在协程B的执行过程中，协程A就一直处于normal状态。因为它这时候既不是挂起状态、也不是运行状态。
　　4）、dead。如果一个协程发生错误结束，或正常终止。那么就处于dead状态。如果这时候对它调用resume，将返回false和错误消息。
(6)coroutine.wrap (f)
　　wrap()也是用来创建协程的。只不过这个协程的句柄是隐藏的。跟create()的区别在于：
　　1）、wrap()返回的是一个函数，每次调用这个函数相当于调用coroutine.resume()。
　　2）、调用这个函数相当于在执行resume()函数。
　　3）、调用这个函数时传入的参数，就相当于在调用resume时传入的除协程的句柄外的其他参数。
　　4）、调用这个函数时，跟resume不同的是，它并不是在保护模式下执行的，若执行崩溃会直接向外抛出。

(7)coroutine.yield (···)
　　使正在执行的函数挂起。
　　传递给yeild的参数会作为resume的额外返回值。
 　　同时，如果对该协程不是第一次执行resume，resume函数传入的参数将会作为yield的返回值。
}

lua(编程接口){
1. 所有的 API 函数按相关的类型以及常量都声明在头文件 lua.h 中。
2. 虽然我们说的是“函数”， 但一部分简单的 API 是以宏的形式提供的。 除非另有说明， 所有的这些宏都只使用它们的参数一次 ， 因此你不需担心这些宏的展开会引起一些副作用。
3. C 库中所有的 Lua API 函数都不去检查参数是否相容及有效。 然而，你可以在编译 Lua 时加上打开一个宏开关 LUA_USE_APICHECK 来改变这个行为。

1. Lua 使用一个 虚拟栈 来和 C 互传值。 栈上的的每个元素都是一个 Lua 值 （nil，数字，字符串，等等）。
2. 无论何时 Lua 调用 C，被调用的函数都得到一个新的栈， 这个栈独立于 C 函数本身的栈，也独立于之前的 Lua 栈。 它里面包含了 Lua 传递给 C 函数的所有参数， 
   而 C 函数则把要返回的结果放入这个栈以返回给调用者.
3. 当你使用 Lua API 时， 就有责任保证做恰当的调用。 特别需要注意的是， 你有责任控制不要堆栈溢出。 你可以使用 lua_checkstack 这个函数来扩大可用堆栈的尺寸。
4. API 中的函数若需要传入栈索引，这个索引必须是 有效索引 或是 可接受索引。

5. 当 C 函数被创建出来， 我们有可能会把一些值关联在一起， 也就是创建一个 C 闭包 （参见 lua_pushcclosure）； 这些被关联起来的值被叫做 上值 ， 它们可以在函数被调用的时候访问的到。

无论何时去调用 C 函数， 函数的上值都可以用伪索引定位。 我们可以用 lua_upvalueindex 这个宏来生成这些伪索引。 第一个关联到函数的值放在 lua_upvalueindex(1) 位置处，依此类推。 使用 lua_upvalueindex(n) 时， 若 n 大于当前函数的总上值个数 （但不可以大于 256）会产生一个可接受的但无效的索引。
}

lua(调试接口){
typedef struct lua_Debug {
  int event;
  const char *name;           /* (n) */
  const char *namewhat;       /* (n) */
  const char *what;           /* (S) */
  const char *source;         /* (S) */
  int currentline;            /* (l) */
  int linedefined;            /* (S) */
  int lastlinedefined;        /* (S) */
  unsigned char nups;         /* (u) 上值的数量 */
  unsigned char nparams;      /* (u) 参数的数量 */
  char isvararg;              /* (u) */
  char istailcall;            /* (t) */
  char short_src[LUA_IDSIZE]; /* (S) */
  /* 私有部分 */
  其它域
} lua_Debug;

这是一个携带有有关函数或活动记录的各种信息的结构。 lua_getstack 只会填充结构的私有部分供后面使用。 调用 lua_getinfo 可以在 lua_Debug 中填充那些可被使用的信息域。

下面对 lua_Debug 的各个域做一个说明：

    source: 创建这个函数的代码块的名字。 如果 source 以 '@' 打头， 指这个函数定义在一个文件中，而 '@' 之后的部分就是文件名。 若 source 以 '=' 打头， 剩余的部分由用户行为来决定如何表示源码。 其它的情况下，这个函数定义在一个字符串中， 而 source 正是那个字符串。
    short_src: 一个“可打印版本”的 source ，用于出错信息。
    linedefined: 函数定义开始处的行号。
    lastlinedefined: 函数定义结束处的行号。
    what: 如果函数是一个 Lua 函数，则为一个字符串 "Lua" ； 如果是一个 C 函数，则为 "C"； 如果它是一个代码块的主体部分，则为 "main"。
    currentline: 给定函数正在执行的那一行。 当提供不了行号信息的时候， currentline 被设为 -1 。
    name: 给定函数的一个合理的名字。 因为 Lua 中的函数是一等公民， 所以它们没有固定的名字： 一些函数可能是全局复合变量的值， 另一些可能仅仅只是被保存在一张表的某个域中。 lua_getinfo 函数会检查函数是怎样被调用的， 以此来找到一个适合的名字。 如果它找不到名字， name 就被设置为 NULL 。
    namewhat: 用于解释 name 域。 namewhat 的值可以是 "global", "local", "method", "field", "upvalue", 或是 "" （空串）。 这取决于函数怎样被调用。 （Lua 用空串表示其它选项都不符合。）
    istailcall: 如果函数以尾调用形式调用，这个值就为真。 在这种情况下，当层的调用者不在栈中。
    nups: 函数的上值个数。
    nparams: 函数固定形参个数 （对于 C 函数永远是 0 ）。
    isvararg: 如果函数是一个可变参数函数则为真 （对于 C 函数永远为真）。
}

lua(标准库：String){

}

lua(标准库：Table){

}

lua(标准库：Math){

}

lua(标准库：OS){

}

lua(标准库：Modules){

}

lua(标准库){
所有的库都是直接用 C API 实现的，并以分离的 C 模块形式提供。 目前，Lua 有下列标准库：

    基础库 (§6.1);
    协程库 (§6.2);
    包管理库 (§6.3);
    字符串控制 (§6.4);
    基础 UTF-8 支持 (§6.5);
    表控制 (§6.6);
    数学函数 (§6.7) (sin ，log 等);
    输入输出 (§6.8);
    操作系统库 (§6.9);
    调试库 (§6.10).
除了基础库和包管理库， 其它库都把自己的函数放在一张全局表的域中， 或是以对象方法的形式提供。
要使用这些库， C 的宿主程序需要先调用一下 luaL_openlibs 这个函数， 这样就能打开所有的标准库。 
或者宿主程序也可以用 luaL_requiref 分别打开这些库： 
luaopen_base （基础库）， 
luaopen_package （包管理库）， 
luaopen_coroutine （协程库）， 
luaopen_string （字符串库）， 
luaopen_utf8 （UTF8 库）， 
luaopen_table （表处理库）， 
luaopen_math （数学库）， 
luaopen_io （I/O 库）， 
luaopen_os （操作系统库）， 
luaopen_debug （调试库）。 
这些函数都定义在 lualib.h 中。

}

lua(基础函数:assert){
assert (v [, message])
    如果其参数 v 的值为假（nil 或 false）， 它就调用 error； 否则，返回所有的参数。 在错误情况时， 
message 指那个错误对象； 如果不提供这个参数，参数默认为 "assertion failed!" 。
}

lua(基础函数:collectgarbage){
collectgarbage ([opt [, arg]])
这个函数是垃圾收集器的通用接口。 通过参数 opt 它提供了一组不同的功能：
    "collect": 做一次完整的垃圾收集循环。 这是默认选项。
    "stop": 停止垃圾收集器的运行。 在调用重启前，收集器只会因显式的调用运行。
    "restart": 重启垃圾收集器的自动运行。
    "count": 以 K 字节数为单位返回 Lua 使用的总内存数。 这个值有小数部分，所以只需要乘上 1024 就能得到 Lua 使用的准确字节数（除非溢出）。
    "step": 单步运行垃圾收集器。 步长“大小”由 arg 控制。 传入 0 时，收集器步进（不可分割的）一步。 传入非 0 值， 收集器收集相当于 Lua 分配这些多（K 字节）内存的工作。 如果收集器结束一个循环将返回 true 。
    "setpause": 将 arg 设为收集器的 间歇率 （参见 §2.5）。 返回 间歇率 的前一个值。
    "setstepmul": 将 arg 设为收集器的 步进倍率 （参见 §2.5）。 返回 步进倍率 的前一个值。
    "isrunning": 返回表示收集器是否在工作的布尔值 （即未被停止）。
}

lua(基础函数:dofile){
dofile ([filename])
打开该名字的文件，并执行文件中的 Lua 代码块。 不带参数调用时， dofile 执行标准输入的内容（stdin）。 
返回该代码块的所有返回值。 对于有错误的情况，dofile 将错误反馈给调用者 （即，dofile 没有运行在保护模式下）。
}

lua(基础函数:error){
error (message [, level])
中止上一次保护函数调用， 将错误对象 message 返回。 函数 error 永远不会返回。

当 message 是一个字符串时，通常 error 会把一些有关出错位置的信息附加在消息的前头。 
level 参数指明了怎样获得出错位置。 对于 level 1 （默认值），出错位置指 error 函数调用的位置。 
Level 2 将出错位置指向调用 error的函数的函数；以此类推。 传入 level 0 可以避免在消息前添加出错位置信息。
}

lua(基础函数:_G){
一个全局变量（非函数）， 内部储存有全局环境（参见 §2.2）。 Lua 自己不使用这个变量； 改变这个变量的值不会对任何环境造成影响，反之亦然。
}

lua(基础函数:getmetatable){
getmetatable (object)
如果 object 不包含元表，返回 nil 。 否则，如果在该对象的元表中有 "__metatable" 域时返回其关联值， 没有时返回该对象的元表。
}

lua(基础函数:ipairs){
返回三个值（迭代函数、表 t 以及 0 ）， 如此，以下代码
     for i,v in ipairs(t) do body end
将迭代键值对（1,t[1]) ，(2,t[2])， ... ，直到第一个空值。
}

lua(基础函数:load){
load (chunk [, chunkname [, mode [, env]]])
加载一个代码块。
如果 chunk 是一个字符串，代码块指这个字符串。 如果 chunk 是一个函数， load 不断地调用它获取代码块的片断。 每次对 chunk 的调用都必须返回一个字符串紧紧连接在上次调用的返回串之后。 当返回空串、nil、或是不返回值时，都表示代码块结束。
如果没有语法错误， 则以函数形式返回编译好的代码块； 否则，返回 nil 加上错误消息。
如果结果函数有上值， env 被设为第一个上值。 若不提供此参数，将全局环境替代它。 所有其它上值初始化为 nil。 （当你加载主代码块时候，结果函数一定有且仅有一个上值 _ENV （参见 §2.2））。 然而，如果你加载一个用函数（参见 string.dump， 结果函数可以有任意数量的上值） 创建出来的二进制代码块时，所有的上值都是新创建出来的。 也就是说它们不会和别的任何函数共享。
chunkname 在错误消息和调试消息中（参见 §4.9），用于代码块的名字。 如果不提供此参数，它默认为字符串chunk 。 chunk 不是字符串时，则为 "=(load)" 
字符串 mode 用于控制代码块是文本还是二进制（即预编译代码块）。 它可以是字符串 "b" （只能是二进制代码块）， "t" （只能是文本代码块）， 或 "bt" （可以是二进制也可以是文本）。 默认值为 "bt"。
Lua 不会对二进制代码块做健壮性检查。 恶意构造一个二进制块有可能把解释器弄崩溃。
}

lua(基础函数:loadfile){
和 load 类似， 不过是从文件 filename 或标准输入（如果文件名未提供）中获取代码块。
}

lua(基础函数:next){
next (table [, index])
    运行程序来遍历表中的所有域。 第一个参数是要遍历的表，第二个参数是表中的某个键。 next 返回该键的
下一个键及其关联的值。 如果用 nil 作为第二个参数调用 next 将返回初始键及其关联值。 当以最后一个
键去调用，或是以 nil 调用一张空表时， next 返回 nil。 如果不提供第二个参数，将认为它就是 nil。 
特别指出，你可以用 next(t) 来判断一张表是否是空的。
    索引在遍历过程中的次序无定义， 即使是数字索引也是这样。 （如果想按数字次序遍历表，可以使用数字形式的 for 。）
    当在遍历过程中你给表中并不存在的域赋值， next 的行为是未定义的。 然而你可以去修改那些已存在的域。 特别指出，
你可以清除一些已存在的域。
}


lua(基础函数:pairs){
如果 t 有元方法 __pairs， 以 t 为参数调用它，并返回其返回的前三个值。
否则，返回三个值：next 函数， 表 t，以及 nil。 因此以下代码
     for k,v in pairs(t) do body end
能迭代表 t 中的所有键值对。
}

lua(基础函数:pcall){
pcall (f [, arg1, ···])
传入参数，以 保护模式 调用函数 f 。 这意味着 f 中的任何错误不会抛出； 取而代之的是，pcall 会将错误捕获到，并返回一个状态码。 第一个返回值是状态码（一个布尔量）， 当没有错误时，其为真。 此时，pcall 同样会在状态码后返回所有调用的结果。 在有错误时，pcall 返回 false 加错误消息。
}

lua(基础函数:print){
print (···)
接收任意数量的参数，并将它们的值打印到 stdout。 它用 tostring 函数将每个参数都转换为字符串。 print 不用于做格式化输出。仅作为看一下某个值的快捷方式。 
多用于调试。 完整的对输出的控制，请使用 string.format 以及 io.write。
}

lua(基础函数:rawequal){
rawequal (v1, v2)
在不触发任何元方法的情况下 检查 v1 是否和 v2 相等。 返回一个布尔量。
}

lua(基础函数:rawget){
rawget (table, index)
在不触发任何元方法的情况下 获取 table[index] 的值。 table 必须是一张表； index 可以是任何值。
}

lua(基础函数:rawlen){
rawlen (v)
在不触发任何元方法的情况下 返回对象 v 的长度。 v 可以是表或字符串。 它返回一个整数。
}

lua(基础函数:rawset){
rawset (table, index, value)
在不触发任何元方法的情况下 将 table[index] 设为 value。 table 必须是一张表， index 可以是 nil 与 NaN 之外的任何值。 value 可以是任何 Lua 值。
这个函数返回 table。
}

lua(基础函数:select){
select (index, ···)
如果 index 是个数字， 那么返回参数中第 index 个之后的部分； 负的数字会从后向前索引（-1 指最后一个参数）。 否则，index 必须是字符串 "#"， 此时 select 返回参数的个数。
}

lua(基础函数:setmetatable){
setmetatable (table, metatable)
给指定表设置元表。 （你不能在 Lua 中改变其它类型值的元表，那些只能在 C 里做。） 如果 metatable 是 nil， 
将指定表的元表移除。 如果原来那张元表有 "__metatable" 域，抛出一个错误。
这个函数返回 table。
}

lua(基础函数:tonumber){
如果调用的时候没有 base， tonumber 尝试把参数转换为一个数字。 如果参数已经是一个数字，或是一个可以转换为数字的字符串， tonumber 就返回这个数字； 否则返回 nil。
字符串的转换结果可能是整数也可能是浮点数， 这取决于 Lua 的转换文法（参见 §3.1）。 （字符串可以有前置和后置的空格，可以带符号。）
当传入 base 调用它时， e 必须是一个以该进制表示的整数字符串。 进制可以是 2 到 36 （包含 2 和 36）之间的任何整数。 大于 10 进制时，字母 'A' （大小写均可）表示 10 ， 'B' 表示 11，依次到 'Z' 表示 35 。 如果字符串 e 不是该进制下的合法数字， 函数返回 nil。
}

lua(基础函数:tostring){
tostring (v)
可以接收任何类型，它将其转换为人可阅读的字符串形式。 浮点数总被转换为浮点数的表现形式（小数点形式或是指数形式）。 （如果想完全控制数字如何被转换，可以使用 string.format。）
如果 v 有 "__tostring" 域的元表， tostring 会以 v 为参数调用它。 并用它的结果作为返回值。
}

lua(基础函数:type){
type (v)
将参数的类型编码为一个字符串返回。 函数可能的返回值有 "nil" （一个字符串，而不是 nil 值）， "number"， "string"， "boolean"， "table"， "function"， "thread"， "userdata"。
}

lua(基础函数:xpcall){
xpcall (f, msgh [, arg1, ···])
这个函数和 pcall 类似。 不过它可以额外设置一个消息处理器 msgh。
}

lua(字符串处理){
string.byte (s [, i [, j]])
string.char (···)
string.dump (function [, strip])
string.find (s, pattern [, init [, plain]])
string.format (formatstring, ···)
string.gmatch (s, pattern)
string.gsub (s, pattern, repl [, n])
string.len (s)
string.lower (s)
string.match (s, pattern [, init])
string.pack (fmt, v1, v2, ···)
string.packsize (fmt)
string.rep (s, n [, sep])
string.reverse (s)
string.sub (s, i [, j])
string.unpack (fmt, s [, pos])
string.upper (s)
}

string(匹配模式){
字符类 用于表示一个字符集合。 下列组合可用于字符类：

    x: （这里 x 不能是 魔法字符 ^$()%.[]*+-? 中的一员） 表示字符 x 自身。
    .: （一个点）可表示任何字符。
    %a: 表示任何字母。
    %c: 表示任何控制字符。
    %d: 表示任何数字。
    %g: 表示任何除空白符外的可打印字符。
    %l: 表示所有小写字母。
    %p: 表示所有标点符号。
    %s: 表示所有空白字符。
    %u: 表示所有大写字母。
    %w: 表示所有字母及数字。
    %x: 表示所有 16 进制数字符号。
    %x: （这里的 x 是任意非字母或数字的字符） 表示字符 x。 这是对魔法字符转义的标准方法。 所有非字母或数字的字符 （包括所有标点，也包括非魔法字符） 都可以用前置一个 '%' 放在模式串中表示自身。
    [set]: 表示 set　中所有字符的联合。 可以以 '-' 连接，升序书写范围两端的字符来表示一个范围的字符集。 上面提到的 %x 形式也可以在 set 中使用 表示其中的一个元素。 其它出现在 set 中的字符则代表它们自己。 例如，[%w_] （或 [_%w]） 表示所有的字母数字加下划线）， [0-7] 表示 8 进制数字， [0-7%l%-]　表示 8 进制数字加小写字母与 '-' 字符。

    交叉使用类和范围的行为未定义。 因此，像 [%a-z] 或 [a-%%] 这样的模式串没有意义。
    [^set]: 表示 set 的补集， 其中 set 如上面的解释。

所有单个字母表示的类别（%a，%c，等）， 若将其字母改为大写，均表示对应的补集。 例如，%S 表示所有非空格的字符。

如何定义字母、空格、或是其他字符组取决于当前的区域设置。 特别注意：[a-z]　未必等价于 %l 。
模式条目：

模式条目 可以是

    单个字符类匹配该类别中任意单个字符；
    单个字符类跟一个 '*'， 将匹配零或多个该类的字符。 这个条目总是匹配尽可能长的串；
    单个字符类跟一个 '+'， 将匹配一或更多个该类的字符。 这个条目总是匹配尽可能长的串；
    单个字符类跟一个 '-'， 将匹配零或更多个该类的字符。 和 '*' 不同， 这个条目总是匹配尽可能短的串；
    单个字符类跟一个 '?'， 将匹配零或一个该类的字符。 只要有可能，它会匹配一个；
    %n， 这里的 n 可以从 1 到 9； 这个条目匹配一个等于 n 号捕获物（后面有描述）的子串。
    %bxy， 这里的 x 和 y 是两个明确的字符； 这个条目匹配以 x 开始 y 结束， 且其中 x 和 y 保持 平衡 的字符串。 意思是，如果从左到右读这个字符串，对每次读到一个 x 就 +1 ，读到一个 y 就 -1， 最终结束处的那个 y 是第一个记数到 0 的 y。 举个例子，条目 %b() 可以匹配到括号平衡的表达式。
    %f[set]， 指 边境模式； 这个条目会匹配到一个位于 set 内某个字符之前的一个空串， 且这个位置的前一个字符不属于 set 。 集合 set 的含义如前面所述。 匹配出的那个空串之开始和结束点的计算就看成该处有个字符 '\0' 一样。

模式：

模式 指一个模式条目的序列。 在模式最前面加上符号 '^' 将锚定从字符串的开始处做匹配。 在模式最后面加上符号 '$' 将使匹配过程锚定到字符串的结尾。 如果 '^' 和 '$' 出现在其它位置，它们均没有特殊含义，只表示自身。
捕获：

模式可以在内部用小括号括起一个子模式； 这些子模式被称为 捕获物。 当匹配成功时，由 捕获物 匹配到的字符串中的子串被保存起来用于未来的用途。 捕获物以它们左括号的次序来编号。 例如，对于模式 "(a*(.)%w(%s*))" ， 字符串中匹配到 "a*(.)%w(%s*)" 的部分保存在第一个捕获物中 （因此是编号 1 ）； 由 "." 匹配到的字符是 2 号捕获物， 匹配到 "%s*" 的那部分是 3 号。

作为一个特例，空的捕获 () 将捕获到当前字符串的位置（它是一个数字）。 例如，如果将模式 "()aa()" 作用到字符串 "flaaap" 上，将产生两个捕获物： 3 和 5 。
}

string(打包和解包用到的格式串){
用于 string.pack， string.packsize， string.unpack 的第一个参数。 它是一个描述了需要创建或读取的结构之布局。

格式串是由转换选项构成的序列。 这些转换选项列在后面：

    <: 设为小端编码
    >: 设为大端编码
    =: 大小端遵循本地设置
    ![n]: 将最大对齐数设为 n （默认遵循本地对齐设置）
    b: 一个有符号字节 (char)
    B: 一个无符号字节 (char)
    h: 一个有符号 short （本地大小）
    H: 一个无符号 short （本地大小）
    l: 一个有符号 long （本地大小）
    L: 一个无符号 long （本地大小）
    j: 一个 lua_Integer
    J: 一个 lua_Unsigned
    T: 一个 size_t （本地大小）
    i[n]: 一个 n 字节长（默认为本地大小）的有符号 int
    I[n]: 一个 n 字节长（默认为本地大小）的无符号 int
    f: 一个 float （本地大小）
    d: 一个 double （本地大小）
    n: 一个 lua_Number
    cn: n字节固定长度的字符串
    z: 零结尾的字符串
    s[n]: 长度加内容的字符串，其长度编码为一个 n 字节（默认是个 size_t） 长的无符号整数。
    x: 一个字节的填充
    Xop: 按选项 op 的方式对齐（忽略它的其它方面）的一个空条目
    ' ': （空格）忽略

（ "[n]" 表示一个可选的整数。） 除填充、空格、配置项（选项 "xX <=>!"）外， 每个选项都关联一个参数（对于 string.pack） 或结果（对于 string.unpack）。

对于选项 "!n", "sn", "in", "In", n 可以是 1 到 16 间的整数。 所有的整数选项都将做溢出检查； string.pack 检查提供的值是否能用指定的字长表示； string.unpack 检查读出的值能否置入 Lua 整数中。

任何格式串都假设有一个 "!1=" 前缀， 即最大对齐为 1 （无对齐）且采用本地大小端设置。

对齐行为按如下规则工作： 对每个选项，格式化时都会填充一些字节直到数据从一个特定偏移处开始， 这个位置是该选项的大小和最大对齐数中较小的那个数的倍数； 这个较小值必须是 2 个整数次方。 选项 "c" 及 "z" 不做对齐处理； 选项 "s" 对对齐遵循其开头的整数。
}

table(){
table.concat (list [, sep [, i [, j]]])
table.insert (list, [pos,] value)
table.move (a1, f, e, t [,a2])
table.pack (···)
table.remove (list [, pos])
table.sort (list [, comp])
table.unpack (list [, i [, j]])
}

io(){
io.close ([file])
io.flush ()
io.input ([file])
io.lines ([filename ···])
io.open (filename [, mode])
这个函数用字符串 mode 指定的模式打开一个文件。 返回新的文件句柄。 当出错时，返回 nil 加错误消息。

mode 字符串可以是下列任意值：

    "r": 读模式（默认）；
    "w": 写模式；
    "a": 追加模式；
    "r+": 更新模式，所有之前的数据都保留；
    "w+": 更新模式，所有之前的数据都删除；
    "a+": 追加更新模式，所有之前的数据都保留，只允许在文件尾部做写入。

mode 字符串可以在最后加一个 'b' ， 这会在某些系统上以二进制方式打开文件。
io.output ([file])
io.popen (prog [, mode])
io.read (···)
io.tmpfile ()
io.type (obj)
io.write (···)

file:close ()
file:flush ()
file:lines (···)
file:read (···)
读文件 file， 指定的格式决定了要读什么。 对于每种格式，函数返回读出的字符对应的字符串或数字。 若不能以该格式对应读出数据则返回 nil。 （对于最后这种情况， 函数不会读出后续的格式。） 当调用时不传格式，它会使用默认格式读下一行（见下面描述）。

提供的格式有

    "n": 读取一个数字，根据 Lua 的转换文法，可能返回浮点数或整数。 （数字可以有前置或后置的空格，以及符号。） 只要能构成合法的数字，这个格式总是去读尽量长的串； 如果读出来的前缀无法构成合法的数字 （比如空串，"0x" 或 "3.4e-"）， 就中止函数运行，返回 nil。
    "i": 读取一个整数，返回整数值。
    "a": 从当前位置开始读取整个文件。 如果已在文件末尾，返回空串。
    "l": 读取一行并忽略行结束标记。 当在文件末尾时，返回 nil 这是默认格式。
    "L": 读取一行并保留行结束标记（如果有的话）， 当在文件末尾时，返回 nil。
    number: 读取一个不超过这个数量字节数的字符串。 当在文件末尾时，返回 nil。 如果 number 为零， 它什么也不读，返回一个空串。 当在文件末尾时，返回 nil。
    
    
file:seek ([whence [, offset]])
设置及获取基于文件开头处计算出的位置。 设置的位置由 offset 和 whence 字符串 whence 指定的基点决定。基点可以是：

    "set": 基点为 0 （文件开头）；
    "cur": 基点为当前位置了；
    "end": 基点为文件尾；

当 seek 成功时，返回最终从文件开头计算起的文件的位置。 当 seek 失败时，返回 nil 加上一个错误描述字符串。

whence 的默认值是 "cur"， offset 默认为 0 。 因此，调用 file:seek() 可以返回文件当前位置，并不改变它； 调用 file:seek("set") 将位置设为文件开头（并返回 0）； 调用 file:seek("end") 将位置设到文件末尾，并返回文件大小。


file:setvbuf (mode [, size])
设置输出文件的缓冲模式。 有三种模式：
    "no": 不缓冲；输出操作立刻生效。
    "full": 完全缓冲；只有在缓存满或当你显式的对文件调用 flush（参见 io.flush） 时才真正做输出操作。
    "line": 行缓冲； 输出将到每次换行前， 对于某些特殊文件（例如终端设备）缓冲到任何输入前。
对于后两种情况，size 以字节数为单位 指定缓冲区大小。 默认会有一个恰当的大小。

file:write (···)
将参数的值逐个写入 file。 参数必须是字符串或数字。
成功时，函数返回 file。 否则返回 nil 加错误描述字符串。
}

require(){
包管理库提供了从 Lua 中加载模块的基础库。 只有一个导出函数直接放在全局环境中： require。 所有其它的部分都导出在表
 package 中。

require (modname)
加载一个模块。 这个函数首先查找 package.loaded 表， 检测 modname 是否被加载过。 如果被加载过，require 返回 
package.loaded[modname] 中保存的值。 否则，它试着为模块寻找加载器 。
}

package(){
package.path    # 这个路径被 require 在 Lua 加载器中做搜索时用到。
                # 在启动时，Lua 用环境变量 LUA_PATH_5_3 或环境变量 LUA_PATH 来初始化这个变量。 
                # 或采用 luaconf.h 中的默认路径。 环境变量中出现的所有 ";;" 都会被替换成默认路径。
package.cpath   # 这个路径被 require 在 C 加载器中做搜索时用到。
                # Lua 用和初始化 Lua 路径 package.path 相同的方式初始化 C 路径 package.cpath 。 
                # 它会使用环境变量 LUA_CPATH_5_3 或 环境变量 LUA_CPATH 初始化。 
                # 要么就采用 luaconf.h 中定义的默认路径。
package.loaded  # 用于 require 控制哪些模块已经被加载的表。 当你请求一个 modname 模块，且 package.loaded[modname] 不为假时， require 简单返回储存在内的值。
                # 这个变量仅仅是对真正那张表的引用； 改变这个值并不会改变 require 使用的表。
package.preload # 保存有一些特殊模块的加载器 （参见 require）。
                # 这个变量仅仅是对真正那张表的引用； 改变这个值并不会改变 require 使用的表。
package config  # 一个描述有一些为包管理准备的编译期配置信息的串。 这个字符串由一系列行构成：
    # 第一行是目录分割串。 对于 Windows 默认是 '\' ，对于其它系统是 '/' 。
    # 第二行是用于路径中的分割符。默认值是 ';' 。
    # 第三行是用于标记模板替换点的字符串。 默认是 '?' 。
    # 第四行是在 Windows 中将被替换成执行程序所在目录的路径的字符串。 默认是 '!' 。
    # 第五行是一个记号，该记号之后的所有文本将在构建 luaopen_ 函数名时被忽略掉。 默认是 '-'。
package.loadlib (libname, funcname) # 让宿主程序动态链接 C 库 libname 。
    当 funcname 为 "*"， 它仅仅连接该库，让库中的符号都导出给其它动态链接库使用。 否则，它查找库中的函数 funcname ，
以 C 函数的形式返回这个函数。 因此，funcname 必须遵循原型 lua_CFunction （参见 lua_CFunction）。
    这是一个低阶函数。 它完全绕过了包模块系统。 和 require 不同， 它不会做任何路径查询，也不会自动加扩展名。 
libname 必须是一个 C 库需要的完整的文件名，如果有必要，需要提供路径和扩展名。 funcname 必须是 C 库需要的
准确名字 （这取决于使用的 C 编译器和链接器）。
    这个函数在标准 C 中不支持。 因此，它只在部分平台有效 （ Windows ，Linux ，Mac OS X, Solaris, BSD, 加上支持
dlfcn 标准的 Unix 系统）。

}

lua(C 包){
Lua和C是很容易结合的，使用C为Lua写包。

与Lua中写包不同，C包在使用以前必须首先加载并连接，在大多数系统中最容易的实现方式是通过动态连接库机制。

Lua在一个叫loadlib的函数内提供了所有的动态连接的功能。这个函数有两个参数:库的绝对路径和初始化函数。所以典型的调用的例子如下:

local path = "/usr/local/lua/lib/libluasocket.so"
local f = loadlib(path, "luaopen_socket")

loadlib函数加载指定的库并且连接到Lua，然而它并不打开库（也就是说没有调用初始化函数），反之他返回初始化函数作为Lua的一个函数，这样我们就可以直接在Lua中调用他。

如果加载动态库或者查找初始化函数时出错，loadlib将返回nil和错误信息。我们可以修改前面一段代码，使其检测错误然后调用初始化函数：

local path = "/usr/local/lua/lib/libluasocket.so"
-- 或者 path = "C:\\windows\\luasocket.dll"，这是 Window 平台下
local f = assert(loadlib(path, "luaopen_socket"))
f()  -- 真正打开库

一般情况下我们期望二进制的发布库包含一个与前面代码段相似的stub文件，安装二进制库的时候可以随便放在某个目录，只需要修改stub文件对应二进制库的实际路径即可。

将stub文件所在的目录加入到LUA_PATH，这样设定后就可以使用require函数加载C库了。

}

lua(加载机制){
对于自定义的模块，模块文件不是放在哪个文件目录都行，函数 require 有它自己的文件路径加载策略，它会尝试从 Lua 文件或 C 程序库中加载模块。

require 用于搜索 Lua 文件的路径是存放在全局变量 package.path 中，当 Lua 启动后，会以环境变量 LUA_PATH 的值来初始这个环境变量。如果没有找到该环境变量，则使用一个编译时定义的默认路径来初始化。

当然，如果没有 LUA_PATH 这个环境变量，也可以自定义设置，在当前用户根目录下打开 .profile 文件（没有则创建，打开 .bashrc 文件也可以），例如把 "~/lua/" 路径加入 LUA_PATH 环境变量里：

#LUA_PATH
export LUA_PATH="~/lua/?.lua;;"

文件路径以 ";" 号分隔，最后的 2 个 ";;" 表示新加的路径后面加上原来的默认路径。

接着，更新环境变量参数，使之立即生效。

source ~/.profile

这时假设 package.path 的值是：

/Users/dengjoe/lua/?.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua

那么调用 require("module") 时就会尝试打开以下文件目录去搜索目标。

/Users/dengjoe/lua/module.lua;
./module.lua
/usr/local/share/lua/5.1/module.lua
/usr/local/share/lua/5.1/module/init.lua
/usr/local/lib/lua/5.1/module.lua
/usr/local/lib/lua/5.1/module/init.lua

如果找过目标文件，则会调用 package.loadfile 来加载模块。否则，就会去找 C 程序库。

搜索的文件路径是从全局变量 package.cpath 获取，而这个变量则是通过环境变量 LUA_CPATH 来初始。

搜索的策略跟上面的一样，只不过现在换成搜索的是 so 或 dll 类型的文件。如果找得到，那么 require 就会通过 package.loadlib 来加载它。
}