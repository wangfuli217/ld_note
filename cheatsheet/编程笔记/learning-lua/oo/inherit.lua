Account = { balance = 0 }

--注意，此处使用冒号，可以免写self关键字；如果使用.号，第一个参数必须是self
function Account:deposit(v)
    self.balance = self.balance + v
end

--注意，此处使用冒号，可以免写self关键字；
function Account:withdraw(v)
    if self.balance > v then
        self.balance = self.balance - v
    else
--        error("insufficient funds")
        print("insufficient funds")
    end
end

--注意，此处使用冒号，可以免写self关键字；
function Account:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, { __index = self })
    return o
end

--定义继承
SpecialAccount = Account:new({ limit = 1000 }) --开启一个特殊账户类型，这个类型的账户可以取款超过余额限制1000元
function SpecialAccount:withdraw(v)
    if v - self.balance >= self:getLimit() then
--        error("insufficient funds")
        print("overflow limit")
    end
    self.balance = self.balance - v
end

function SpecialAccount:getLimit()
    return self.limit or 0
end

spacc = SpecialAccount:new()
spacc:withdraw(100)
print(spacc.balance) --> -100
acc = Account:new()
acc:withdraw(1001) --> 超出账户余额限制，抛出一个错误
