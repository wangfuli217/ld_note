local str = "abcde"
print("case 1:", str:sub(1, 2))
print("case 2:", str.sub(str, 1, 2))

print("#####")

obj = {x = 20 }

function obj:fun1()
    print(self.x)
end

-- 等价于

function obj.fun2(self)
    print(self.x)
end
