--[[
Lua中面向对象的实现是通过表来实现
table+function
table在Lua中是引用类型
对于一个对象来说 拥有 属性+方法
--]]

--一个简单的面向对象实例
person={name="bobo",age=24}
person.eat=function()
	print(person.name.."在吃饭")
end

person.eat()

--当前的面向对象存在一定的问题，比如并不能完成实例化
--另外还有一个问题
--[[
a=person
person=nil
a.eat()   --这时会报错，因为 eat 方法里引用的是 person ，解决方法是在eat方法里传递self,将自身作为参数
--]]

person2={name="bobo2",age=24}
person2.eat=function(self)
	print(self.name.."在吃饭")
end

b=person2
person2=nil
b.eat(b)

--也可以通过修改方法的定义，将.改为: 不用传递self参数,方法内部可以使用self变量来表示调用该方法的自身
--这样方法的复用性提高
person3={name="bobo3",age=24}
function person3:eat()
	print(self.name.."在吃饭")
end

c=person3
person3=nil
c.name="bobo4"
c:eat() --输出 bobo4在吃饭
--调用的时候也可以通过.来调用但是需要手动传递自身作为参数
c.eat(c)--输出 bobo4在吃饭


--利用new方法和元表来实现实例化过程
Person={name="BOBO",age=25}
function Person:eat()
	print(self.name.."在吃饭")
	print(self.name.."的年龄是："..self.age)
end
function Person:new()
	local t={}
	setmetatable(t,{__index=self})
	return t
end
--这里使用new方法返回一个空表t,空表t的元表__index方法指向调用者（这里是Person）自身这个表,
--当使用new方法完成赋值后，得到的实际上是一个空表，当访问一个name 属性时，此时表内不存在，就会向元表中的__index
--所指向的表去寻找
--而为new方法赋值后的表再重新为name 等属性赋值后，再去访问，这时表内已存在对应属性，就不会调用__index内的属性了
d=Person:new()
d.eat(d)
--输出
--BOBO在吃饭
--BOBO的年龄是：25
d.name="BOBO2"
d.age=29
d:eat()
--输出
--BOBO2在吃饭
--BOBO2的年龄是：29

--这样通过new方法和元表就能将Person作为一个模板，去实例化多个Person对象了

--通过向new方法传递一个表作为参数和 or 来扩展模板
Person2={name="BOBO",age=25}
function Person2:eat()
	print(self.name.."在吃饭")
	print(self.name.."的年龄是："..self.age)
end
function Person2:new(tab)
	local t=tab or {}    --当传递过来的o是一个具体的表时，将在这个表的基础上添加模板内容，若想通过模板来构建一个新的对象，传递nil
	setmetatable(t,{__index=self})
	return t
end

e1=Person2:new({weight=130})
print(e1.weight)
e2=Person2:new(nil)
e2:eat()
--输出
--130
--BOBO在吃饭
--BOBO的年龄是：25


--通过返回表来实现继承
Person3={name="BOBO3",age=27}
function Person3:ptf()
	print("姓名："..self.name.."---年龄："..self.age)
end
function Person3:new(o)
	local t=o or {}
	setmetatable(t,self)
	self.__index=self
	return t
end

Student=Person3:new({grade=1})    --这里Student的元表是Person3
student=Student:new()             --student的元表是Student，因此形成继承关系
student:ptf()
print("所在年级:"..student.grade)
--输出
--姓名：BOBO3---年龄：27
--所在年级:1