---------lua中的类---------

print('----简单的类----')
Account = {balance = 0}
function Account.withDraw(self, v)      -- 使用self参数，防止函数只能针对特定类Account工作
	self.balance = self.balance - v
end
print(Account.balance) 					-- lua的类即使没有实例化为对象，也可以调用类本身
a = Account
Account = nil
a.withDraw(a, 100)
print(a.balance)
print('----用:隐藏self参数----')
Account = {balance = 0}
function Account:withDraw(v) 			-- 使用冒号隐藏self参数
	self.balance = self.balance - v
end
a = Account
Account = nil
a:withDraw(100) 						-- 调用时，也需要冒号
print(a.balance)

----------------------------



--------------lua中的类和对象--------------

-- 1.将类实例化为对象，只需把类设为对象的元表中的__index元方法
-- 2.对象在引用类中的元素、方法时，找不到会去元表（类）中找
-- 3.同一个类实例化的两个对象，它们中的同名元素是完全不同的变量
local Account = {value = 0}
function Account:new(o)				-- 构造函数
	o = o or {}  					-- 如果用户没有提供table，则创建一个
	setmetatable(o, self)			-- 为什么要把Account先设成元表，再将Account设为元表中的__index元方法？
--                                     我试着将一个空表b设为元表，再把Account设为b的__index元方法，结果没有任何区别。怀疑这样写仅仅是为了方便
	self.__index = self
	return o
end
function Account:display()
	self.value = self.value + 100	-- 执行第一次a:display时，这里的self是a，等号右边的a.value由于找不到，故引用了Account.value的值，而等号左边的a.value则新创建
	print(self.value)
end
local a = Account:new{}				-- 这里使用Account类创建了一个对象a
a:display()
a:display()
local b=Account:new{}
b:display()							-- b和a中的value是独立的，可以看出对象a和b独立

-------------------------------------------



--------------lua中类的继承-------------

-- lua中类的继承，同类的实例化没有区别，因为lua中的类本身也是对象
Shape={lens=0,width=0}					-- 基类Shape
function Shape:new(lens,width)
	o={}
	setmetatable(o,self)
	self.__index=self
	self.lens=lens or 0
	self.width=width or 0
	return o
end
function Shape:print_area()
	local area=self.lens*self.width
	print(area)
end
Square=Shape:new()						-- 派生类Square
function Square:new(side)				-- 派生类新增函数
	o={}
	setmetatable(o,self)
	self.__index=self
	return Shape:new(side,side)
end
s1=Square:new(10)						-- 正方形对象s1
s1:print_area()
s2=Shape:new(10,20)						-- 长方形对象s2
s2:print_area()

----------------------------------------



---------------多继承---------------

-- 核心是将一个查找函数设为派生类元表的__index元方法，查找函数返回被引用的基类元素（变量或函数）
------基类CA------
local CA={}
function CA:new(o)
	o=o or {}
	setmetatable(o,self)
	self.__index=self
	return o
end
function CA:setName(name)
	self.name=name or'no name'
end
------基类CB-----
local CB={}
function CB:new(o)
	o=o or {}
	setmetatable(o,self)
	self.__index=self
	return o
end
function CB:getName()
	return self.name
end
-----继承函数-----
function createClass(...)
	local C={}
	local parents={...}
	setmetatable(C,{__index=function(t,k) return search(k,parents) end})
	function C:new(o)				-- 用于创建对象或进一步继承
		o=o or {}
		setmetatable(o,self)
		self.__index=self
		return o
	end
	return C
end
function search(k,parentslist) 		-- 在多个基类中查找调用的字段，引用为变量则返回变量值，引用为函数则返回函数本身
	for i=1,#parentslist do
		local v=parentslist[i][k]
		if v then
			print('search函数中返回的v为：',v)				-- 例如调用c：setName时，此处返回的v为函数CA.setName
			return v
		end
	end
end
-----多继承-----
local C=createClass(CA,CB)			-- 创建类C，C为CA和CB的派生类
c=C:new()							-- 创建类C的对象c
print('CA.setName:',CA.setName)
c:setName('Allen')
print('CB.getName:',CB.getName)
print(c:getName())

------------------------------------



---------用闭包保护类成员变量---------

-- 普通的类直接定义一个表，这里则是定义了一个闭包
-- 将要保护的成员存在self表内，将可供外部调用的函数存在另一个表内返回
-- 但是用闭包实现类，似乎就不能继承了
function newObject(defaultName)
	local self = {name = defaultName}
	local setName = function (v) self.name = v end
	local getName = function () return self.name end
	return {setName = setName, getName = getName}
end
local objectA = newObject("Jelly")
objectA.setName("JellyThink")
print(objectA.getName())
-------------------------------------