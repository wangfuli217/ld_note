local function CreateRobot(name,id)
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

local function createFootballRobot(name ,id ,position)
    local obj = CreateRobot(name ,id)
    obj.position = "right back"

    function obj:SetPosition(p)
        self.position = p
    end

    function obj:GetPosition() 
        return self.position
    end

    return obj
end

local mycreateFootballRobot = createFootballRobot("Tom",1000,"广州")

print("mycreateFootballRobot's name:",mycreateFootballRobot:GetName(),"myCreate's id:",mycreateFootballRobot:GetId(),mycreateFootballRobot:GetPosition())

mycreateFootballRobot:SetName("麦迪")
mycreateFootballRobot:SetId(2000)
mycreateFootballRobot:SetPosition("北京")
print("mycreateFootballRobot's name:",mycreateFootballRobot:GetName(),"myCreate's id:",mycreateFootballRobot:GetId(),mycreateFootballRobot:GetPosition())

--[[
简单继承优缺点
优点:  简单、直观
缺点:  传统、不够动态 
--]]