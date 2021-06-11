a = os.clock()
for i = 1,2000000 do
    local a = {}
    a[1] = 1; a[2] = 2; a[3] = 3
end
b = os.clock()
print(b-a)  --1.528293