require "url"

local s = "a%2Bb+%3D+c"
local s2 = "a+b = c"
assert(unescape(s) == s2)

assert(escape(s2) == s)
t = {name = "al", query = "a+b = c", q = "yes or no"}
print(encode(t)) --> q=yes+or+no&query=a%2Bb+%3D+c&name=al