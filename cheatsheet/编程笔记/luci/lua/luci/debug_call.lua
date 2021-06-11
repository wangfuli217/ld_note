-- 另外luci程序自带了一个debug模块, 这是一个用来分析内存占用情况的模块, 
-- 你也可以在dispatcher.lua模块中开启.它的信息记录在/tmp/memtrace中.

local debug = require "debug" -- Lua标准库: debug
local io = require "io"
local collectgarbage, floor = collectgarbage, math.floor
 
module "luci.debug"
--获取本文件的文件名
__file__ = debug.getinfo(1, 'S').source:sub(2)
 
-- Enables the memory tracer with given flags and returns a function to disable the tracer again
-- 启动内存跟踪，并返回用以关闭内存跟踪的函数
function trap_memtrace(flags, dest)
        -- 调试跟踪哪些事件，调试共可跟踪四类事件，call/return/line/count, 默认跟踪
        -- 函数调用(call)、函数返回(return)、行执行(line)三类事件
    flags = flags or "clr"
    local tracefile = io.open(dest or "/tmp/memtrace", "w")
    local peak = 0 -- Lua程序使用的内存峰值，kbyte为单位
        -- 上述事件的HOOK函数
    local function trap(what, line)
                -- 获取stack level为2的堆栈信息，举例来说，
                -- 从A函数返回(return)之时触发本trap函数，则获取A函数的堆栈信息
        local info = debug.getinfo(2, "Sn")
                -- Lua当前使用的总内存，kbytes为单位
        local size = floor(collectgarbage("count"))
        if size > peak then
            peak = size
        end
                -- 堆栈信息的解释参考Programming in Lua 3rd, Chap24, debug
        if tracefile then
            tracefile:write(
                "[", what, "] ", info.source, ":", (line or "?"), "\t",
                (info.namewhat or ""), "\t",
                (info.name or ""), "\t",
                size, " (", peak, ")\n"
            )
        end
    end
 
        -- 设置HOOK，并使之生效
    debug.sethook(trap, flags)
 
    return function()
        debug.sethook() -- 不带参数的sethook，会清理之前的HOOK
        tracefile:close() 
    end
end