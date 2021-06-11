--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/10
-- Time: 下午3:02
-- To change this template use File | Settings | File Templates.
--
print("aaaa")
lib.settrans({a="1",b="2",c=false,d="4"})
local t = lib.gettrans()

for k,v in pairs(t) do
    print(k.."="..tostring(v))
end

local r = lib.trans("abcd")
print(r)

