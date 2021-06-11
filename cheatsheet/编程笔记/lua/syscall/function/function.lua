--
-- Function defination
-- 
-- function ( args ) body end
foo = function (n) return n*2 end
print(foo(7))

-- Lua functions are considered anonymous (no pre-set name), and 
-- first-class (not treated differently from other values).
-- tables, functions are passed by reference

--
-- Function arguments
-- 

f = function (op, a, b) -- anonymous
  if op == 'add' then
   return a + b
  elseif op == 'sub' then
   return a - b
  end
  error("invalid operation")
end

g = function (value) -- anonymous
  print(value)
end
print(f('add', 1, 2)) -- args are given inside (), separated by commas.         -- 3

print(f('add', 1, 2, 123)) -- extra args are ignored                            -- 3

status, message = pcall(f, 'add', 1)
print("f('add', 1)", status, message)

print(g()) -- to call a function with no args, use ()                           -- nil

g "example" -- the () can be omitted if you have one quoted string arg          -- example

g {} -- same with one table constructor                                         -- table: 0x820ee0

--
-- Function return values
-- 
f = function ()
 return "x", "y", "z" -- return 3 values
end
a, b, c, d = f() -- assign the 3 values to 4 variables. the 4th variable will be filled with nil
print(a, b, c, d) -- x y z nil

a, b = (f()) -- wrapping a function call in () discards multiple return values
print(a, b)  -- x, nil

print("w"..f()) -- using a function call as a sub-expression discards multiple returns 
-- wx

print(f(), "w") -- same when used as the arg for another function call...
-- x w

print("w", f()) -- ...except when it's the last arg
-- w x y z

print("w", (f())) -- wrapping in () also works here like it does with =
-- w x
t = {f()} -- multiple returns can be stored in a table
print(t[1], t[2], t[3]) -- x y z


--
-- Return skips other code
-- 
function f(switch)
  
  if not switch then --if switch is nil, function f() will not complete anything else below Return
    return
  end
  
  print("Hello") 
end

print(f())  --doesn't print anything
function f(switch)
  
  if not switch then --switch is no longer nil but is instead "1"
    return
  end
  
  print("Hello") 
end

print(f(1)) --prints "hello"

--
-- Using functions as parameters and returns
-- 
list = {{3}, {5}, {2}, {-1}}
table.sort(list, function (a, b) return a[1] < b[1] end)
for i,v in ipairs(list) do print(v[1]) end

status, message = pcall(table.sort, list)
print("table.sort, list", status, message)


--
-- Variable number of arguments
-- 
f = function (x, ...)
  x(...)
 end
f(print, "1 2 3")

 f=function(...) 
   print(select("#", ...)) 
   print(select(3, ...)) 
 end
f(1, 2, 3, 4, 5)

-- packed into a table
f=function(...) tbl={...} print(tbl[2]) end
f("a", "b", "c")

-- f=function(...) tbl={...} print(table.unpack(tbl)) end -- it's just "unpack" (without the table.) in 5.1
-- f("a", "b", "c")
-- f("a", nil, "c") -- undefined result, may or may not be what you expect

--
-- Syntax shortcut for "named" functions
-- 
function f(...)
end
-- is equivalent to:
f = function (...)
end

function a.b.f(...)
end
-- is equivalent to:
a.b.f = function (...)
end
