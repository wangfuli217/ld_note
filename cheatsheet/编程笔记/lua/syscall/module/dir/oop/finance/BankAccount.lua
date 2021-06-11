local M = {}; M.__index = M

local function construct()
    local self = setmetatable({balance = 0}, M) 
    return self
end

setmetatable(M, {__call = construct})

function M:add(value) self.balance = self.balance + value end

return M
