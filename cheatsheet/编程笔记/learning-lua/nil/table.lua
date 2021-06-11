local a = {}
local b = { name = "Bob", sex = "Male" }
local c = { "Male", "Female" }
local d = nil

print(#a)
print(#b)
print(#c)
--print(#d)    -- error

if a == nil then
    print("a == nil")
end

if b == nil then
    print("b == nil")
end

if c == nil then
    print("c == nil")
end

if d == nil then
    print("d == nil")
end

if _G.next(a) == nil then
    print("_G.next(a) == nil")
end

if _G.next(b) == nil then
    print("_G.next(b) == nil")
end

if _G.next(c) == nil then
    print("_G.next(c) == nil")
end

-- error
--if _G.next(d) == nil then
--    print("_G.next(d) == nil")
--end