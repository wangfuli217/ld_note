-- 在OpenWrt中使用socket通信主要就是调用nixio.socket来完成。我们可以写一个模块，然后在需要使用的时候使用require来引入。
-- http://www.cnblogs.com/AUOONG/archive/2012/04/16/2451485.html
core = {}

local h = require "luci.http"
local n = require "nixio"

core.ip      = "127.0.0.1"
core.port    = 61000
core.uri     = "/BYW_ASTEST"
core.method  = "POST"
core.charset = "UTF-8"


core.rcvTimeout = 20 -- s

-- 获取get/post提交过来的数据
-- @param name 变量名称
-- @return 返回获取到的数据
function core.get(name)
    if name == "" then
        return ""
    else
        return string.gsub(h.formvalue(name) or "", '[&<>"]+', "")
    end
end

-- 封装数据
-- @param data 要发送的数据
-- @return string 封装后的http数据
function core.httpData(data)
    core.uri = string.upper(core.uri)
    return core.method .. " " .. core.uri .. " HTTP/1.1\r\n" ..
           "Host: " .. core.ip .. ":" .. core.port .. "\r\n" ..
           "Content-type: text/html;charset=" .. core.charset .. "\r\n" ..
           "Accept-Language: zh-cn\r\n" ..
           "User-Agent: Mozilla/4.0(Compatible win32; MSIE)\r\n" ..
           "Content-Length: " .. string.len(data) .. "\r\n" ..
           "Connection: close\r\n\r\n" ..
           data
end

-- 通过socket发送并接收数据
-- @param data 要发送的数据
-- @return socket运行状态与接收到的（错误）数据
function core.send(data)
    local position
    local t      = {}
    local http
    local socket = nixio.socket("inet", "stream")
    local tmp
    
    if not socket then
        return false, "创建socket失败"
    end
    
    if not socket:connect(core.ip, core.port) then
        socket:close()
        return false, "服务无响应，连接服务器 " .. core.ip .. ":" .. core.port .. " 失败"
    end
    
    socket:setopt("socket", "rcvtimeo", core.rcvTimeout)
    
    socket:send(core.httpData(data))
    
    repeat
        tmp = socket:recv(100)
        
        if tmp == false then
            socket:close()
            return false, "响应超时"
        end
        tmp = tostring(tmp)
        t[#t + 1] = tmp
    until #tmp < 1
    
    socket:close()
    
    local result = table.concat(t)
    
    position = string.find(result, "\r\n\r\n")
    
    if position == nil then
        return false, "返回的数据格式不合法。数据：" .. result
    end
    
    result = string.sub(result, string.find(result, "\r\n\r\n") + 4)
    
    return true, result
end

return core

<%
    local h = require "luci.http"
    local c = require "luci.core"
    
    local userName, password = c.get('userName'), c.get('password')

    local command  = string.format("funname=Login\r\nusername=%s\r\npassword=%s",
                     userName, password)

    h.write(c.send(command))
%>