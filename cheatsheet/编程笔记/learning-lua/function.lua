function max(a, b) --定义函数max，用来求两个数的最大值，并返回
local temp = nil --使用局部变量temp，保存最大值
if (a > b) then
    temp = a
else
    temp = b
end
return temp --返回最大值
end

local m = max(-12, 20) --调用函数max，找去-12和20中的最大值
print(m) -->output 20

function func() --形参为空
print("no parameter")
end

func() --函数调用，圆扩号不能省

function swap(a, b) --定义函数swap,函数内部进行交换两个变量的值
local temp = a
a = b
b = temp
print(a, b)
end

local x = "hello"
local y = 20
print(x, y)
swap(x, y) --调用swap函数
print(x, y) --调用swap函数后，x和y的值并没有交换

function fun1(a, b) --两个形参，多余的实参被忽略掉
print(a, b)
end

function fun2(a, b, c, d) --四个形参，没有被实参初始化的形参，用nil初始化
print(a, b, c, d)
end

local x = 1
local y = 2
local z = 3

fun1(x, y, z) -- z被函数fun1忽略掉了，参数变成 x, y

fun2(x, y, z) -- 后面自动加上一个nil，参数变成 x, y, z, nil

-- 变长参数
function func(...) --形参为 ... ,表示函数采用变长参数

local temp = { ... } --访问的时候也要使用 ...
local ans = table.concat(temp, "-") --使用table.concat库函数，对数组内容使用" "拼接成字符串。
print(ans)
end

func(1, 2) --传递了两个参数
func(1, 2, 3, 4) --传递了四个参数

-- 具名参数
function change(arg) --change函数，改变长方形的长和宽，使其各增长一倍
arg.width = arg.width * 2
arg.height = arg.height * 2
return arg
end

local rectangle = { width = 20, height = 15 }
print("before change:", "width =", rectangle.width, "height =", rectangle.height)
rectangle = change(rectangle)
print("after change:", "width =", rectangle.width, "height =", rectangle.height)

-- 按址传递
function change(arg) --change函数，改变长方形的长和宽，使其各增长一倍
arg.width = arg.width * 2 --表arg不是表rectangle的拷贝，他们是同一个表
arg.height = arg.height * 2
end

--没有return语句了

local rectangle = { width = 20, height = 15 }
print("before change:", "width =", rectangle.width, "height =", rectangle.height)
change(rectangle)
print("after change:", "width =", rectangle.width, "height =", rectangle.height)

-- 多返回值
local s, e = string.find("hello world", "llo")
print(s, e) -->output 3  5

function swap(a, b) --定义函数swap，实现两个变量交换值
return b, a --按相反顺序返回变量的值
end

local x = 1
local y = 20
x, y = swap(x, y) --调用swap函数
print(x, y) -->output   20     1

-- 自动调整
function init() --init函数 返回两个值 1和"lua"
return 1, "lua"
end

x = init()
print(x)

x, y, z = init()
print(x, y, z)

function init() --init函数 返回两个值 1和"lua"
return 1, "lua"
end

local x, y, z = init(), 2 --init函数的位置不在最后，此时只返回 1
print(x, y, z) -->output  1  2  nil

local a, b, c = 2, init() --init函数的位置在最后，此时返回 1 和 "lua"
print(a, b, c) -->output  2  1  lua

-- callback
local function run(x, y)
    print('run', x, y)
end

local function attack(targetId)
    print('targetId', targetId)
end

local function doAction(method, ...)
    local args = {...} or {}
    method(unpack(args, 1, table.maxn(args)))
end

doAction(run, 1, 2)
doAction(attack, 1111)