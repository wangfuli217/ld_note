a = os.clock()
local s = ''
local t = {}
for i = 1,300000 do
    t[#t + 1] = 'a'
end
s = table.concat( t, '')
b = os.clock()
print(b-a)  --0.07178