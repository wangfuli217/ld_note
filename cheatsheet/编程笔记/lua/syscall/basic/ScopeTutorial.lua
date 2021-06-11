--
-- Creating local variables
-- 

local a = 5
a = 6 -- changes the local a, doesn't create a global

local a = 5
print(a) --> 5

do
  local a = 6 -- create a new local inside the do block instead of changing the existing a
  print(a) --> 6
end

print(a) --> 5

function bar()
  print(x) --> nil
  local x = 6
  print(x) --> 6
end

function foo()
  local x = 5
  print(x) --> 5
  bar()
  print(x) --> 5
end

foo()

--
-- Closures
-- 
local x = 5

local function f() -- we use the "local function" syntax here, but that's just for good practice, the example will work without it
  print(x)
end

f() --> 5
x = 6
f() --> 6


local function f()
  local v = 0
  local function get()
    return v
  end
  local function set(new_v)
    v = new_v
  end
  return {get=get, set=set}
end

local t, u = f(), f()
print(t.get()) --> 0
print(u.get()) --> 0
t.set(5)
u.set(6)
print(t.get()) --> 5
print(u.get()) --> 6





