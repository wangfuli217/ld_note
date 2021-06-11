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
        error("insufficient funds")
    end
end

--注意，此处使用冒号，可以免写self关键字；
function Account:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, { __index = self })
    return o
end

a = Account:new()
a:deposit(100)
b = Account:new()
b:deposit(50)
print(a.balance) -->100
print(b.balance) -->50
