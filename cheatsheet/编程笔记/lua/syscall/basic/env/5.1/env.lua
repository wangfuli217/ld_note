-- The previous example rewritten for 5.1:

print(getfenv(1) == _G) -- prints true, since the default env is set to the global table

a = 1

local function f(t)
  local print = print -- since we will change the environment, standard functions will not be visible

  setfenv(1, t) -- change the environment

  print(getmetatable) -- prints nil, since global variables (including the standard functions) are not in the new env
  
  a = 2 -- create a new entry in t, doesn't touch the original "a" global
  b = 3 -- create a new entry in t
end

local t = {}
f(t)

print(a, b) --> 1 nil
print(t.a, t.b) --> 2 3