if(0) then
	print(0)
end
--这里需要注意的是，条件判断时，nil为false，其他确定类型则为true
--0 类型为number 因此条件判断结果为true  输出0

a=10
if a>10 then
	print(a)
else
	print(a.."<=10")
end
--输出 10<=10

if a>10 then
	print("a>10")
elseif a<10  then   --elseif中间无空格  后接then
	print("a<10")
else
	print("a=10")
end

a=1
while (a<=20) do
	if (a%2==1) then
		print(a)
	end
	a=a+1
end

for var=1,10,2 do
	print(var)
end

for var=20,10,-1 do
	print(var)
	var=var-1
end

tab1={key1="value1",key2="value2"}
for k,v in pairs(tab1) do
	print(k.."&"..v)
end

tab2={"Ò»","¶þ","Èý","ËÄ"}
for k,v in pairs(tab2) do
	print(k,v)
end

repeat
	print(a)
	a=a-2
until(a<=0)


for var=1,10,1 do
	for var1=1,var,1 do
		print(var)
	end
end

