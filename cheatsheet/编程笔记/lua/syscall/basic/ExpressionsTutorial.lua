--
-- Arithmetic expressions
--
-- binary arithmetic operators.
print("2+3, 5-12, 2*7, 7/8")
print(2+3, 5-12, 2*7, 7/8)

print("5*(2-8.3)/77.7+99.1")
print(5*(2-8.3)/77.7+99.1)

-- Unary negation
print("-(-10), -(10)")
print(-(-10), -(10))

-- Modulo (division remainder):
print("15%7, -4%3, 5.5%1")
print(15%7, -4%3, 5.5%1)

-- Power of
print("7^2, 107^0, 2^8")
print(7^2, 107^0, 2^8)

--
-- Relational expressions
--
-- number
print(1 == 1, 1 == 0)   -- true    false
print(1 ~= 1, 1 ~= 0)   -- false   true
print(3 < 7, 7 < 7, 8 < 7)  -- true false   false
print(3 > 7, 7 > 7, 8 > 7)  -- false    false   true
print(3 <= 7, 7 <= 7, 8 <= 7)   -- true    true    false
print(3 >= 7, 7 >= 7, 8 >= 7)   -- false   true    true

-- string
print("abc" < "def")    -- true
print("abc" > "def")    -- false
print("abc" == "abc")   -- true
print("abc" == "a".."bc")   -- true

-- table
print({} == "table")    -- false
print({} == {})         -- false
t = {}
t2 = t
print(t == t2)  -- true

-- Coercion 
print("10" == 10)   -- false
print(tonumber("10") == 10) -- true

--
-- Logical operators
--
-- false != nil  true != 1 false != 0
print(false==nil)   -- although they represent the same thing they are not equivalent
print(true==false, true~=false) -- false true
print(1==0)         -- false

print(true, false, not true, not false) -- true    false   false   true
print(not nil)  -- true
print(not not true )    -- true
print(not "foo")    -- false

--
-- and
--
print(false and true)   -- false is returned because it is the first argument
print(nil and true)     -- nil
print(nil and false)    -- nil
print(nil and "hello", false and "hello")   -- nil     false

print(true and false)   -- false
print(true and true)    -- true
print(1 and "hello", "hello" and "there")   -- hello   there
print(true and nil) -- nil

-- 
-- or
--
print(true or false)    -- true
print(true or nil)      -- true
print("hello" or "there", 1 or 0)   -- hello 1

print(false or true)    -- true
print(nil or true)      -- true
print(nil or "hello")   -- hello

function foo(x)
    local value = x or "default"
    print(value)
end

--
-- value = test ? x : y;
-- value = test and x or y

print( 3>1 and 1 or 0 )
print( 3<1 and 1 or 0 )
print( 3<1 and "True" or "False" )
print( 3>1 and true or "false" )


t = {}
t[1] = 12;
t[2] = 13;
for i=1, 3 do
 t[i] = (t[i] or 0) + 1
end

for k, v in pairs(t) do
  print(k, v);
end

print( 3>1 and 1 or "False" )        -- works
print( 3>1 and false or "oops" )     -- failed, should return false
print( 3>1 and nil or "oops" )       -- failed, should return nil

if (0) then
  print("true")
else
  print("false")
end

if false then print("true") else print("false") end
if nil then print("true") else print("false") end

function numtest()
    return 1 + true
end

status, msg = pcall(numtest)
print("1+true", status, msg)

