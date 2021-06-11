#!/usr/local/bin/lua
-- lua脚本文件使用ansi编码方式保存
-- Lua的索引都是从1开始

-- Lua元表Metatable

print([[table中可访问对应key来得到value值，却无法对两个table进行操作。
	因此Lua提供了元表（Metatable），允许改变table的行为，每个行为关联
	了对应的元方法。
	如，使用元表可定义lua如何计算两个table的相加操作a+b。
	当lua试图对两个表进行相加时，先检查两者之一是否有元素，之后检查是
	否有一个叫”__add“的字段，若找到，则调用对应的值。”__add“等即时字段，
	其对应值（往往是一个函数或是table）就是”元方法“。
	两个很重要函数来处理元表：
		1.setmetatable(table,metatable)：对指定table设置元表（metatable），
		如元表（metatable）中存在__metatable键值，setmetatable会失败。
		2.getmetatable(table)：返回对象的元表（metatable）。]])

mytable={} -- 普通表
mymetatable = {} -- 元表
setmetatable(mytable,mymetatable) -- 把mymetatable设为mytable的元表

-- 直接写
mytable = setmetatable({},{})

getmetatable(mytable) -- 这回返回mymetatable

-- __index元方法
print("__index元方法")
other = {foo=3}
t=setmetatable({},{__index=other})
print(t.foo)
print(t.bar)

mytable = setmetatable({key1="value1"},{
	__index = function(mytable,key)
		if key == "key2" then
			return "metatablevalue"
		else
			return nil
		end
	end
})

print(mytable.key1,mytable.key2)

-- __newindex元方法

-- __call 元方法

-- __tostring元方法