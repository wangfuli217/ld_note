--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/9
-- Time: 下午12:25
-- To change this template use File | Settings | File Templates.
--
local co = coroutine.create(function()
    foreach({a=1,b=2,c=4},function(k,v)
        couroutine.yield()
        print(k.."="..v)

    end)
end)
coroutine.resume(co)

