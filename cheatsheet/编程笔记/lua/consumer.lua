--  生产者／消费者 模型
-- 生产者调用yield将生产的数据返回给消费者；消费者消费完数据后通过resume触发生产者再次生产数据
local producer = coroutine.create(function()
    while true do
        local x = io.read()
        coroutine.yield(x)
    end
end)
function receive()
    local status, value = coroutine.resume(producer)
    return value
end

-- 实现过滤器 - filter
-- 我们可以使用过滤器扩展这个设计，过滤器指在生产者与消费者之间，可以对数据进行某些转换处理。
-- 过滤器在同一时间既是生产者又是消费者，他请求生产者生产值并且转换格式后传给消费者，
-- 我们修改上面的代码加入过滤器（给每一行前面加上行号）。
function receive(prod)
    local status, value = coroutine.resume(prod)
    return value
end
function send(x)
    coroutine.yield(x)
end
function producer()
    return coroutine.create(function()
        while true do
            local x = io.read()
            send(x)
        end
    end)
end

function filter(prod)
    return coroutine.create(function ()
        for line = 1, math.huge do
            local x = receive(prod)
            x = string.format("%5d %s", line, x)
            send(x)
        end
    end)
end
function consumer(prod)
    while true do
        local x = receive(prod)
        io.write(x, "\n")
    end
end

local p = producer()
f = filter(p)
--consumer(f)
consumer(filter(producer()))


-- 1.生产者-消费者
-- 　　（1）生产者-消费者一般程序表示：
-- 　　　　　　function producer() --生产者                           function consumer() --消费者
-- 　　　　　　　　while true do　　　　　　　　　　　　　　　　　　　　　while true do　　　
-- 　　　　　　　　　　local x = io.read()　　　　　　　　　　　　　　　　　　local x = receive()
-- 　　　　　　　　　　send(x)　　　　　　　　　　　　　　　　　　　　　　　  io.write(x,"\n")
-- 　　　　　　　　end 　　　　　　　　　　　　　　　　　　　　　　　　　　end 
-- 　　　　　　end 　　　　　　　　　　　　　　　　　　　　　　　　　end 
-- 　　　　　　问题关键：如何将send和receive匹配起来？
-- 　　（2）生产者-消费者协同程序实现　　　
-- 　　　　　　function send(x) --协同程序主函数中被调用，因而可以调用yield
-- 　　　　　　　　coroutine.yield(x) --参数x将作为resume的返回值
-- 　　　　　　end
-- 　　　　　　producer = coroutine.create( function()  --在这里可以理解为生产者
-- 　　　　　　　　　　　　while true do
-- 　　　　　　　　　　　　　　local x = io.read() --输入，这里可理解为生产的东西
-- 　　　　　　　　　　　　　　send(x)
-- 　　　　　　　　　　　　end
-- 　　　　　　　　　　end)
-- 　　　　　　function receive()  --在这里可以理解为消费者
-- 　　　　　　　　local status, value = coroutine.resume(producer) --启动协同程序
-- 　　　　　　　　return value
-- 　　　　　　end
--     程序通过调用消费者receive()来唤醒生产者（即协同程序），然后通过将“生产的”内容x作为参数传递给yield,最后作为resume的返回值，赋给value(即消费者得到生产者生产的东西)
--     实质上利用了一对resume-yield交换数据。