require "lstring"

local s = "abc"
local tmp = string.hexlify(s)
local s2 = string.unhexlify(tmp)
assert(s2 == s, "error, unhexlify")

local s = "hello"
local s2 = "Hello"
local s3 = string.capitalize(s)
assert(s2 == s3, "error, capitalize")

local s = "aaa|bbb|ccc"
local array = string.split(s, "|")
assert(#array == 3, "error, split")

local s = "  a line\n"
s = string.strip(s)
assert(s == "a line", "error, strip")

local s = "Hello world"
local m = "llo"
assert(string.contains(s, m) == true, "error, contains")

local s = "/path/a.txt"
local sub = "txt"
assert(string.findlast(s, sub) == 9, "error, findlast")

local s = " \tabc  \n"
local s2 = "abc"
assert(string.strip(s) == s2, "error, strip")

local s = "hello\nworld"
assert(string.lines(s) == 2, "error, lines")