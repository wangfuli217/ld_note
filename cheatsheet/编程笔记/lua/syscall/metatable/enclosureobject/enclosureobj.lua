local function create(name ,id )
    local data = {name = name ,id = id}  --data为obj.SetName,obj.GetName,obj.SetId,obj.GetId的Upvalue
    local obj = {}  --把需要隐藏的成员放在一张表里,把该表作为成员函数的upvalue。

    function obj.SetName(name)
        data.name = name 
    end

    function obj.GetName() 
        return data.name
    end

    function obj.SetId(id)
        data.id = id 
    end

    function obj.GetId() 
        return data.id
    end

    return obj
end

--[[
实现方式:  把需要隐藏的成员放在一张表里,把该表作为成员函数的upvalue。
局限性:  基于对象的实现不涉及继承及多态。但另一方面,脚本编程是否需要继承和多态要视情况而定。 
--]]