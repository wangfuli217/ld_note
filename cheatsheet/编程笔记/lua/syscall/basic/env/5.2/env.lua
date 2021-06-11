-- A function's environment is stored in an upvalue, named _ENV. As an example, here's a function that sets its environment to a custom one and uses variables from it:

print(_ENV == _G) -- prints true, since the default _ENV is set to the global table

a = 1

local function f(t)
  local print = print -- since we will change the environment, standard functions will not be visible

  local _ENV = t -- change the environment. without the local, this would change the environment for the entire chunk

  print(getmetatable) -- prints nil, since global variables (including the standard functions) are not in the new env
  
  a = 2 -- create a new entry in t, doesn't touch the original "a" global
  b = 3 -- create a new entry in t
end

local t = {}
f(t)

print(a, b) --> 1 nil
print(t.a, t.b) --> 2 3