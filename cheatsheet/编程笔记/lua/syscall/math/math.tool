-- 数字最大值
print("\nmath.huge = "..math.huge)
if 99999999 < math.huge then
    print("math.huge test")
end

print("math.huge", math.huge)
print("math.huge / 2", math.huge / 2)
print("-math.huge", -math.huge)
print("math.huge/math.huge", math.huge/math.huge)
print("math.huge * 0", math.huge * 0)
print("1/0", 1/0)
print("math.huge == math.huge", math.huge == math.huge)
print("1/0 == math.huge", 1/0 == math.huge)
print("type(math.huge * 0)", type(math.huge * 0))

-- 绝对值
print("\nmath.abs(3) = ",math.abs(3))
print("math.abs(-3) = ",math.abs(-3))
print("math.abs(25.67) = ",math.abs(25.67))
print("math.abs(0) = ", math.abs(0))

-- Return the integer no greater than or no less than the given value (even for negatives).
x = 3.1                                                                         -- 向上取整 -- 向正无穷取整  
print("\nmath.ceil(x) = ", math.ceil(x))
print('math.ceil(3.3)  =', math.ceil(3.3))
print('math.ceil(-3.3) =', math.ceil(-3.3))

x = 3.9                                                                         -- 向下取整 -- 向负无穷取整 
print("\nmath.floor(x) = "..math.floor(x))
print('math.floor(3.3)  =', math.floor(3.3))
print('math.floor(-3.3) =', math.floor(-3.3))
print('math.floor(2^70) =', math.floor(2^70))
--[[
  如果想将数组x向最近的整数取整，可以对x+0.5调用floor函数。不过，当参数是一个很大的整数时，
简单的加法可能会导致错误。例如考虑如下代码：
2^52 + 1.5 的浮点数表示是不准确的，因此内部会以我们不可控制的方式取整，为了避免这个问题，
我们可以单独地处理整数值：
--]]
x = 2^52 +1
print(string.format("%d %d", x, math.floor(x + 0.5)))

function round(x)
  local f = math.floor(x)
  if (x == f) or (x%2.0 == 0.5) then
    return f
  else
    return math.floor(x + 0.5)
  end
end
print('math.floor(3.5+0.5) =', math.floor(3.5+0.5))
print('math.floor(2.5+0.5) =', math.floor(2.5+0.5))
print('round(2.5) = ', round(2.5))
print('round(3.5) = ', round(3.5))
print('round(-2.5) = ', round(-2.5))
print('round(-1.5) = ', round(-1.5))

-- 求余数
x = 3
local y = 5
print("\nmath.fmod("..x..", "..y..") = "..math.fmod(x, y))
y = -5
print("math.fmod("..x..", "..y..") = "..math.fmod(x, y))
x = -3
y = 5
print("math.fmod("..x..", "..y..") = "..math.fmod(x, y))

x = 6.7                                                                         -- 取整数和小数
local zs, xs = math.modf(x)
print("\nmath.modf("..x..") = "..zs..", "..xs)
print('math.modf(3.3)  =', math.modf(3.3))
print('math.modf(-3.3) =', math.modf(-3.3))

x = 3; y = 10; z = 99                                                           -- 最大值
print("\nmath.max("..x..", "..y..", "..z..") = "..math.max(x, y, z))

x = 3; y =-3; z= 32
print("\nmath.min("..x..", "..y..", "..z..") = "..math.min(x, y, z))            -- 最小值


-- 随机数
local m = 8;
local n = 100;
print("\nmath.random() = "..math.random())                                      -- [0,1)之间的随机一个数
print("\nmath.random("..m..") = "..math.random(m))                              -- [1,m] 之间的一个数
print("\nmath.random("..m..", "..n..") = "..math.random(m, n))                  -- [m,n]

--[[
可以设置随机数种子，使得每次调用的随机数会依据种子的不同而产生不同的随机数，可控。
如果不设置随机数，直接使用random函数，会使得每次运行程序得到的随机数为同一个随机数，而加入了随机数种子通过设置不同的种子便可以得到不同的随机数。
通常将随机数种子设置为系统时间是一个不错的选择：math.randomseed(os.time())
--]]
m = 9999;
math.randomseed(100)
print("\nmath.randomseed(100)")
print("math.random("..m..") = "..math.random(m))
print("math.random("..m..") = "..math.random(m))
print("math.random("..m..") = "..math.random(m))

math.randomseed(100)
print("\nmath.randomseed(100)")
print("math.random("..m..") = "..math.random(m))
print("math.random("..m..") = "..math.random(m))
print("math.random("..m..") = "..math.random(m))

math.randomseed(1000)
print("\nmath.randomseed(1000)")
print("math.random("..m..") = "..math.random(m))
print("math.random("..m..") = "..math.random(m))
print("math.random("..m..") = "..math.random(m))

