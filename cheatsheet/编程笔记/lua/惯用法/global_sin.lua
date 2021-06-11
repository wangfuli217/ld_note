a = os.clock()
for i = 1,10000000 do
  local x = math.sin(i)
end
b = os.clock()
print(b-a) --1.113454