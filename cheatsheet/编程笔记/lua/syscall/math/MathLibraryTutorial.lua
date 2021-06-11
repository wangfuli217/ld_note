-- 
-- math.abs
--
print(math.abs(-100))
print(math.abs(25.67))
print(math.abs(0))

--
-- math.acos , math.asin
--
print(math.acos(1))
print(math.acos(0))
print(math.asin(0))
print(math.asin(1))


-- 
-- math.atan
--
c, s = math.cos(0.8), math.sin(0.8)
print(math.atan(s/c))
print(math.atan(s,c))
print(math.atan(1, 0), math.atan(-1, 0), math.atan(0, 1), math.atan(0, -1))

-- 
-- math.ceil , math.floor
--
print("math.floor(0.5)", "math.ceil(0.5)")
print(math.floor(0.5), math.ceil(0.5))
print("math.floor(-0.5)", "math.ceil(-0.5)")
print(math.floor(-0.5), math.ceil(-0.5))

--
-- math.min , math.max
--
print("math.min(1,2)")
print(math.min(1,2))
print("math.min(1.2, 7, 3)")
print(math.min(1.2, 7, 3))
print("math.min(1.2, -7, 3)")
print(math.min(1.2, -7, 3))
print("math.max(1.2, -7, 3)")
print(math.max(1.2, -7, 3))
print("math.max(1.2, 7, 3)")
print(math.max(1.2, 7, 3))

-- 
-- math.modf
--
print("math.modf(5)")
print(math.modf(5))
print("math.modf(5.3)")
print(math.modf(5.3))
print("math.modf(-5.3)")
print(math.modf(-5.3))

-- math.random() with no arguments generates a real number between 0 and 1.
-- math.random(upper) generates integer numbers between 1 and upper (both inclusive).
-- math.random(lower, upper) generates integer numbers between lower and upper (both inclusive).
print("math.random()")
print(math.random())
print("math.random()")
print(math.random())

print("math.random(100)")
print(math.random(100))
print("math.random(100)")
print(math.random(100))
-- upper and lower must be integer
print("math.random(70,80)")
print(math.random(70,80))
print("math.random(70,80)")
print(math.random(70,80))

-- Equal seeds produce equal sequences of numbers.
print(math.randomseed(1234))
print(math.random(), math.random(), math.random())
print(math.randomseed(1234))
print(math.random(), math.random(), math.random())

-- math.randomseed( os.time() )
math.randomseed( os.time() )
math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
-- lrandom http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/#lrandom


print("math.huge", "math.huge / 2", "-math.huge", "math.huge/math.huge", "math.huge * 0 ", "1/0", "(math.huge == math.huge)", "(1/0 == math.huge)")
print(math.huge, math.huge / 2, -math.huge, math.huge/math.huge, math.huge * 0 , 1/0, (math.huge == math.huge), (1/0 == math.huge))

print("type(math.huge * 0)")
print(type(math.huge * 0))



