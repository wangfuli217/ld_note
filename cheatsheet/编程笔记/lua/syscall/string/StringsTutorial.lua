--
-- Quotes
--
print("hello")
print('hello')
print([[hello]])

print('hello "Lua user"')
print("Its [[content]] hasn't got a substring.")
print([[Let's have more "strings" please.]])

--
-- Escape sequences
--
print("hello \"Lua user\"")
print('hello\nNew line\tTab')

print([[hello\nNew line\tTab]])

--
-- Multiline quotes
--
str = [[Multiple lines of text
can be enclosed in double square
brackets.]]
print(str)

--
-- Nesting quotes
--
print([=[one [[two]] one]=])
print([===[one [[two]] one]===])
print([=[one [ [==[ one]=])

--
-- Concatenation
--
print("hello" .. " Lua user")
who = "Lua user"
print("hello "..who)

--
-- Coercion
--
print("This is Lua version " .. 5.1 .. " we are using.")
print("Pi = " .. math.pi)
print("Pi = " .. 3.1415927)

print(string.format("%.3f", 5.1))
print("Lua version " .. string.format("%.1f", 5.1))


--
-- Concatenation
-- 
print("hello" .. " Lua user")
who = "Lua user"
print("hello "..who)

print("Green bottles: "..10)
print(type("Green bottles: "..10))

os.exit(0)
-- slow
local s = ''
for i=1,10000 do s = s .. math.random() .. ',' end
io.stdout:write(s)

-- fast
for i=1,10000 do io.stdout:write(tostring(math.random()), ',') end

-- fast, but uses more memory
local t = {}
for i=1,10000 do t[i] = tostring(math.random()) end
io.stdout:write(table.concat(t,','), ',') 


