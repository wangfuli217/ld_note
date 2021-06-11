
table1={key1="value1",key2="value2"}
print(table1.key1)
table1.key1=nil
print(table1.key1)
table1=nil
print(table1)


tab1={}  --空表 {}构造表达式
tab2={key1=100,key2="value"}  --初始化一个表
print(tab2.key1)
print(tab2["key2"])

tab3={"apple","pear","orange","grape"}
print(tab3[2])

--遍历一个表中的值
for key,val in pairs(tab3) do
	print(key..":"..val)
end


--表中数据的添加
tab1.key1="value1"
tab1["key2"]="value2"
tab1[10]=1000
print(tab1["key1"])
print(tab1.key2)
print(tab1[10])

tab1["key2"]=20
print(tab1.key2)


tab1.key2=nil
for key,val in pairs(tab1) do
	print(key..":"..val)
end