lua(Nil){
All undeclared or empty variables have a value of nil.

print(x) 
=> nil
local y
print(y) 
=> nil
}

lua(Booleans){
Boolean values are true and false. Anything other than false or nil is considered true. nil is the same as false.

x = true
print(x) 
=> true
y = false
print(y) 
=> false
if(z) then
  print("Yes")
else
  print("No")
end
=> No
}

lua(Numbers){
In Lua all numbers are floating-point numbers. There is no integer.

x = 1
print(x) 
=> 1
y = 1.00
print(y) 
=> 1
z = 1.25
print(z) 
=> 1.25
print(x + z) 
=> 2.25
}

lua(Strings){
a = "abc"
b = a
a = "cba" print(a) -->cba print(b) -->abc

c = 'abc\ndef'            
print(c) -->输出换行了

d = "\97\98c"  #可以通过<转义符“\”+数值>来指定字符串中的字符，数值为最多3位数组成的序列。
print(d) --abc

e = [[it's mine!                         
it's not yours! --'Oh'   --"Wow!!!!"
]]                                      # 可以用一对[[XXX]]来界定一个字符串XXX。字符串可以为任意字符。
print (e)        --输出[[]]里面的所有内容

f = [==[abc[=]defgh[[=]]]==] # 如上的表示有一个bug，就是当字符串包含[[或]]子串的时候，会表达错误。
                             # Lua提供了[===[XXX]===]这样的形式来包含字符串XXX。其中，两边中括号之间的“=”数量要匹配。如：
print(f)        --abc[=]defgh[[=]]

print("5"+6)        --11        # Lua提供运行时数字和字符的自动转换。即一个数字和一个字符串相加，
print("5e-2"+3)        --3.05   # Lua会尝试把这个字符串转换成数字再求值。不需要我们显式转换

print(#"abcd\n")    --5         # 长度操作符'#'，可用于求字符串的长度，即字符串包含的字符数。
str = "abc"
print(#str)            --3      

}

lua(strings:libs){

# string.byte (s [, i [, j]])      # 返回字符串的内部数字编码，i、j为字符串的索引，i、j限定了多少字符就返回多少值。
k1,k2,k3 = string.byte("abcdef",1,3)
print (k1,k2,k3)    --97    98    99

# string.char (···)      # 跟byte()相反，把数字编码转换为字符串。
s = string.char(97,98,99)
print(s) --abc
n = string.char()
print(n) --什么都没输出 print(type(n)) --string print(string.char(string.byte("hello",1,-2))) --hell

# string.dump (function [, strip]) # 用来序列化函数的。传入一个函数，返回一个字符串。通过load该字符串可以反序列化该函数。
function max(a, b)
    return a>b and a or b
end
--序列化
du = string.dump(max)
print(type(du))        --string
print(du)              --LuaQ
--反序列化
max2 = load(du)    
--调用函数
print(max2(1,2))    --2

# string.find (s, pattern [, init [, plain]]) # 用来查找匹配的pattern，返回该pattern的索引。找到一个匹配就返回。
# 如果找不到，返回空。 其中i表示匹配pattern的起始位置，j表示匹配pattern的结束位置。
txt = "it's very very good!"
i ,j = string.find(txt, "very")
print(i,j) --6    9 
i ,j = string.find(txt, "big")
print(i,j) --nil    nil

# string.format (formatstring, ···)  # 格式化字符串。
print(string.format("i want %d apples", 5)) --i want 5 apples

# string.match (s, pattern [, init]) #这个函数与find()函数类似，不同的是，find返回匹配的索引，这个函数返回第一个匹配的内容本身，
txt = "it's very very good!"
i,j = string.match(txt, "very")
print(i,j)    --very   nil
i,j = string.match(txt, "big")
print(i,j)    --nil    nil　

# string.gmatch (s, pattern) # 这个函数基本就是用来配合for循环使用的，返回一个迭代器函数，每次调用这个迭代器函数都会返回一个匹配该字符串的值。
s = "hello world from Lua" 
for w in string.gmatch(s, "%a+") do 
print(w) --连续输出每个单词 
end

# string.gsub (s, pattern, repl [, n]) # 这个函数用来进行字符替换的。将每个匹配的字符串替换成指定的字符串repl。返回替换完毕的字符串和替换的次数。
# 若repl为函数则会用匹配到的参数作为参数调用这个函数，若repl为table，则会用匹配到的参数作为键去查找这个表。
--字符串
print(string.gsub("i have an apple", "apple", "peach"))
--函数
function ff( arg )
    print("function arg : " .. arg)
end
print(string.gsub("my name is qsk", "%a+", ff))
--table
t = {}
metat = {}
metat.__index = function ( table,key )        
    return "!!" .. key
end
setmetatable(t, metat)
print(string.gsub("my name is qsk", "%a+", t))

# string.len (s)、string.lower (s)、string.upper (s)
print(string.len("abcd")) --4 
print(string.lower("MACOS")) --macos 
print(string.upper("12abAB")) --12ABAB

# string.rep (s, n [, sep]) # 将某个字符串自我复制链接起来
print(string.rep("s", 5,"-")) --s-s-s-s-s 
print(string.rep("ab", 5)) --ababababab

# string.reverse (s) # 用来反转字符串，反转字符串中字符的序列。
print(string.reverse("abcdefg"))        --gfedcba

# string.sub (s, i [, j]) # 截取字符串。
print(string.sub("abcdefg", 3,5)) --cde
}

lua(Tables){

x = {'a', 'b', 'c'}  # tables和关联数组类似
print(x[1]) -- a 
y = {name="John", age=21, is_male=true} 
print(y.name) -- John 
print(y["name"]) -- John

# 索引可使用'.', 也可以使用[]的方法，如果索引为变量值，则只能使用[]
i = "name" 
x = {} 
x.name = "John" 
print(x.i) -- nil 
print(x[i]) -- John

x = {'a', 'b', 'c'} 
print(#x) -- 3
}

lua(Tables:libs){

x = "Hello World" 
print(x:find("or")) 
-- 8 9 
print(x:find("zip")) 
-- nil

#一部分的table函数只对其数组部分产生影响, 而另一部分则对整个table均产生影响. 
# table.concat(table, sep,  start, end)
# concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 
# 元素间以指定的分隔符(sep)隔开。除了table外, 其他的参数都不是必须的, 分隔符的默认值是空字符, start的默认值是1, end的默认值是数组部分的总长.
# sep, start, end这三个参数是顺序读入的, 所以虽然它们都不是必须参数, 但如果要指定靠后的参数, 必须同时指定前面的参数.
tbl = {"alpha", "beta", "gamma"}
print(table.concat(tbl, ":")) -- alpha:beta:gamma
print(table.concat(tbl, nil, 1, 2)) --alphabeta
print(table.concat(tbl, "\n", 2, 3)) -- beta 
                                     -- gamma

# table.insert(table, pos, value)
# table.insert()函数在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾.
tbl = {"alpha", "beta", "gamma"}
table.insert(tbl, "delta")
table.insert(tbl, "epsilon")
print(table.concat(tbl, ", ")) -- alpha, beta, gamma, delta, epsilon
table.insert(tbl, 4, "zeta")
print(table.concat(tbl, ", ")) -- alpha, beta, zeta, gamma, delta, epsilon

# table.remove(table, pos)
# table.remove()函数删除并返回table数组部分位于pos位置的元素. 其后的元素会被前移. pos参数可选, 默认为table长度, 即从最后一个元素删起.


# table.sort(table, comp)
# table.sort()函数对给定的table进行升序排序.
local tabLanguage = { 
    "Lua",
    "swift",
    "python",
    "java",
    "c++",
};

print("\nLUA>>>>>>the source elements of table tabLanguage is:")
for k,v in pairs(tabLanguage) do
    print(k,v)
end

-- 使用默认函数排序
table.sort(tabLanguage)
print("\nLUA>>>>>>After sort, the elements of table tabLanguage is:")
for k,v in pairs(tabLanguage) do
    print(k,v)
end

-- 定义自己的比较函数
local function my_comp(element1, elemnet2)
    return string.len(element1) < string.len(elemnet2)
end

-- 使用自己的比较函数排序（按字符由短到长排序）
table.sort(tabLanguage, my_comp)
print("\nLUA>>>>>>After sort using my_comp, the elements of table tabLanguage is:")
for k,v in pairs(tabLanguage) do
    print(k,v)
end

-- 再定义一个自己的比较函数
local function my_comp_new(element1, elemnet2)
    return element1 > elemnet2
end

-- 使用自己的比较函数排序（按字符长段排序）
table.sort(tabLanguage, my_comp_new)
print("\nLUA>>>>>>After sort using my_comp_new, the elements of table tabLanguage is:")
for k,v in pairs(tabLanguage) do
    print(k,v)
end

-- 定义处理nil的函数
local function my_comp_new_with_nil(element1, elemnet2)
    if element1 == nil then
        return false;
    end
    if elemnet2 == nil then
        return true;
    end
    return element1 > elemnet2
end

-- 创造一个空洞
tabLanguage[2] = nil
-- 使用默认函数排序
--table.sort(tabLanguage, my_comp_new_with_nil)
print("\nLUA>>>>>>After sort using my_comp_new_with_nil, the elements of table tabLanguage is:")
for k,v in pairs(tabLanguage) do
    print(k,v)
end


# table.unpack (list [, i [, j]])
# 用于返回 table 里的元素，参数 start 是开始返回的元素位置，默认是 1，参数 end 是返回最后一个元素的位置，
# 默认是 table 最后一个元素的位置，参数 start、end 都是可选
local tbl = {"apple", "pear", "orange", "grape"}
print(table.unpack(tbl))
 
local a, b, c, d = table.unpack(tbl)
print(a, b, c, d)
 
print(table.unpack(tbl, 2))
print(table.unpack(tbl, 2, 3))

# table.pack (···)
返回用所有参数以键 1,2, 等填充的新表， 并将 "n" 这个域设为参数的总数。 注意这张返回的表不一定是一个序列。
t = table.pack("test", "param1", "param2", "param3")
print(t)
}

lua(type){
a = nil
b = true
c = 10
d = "Hello World"
e = {one=1, two=2, three=3}
print(type(a))
-- nil
print(type(b))
-- boolean
print(type(c))
-- number
print(type(d))
--  string
print(type(e))
-- table
}

lua(If Then Else){
x = {
  {fruit="apple", taste="sweet", is_juicy=true},
  {fruit="banana", taste="sweet", is_juicy=false},
  {fruit="lemon", taste="sour", is_juicy=true}
}
if(x[2].taste == "sweet" and x[2].is_juicy) then
  print("This is an apple")
elseif(x[2].taste == "sweet" and not x[2].is_juicy) then
  print("This is a banana")
elseif(x[2].taste == "sour" and x[2].is_juicy) then
  print("This is a lemon")
else
  print("Fruit is unknown")
end

}

lua(Loops){
for i=1, 10 do
  print('Hello World')
end

x = 1
while x <= 10 do
  print('Hello World')
  x = x + 1
end

y = 1
repeat
  print('Hello World')
  y = y + 1
until y > 10

}