--
-- assign
--
a,b,c,d,e,f,g = 1,1.123,1E9,-123,.0008, 0xff,056
print("1,1.123,1E9,-123,.0008, 0xff,056")
print(a,b,c,d,e,f,g)
-- <value>e<exponent>
-- <value>E<exponent>
-- <value> * 10 ^ <exponent>

--
-- The math library
--
--  math.abs     math.acos    math.asin       math.atan    math.atan2
--  math.ceil    math.cos     math.cosh       math.deg     math.exp
--  math.floor   math.fmod    math.frexp      math.ldexp   math.log
--  math.log10   math.max     math.min        math.modf    math.pow
--  math.rad     math.random  math.randomseed math.sin     math.sinh
--  math.sqrt    math.tan     math.tanh
--
print(math.sqrt(101))
print(math.pi)
print(math.sin( math.pi/3 ))

--
-- Conversion
--
num = tonumber("123") + 25
real = tonumber("123.456e5")
print(num, real)

-- 
-- Coercion
-- 
print(100 + "7")
print("1000" + 234)
function numtest()
    return "hello" + 234
end
status, msg = pcall(numtest)
print(status, msg)

print(100 == "100")
print(100 ~= "hello")
print(100 ~= {})
print(100 == tonumber("100"))

function comparetest()
    return 100 <= "100"
end
status, msg = pcall(comparetest)
print(status, msg)
