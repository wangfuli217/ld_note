a = os.clock()
local s = ''
for i = 1,300000 do
    s = s .. 'a'
end
b = os.clock()
print(b-a)  --6.649481