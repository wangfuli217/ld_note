local mk = require("multikey")

local get, put = mk.get, mk.put

local t = { 1 }

put(t, 1, 2, "value1")
put(t, 1, nil, 3, "value2")
put(t, 1, 2, 3, "value3")
put(t, "value4") -- zero keys is possible as well
print(get(t, 1, 2)) -->  value1
print(get(t, 1, nil, 3)) -->  value2
print(get(t, 1, 2, 3)) -->  value3
print(get(t, 1)) -->  nil
print(get(t)) -->  value4
print(t[1]) -->  1
