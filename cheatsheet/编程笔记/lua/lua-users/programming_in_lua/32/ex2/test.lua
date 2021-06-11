--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/14
-- Time: 涓嬪崍5:09
-- To change this template use File | Settings | File Templates.
--

--collectgarbage("setpause",100)
--collectgarbage("setstepmul",200)
collectgarbage("stop")
--local s = collectgarbage("count") * 1024
local st = os.clock()
for i=1,100000,1 do
    local t = { a = i ,b = string.format("%sp",i) }
--    print("create ",i)
--    print("bytes ",collectgarbage("count") * 1024)
    if i%10000 == 0 then
        collectgarbage("step",2160000)
    end
end
--collectgarbage("collect")
print("time used ", os.clock()-st," init mem ",s)
--print("begin ",s)
