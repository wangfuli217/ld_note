print("false==nil", false==nil) -- although they represent the same thing they are not equivalent
print('true==false, true~=false', true==false, true~=false)
print('1==0', 1==0)

-- not
print('true, false, not true, not false', true, false, not true, not false)
print('not nil', not nil) -- nil represents false
print('not not true', not not true) -- true is not not true!
print('not "foo"', not "foo") -- anything not false or nil is true

-- and
print("false and true", false and true)
print("nil and true", nil and true)
print("nil and false", nil and false)
print("false and nil", false and nil)
print('nil and "hello", false and "hello"', nil and "hello", false and "hello")

print("true and false", true and false)
print("true and true", true and true)
print('1 and "hello", "hello" and "there"' , 1 and "hello", "hello" and "there")
print("true and nil", true and nil)

-- or
print("true or false", true or false)
print("true or nil", true or nil)
print('"hello" or "there", 1 or 0', "hello" or "there", 1 or 0)

print("false or true", false or true)
print("nil or true", nil or true)
print('nil or "hello"', nil or "hello")

function foo(x)
    local value = x or "default" -- if argument x is false or nil, value becomes "default"
    print(value, x)
end
foo() -- no arguments, so x is nil
foo(1)
foo(true)
foo("hello")

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
print( 3>1 and false or "oops" ) -- failed, should return false
print( 3>1 and nil or "oops" ) -- failed, should return nil

if nil then print("true") else print("false") end
if 1 then print("true") else print("false") end
if 0 then print("true") else print("false") end
if 1==2 then print("true") else print("false") end



