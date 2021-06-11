> m = require "mymodule"
> print(_G.m)
table: 0x15b0390  -- table m is a pointer; reference is 0x15b0390
> for k,v in pairs(_G.m) do
>> print(k,v)
>> end
bar     function: 0x15b03e0
foo     function: 0x15b10c0
> _G.m.bar()
in private function
Hello World!
> m.bar()
in private function
Hello World!
> m.foo()
Hello World!
> print(package.loaded.mymodule)
table: 0x15b0390 -- table package.loaded.mymodule is a pointer; reference is 0x15b0390
-- package.loaded.mymodule == _G.m 

> package.loaded.mymodule = nil -- dec mymodule table refcnt, but _G.m reference again
-- package.loaded.mymodule = nil, _G.m reference mymodule table, so mymodule also in lua 

> m.foo()
Hello World!
> m.bar()
in private function
Hello World!
> collectgarbage("collect")
-- collect garbage; mymodule also in lua by used _G.m

> print(package.loaded.mymodule)
nil
