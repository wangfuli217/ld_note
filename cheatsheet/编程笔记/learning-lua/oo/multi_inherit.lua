local function search(k, plist)
    for i = 1, table.getn(plist) do
        local v = plist[i][k] -- try 'i'-th superclass
        if v then
            return v
        end
    end
end

function createClass(...)
    local c = {} -- new class
    -- class will search for each method in the list of its
    -- parents (`args' is the list of parents)
    args = { ... }
    setmetatable(c, {
        __index = function(self, k) return search(k, args) end
    })

    -- prepare `c' to be the metatable of its instances
    c.__index = c

    -- define a new constructor for this new class
    function c:new(o)
        o = o or {}
        setmetatable(o, c)
        return o
    end

    -- return new class
    return c
end

Named = {}
function Named:getname()
    return self.name
end

function Named:setname(n)
    self.name = n
end

NamedAccount = createClass(Account, Named) --同时继承Account 和 Named两个类
account = NamedAccount:new { name = "Paul" } --使用这个多重继承类定义一个实例
print(account:getname()) --> Pauls
account:deposit(100)
print(account.balance) --> 100
