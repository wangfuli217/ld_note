-- When loading a chunk, the top-level function gets a new _ENV upvalue, and any nested functions inside it can see it. You can pretend that when loading works something like this:

local _ENV = _G
return function (...) -- this function is what's returned from load
  -- code you passed to load goes here, with all global variable names replaced with _ENV lookups
  -- so, for example "a = b" becomes "_ENV.a = _ENV.b" if neither a nor b were declared local
end