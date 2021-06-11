function create(name,id)
    local obj = {name = name,id = id}

    function obj:SetName(name)
        self.name = name 
    end

    function obj:GetName()
        return self.name
    end

    function obj:SetId(id)
        self.id = id
    end

    function obj:GetId()
        return self.id
    end
    return obj
end

local myCreate = create("sam",001)

for k,v in pairs(myCreate) do
    print(k,"=>",v)
end

print("myCreate's name:",myCreate:GetName(),"myCreate's id:",myCreate.GetId(myCreate))

myCreate:SetId(100)
myCreate:SetName("Hello Kity")

print("myCreate's name:",myCreate:GetName(),"myCreate's id:",myCreate:GetId())

--[[
对象实现描述
对象工厂模式
用表来表示对象
  把对象的数据和方法都放在一张表内,虽然没有隐藏私有成员,但对于简单脚本来说完全可以接受。
成员方法的定义
  function obj:method(a1, a2, ...) ... end 
  等价于function obj.method(self, a1, a2, ...) ... end 
  等价于obj.method = function (obj, a1, a2, ...) ... end
成员方法的调用
  obj:method(a1, a2, ...) 等价于obj.method(obj, a1, a2, ...) 
--]]
